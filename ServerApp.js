/*
 * Start server with "node ServerApp.js"
 */

const express = require("express");
const bodyParser = require("body-parser");

const app = express();

app.use(bodyParser.json());

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

const mysql = require("mysql");

const db = mysql.createConnection({
  host: "sql11.freesqldatabase.com",
  user: "sql11653843",
  password: "ri3ZrApRl4",
  database: "sql11653843",
  port: 3306,
});

module.exports = app;

db.connect((err) => {
  if (err) {
    console.error("Error connecting to MySQL:", err);
  } else {
    console.log("Connected to MySQL");
  }
});

// Fetches all departments
app.get("/all-departments", (req, res) => {
  const departmentId = req.query.DepartmentId;
  const query = "SELECT * FROM Departments";
  db.query(query, [departmentId], (err, results) => {
    if (err) {
      res.status(500).json({ error: "Error getting department names" });
    } else {
      res.status(200).json(results);
    }
  });
});

// Fetches all products
app.get("/all-product-names", (req, res) => {
  const articleName = req.query.ArticleName;
  const query = "SELECT ArticleName FROM Products";
  db.query(query, [articleName], (err, results) => {
    if (err) {
      res.status(500).json({ error: "Error getting product names" });
    } else {
      res.status(200).json(results);
    }
  });
});

app.get("/all-entries", (req, res) => {
  const query = `
    SELECT 
      P.ArticleName AS ArticleName, 
      E.ProductCode AS ProductCode, 
      E.BatchNumber AS BatchNumber, 
      E.ExpirationDate AS ExpirationDate, 
      DEL.DepartmentName AS DepartmentName 
    FROM 
      Products AS P 
    INNER JOIN Entries AS E ON P.ProductCode = E.ProductCode 
    INNER JOIN DepartmentEntryLinks AS DEL ON E.ProductCode = DEL.ProductCode AND E.BatchNumber = DEL.BatchNumber;`;

  db.query(query, (err, results) => {
    if (err) {
      res.status(500).json({ error: "Error getting product names" });
    } else {
      res.status(200).json(results);
    }
  });
});


// Get all entries with optional provided filters
app.get("/entries", (req, res) => {
  const { DepartmentName, BatchNr, ProductCode, ProductName } = req.query;
  let query =
    "SELECT E.*, P.Packaging, P.NordicNumber, P.ArticleName FROM Entries E";
  const conditions = [];
  const values = [];

  query += " JOIN Products P ON E.ProductCode = P.ProductCode";

  if (DepartmentName) {
    conditions.push("E.DepartmentName = ?");
    values.push(DepartmentName);
  }
  if (BatchNr) {
    conditions.push("E.BatchNumber = ?");
    values.push(BatchNr);
  }
  if (ProductCode) {
    conditions.push("E.ProductCode = ?");
    values.push(ProductCode);
  }
  if (ProductName) {
    conditions.push("P.ArticleName = ?");
    values.push(ProductName);
  }

  if (conditions.length > 0) {
    query += " WHERE " + conditions.join(" AND ");
  }

  db.query(query, values, (err, results) => {
    if (err) {
      res.status(500).json({ error: "Error getting entries" });
    } else {
      res.status(200).json(results);
    }
  });
});

// Get all entries with expiration date in the next 3 months
app.get("/expiration-entries", (req, res) => {
  const currentDate = new Date();
  currentDate.setMonth(currentDate.getMonth() + 3);
  const query =
    "SELECT E.*, P.Packaging, P.NordicNumber, P.ArticleName FROM Entries E JOIN Products P ON E.ProductCode = P.ProductCode WHERE E.ExpirationDate <= ?";

  db.query(query, [currentDate], (err, results) => {
    if (err) {
      res.status(500).json({ error: "Error getting expiration entries" });
    } else {
      res.status(200).json(results);
    }
  });
});

// Inserts an entry into a department. If there is no entry in the Entries table, add there first
app.post("/insert-entry-in-department", (req, res) => {
  const { DepartmentName, ProductCode, BatchNumber, ExpirationDate } = req.body;
  const checkQuery =
    "SELECT COUNT(*) AS entryCount FROM Entries WHERE DepartmentName = ? AND ProductCode = ?";

  db.query(
    checkQuery,
    [DepartmentName, ProductCode],
    (checkErr, checkResults) => {
      if (checkErr) {
        res.status(500).json({ error: "Error checking entry existence" });
      } else {
        const entryCount = checkResults[0].entryCount;

        if (entryCount === 0) {
          const insertQuery =
            "INSERT INTO Entries (DepartmentName, ProductCode, BatchNumber, ExpirationDate) VALUES (?, ?, ?, ?)";
          db.query(
            insertQuery,
            [DepartmentName, ProductCode, BatchNumber, ExpirationDate],
            (insertErr, insertResults) => {
              if (insertErr) {
                res.status(500).json({ error: "Error inserting entry" });
              } else {
                res
                  .status(201)
                  .json({ message: "Entry inserted successfully" });
              }
            }
          );
        } else {
          res.status(200).json({
            message:
              "Entry for the specified department and product already exists",
          });
        }
      }
    }
  );
});

// Remove an entry from a single specified department
app.post("/remove-entry-from-single-department", (req, res) => {
  const { ProductCode, BatchNumber, DepartmentName } = req.body;
  const query =
    "DELETE FROM DepartmentEntryLinks WHERE ProductCode = ? AND BatchNumber = ? AND DepartmentName = ?";

  db.query(
    query,
    [ProductCode, BatchNumber, DepartmentName],
    (err, results) => {
      if (err) {
        res.status(500).json({ error: "Error removing entry from department" });
      } else {
        res.status(200).json({ message: "Entry removed from department" });
      }
    }
  );
});

// Inserts a new entry if ProductCode is provided through automatic registry
app.post("/insert-entry-automatic", (req, res) => {
  const { ProductCode, BatchNumber, ExpirationDate } = req.body;
  const productCheckQuery =
    "SELECT COUNT(*) AS productCount FROM Products WHERE ProductCode = ?";

  db.query(
    productCheckQuery,
    [ProductCode],
    (productCheckErr, productCheckResults) => {
      if (productCheckErr) {
        res.status(500).json({ error: "Error checking product existence" });
      } else {
        const productCount = productCheckResults[0].productCount;

        if (productCount === 0) {
          res
            .status(400)
            .json({ error: "ProductCode does not exist in Products" });
        } else {
          const insertQuery =
            "INSERT INTO Entries (ProductCode, BatchNumber, ExpirationDate) VALUES (?, ?, ?)";
          db.query(
            insertQuery,
            [ProductCode, BatchNumber, ExpirationDate],
            (err, results) => {
              if (err) {
                res.status(500).json({ error: "Error inserting entry" });
              } else {
                res
                  .status(201)
                  .json({ message: "Entry inserted successfully" });
              }
            }
          );
        }
      }
    }
  );
});

// Inserts a new entry if NordicNumber is provided through manual registry
app.post("/insert-entry-manual", (req, res) => {
  const { NordicNumber, BatchNumber, ExpirationDate } = req.body;
  const productCheckQuery =
    "SELECT ProductCode FROM Products WHERE NordicNumber = ?";

  db.query(
    productCheckQuery,
    [NordicNumber],
    (productCheckErr, productCheckResults) => {
      if (productCheckErr) {
        res.status(500).json({ error: "Error checking product existence" });
      } else if (productCheckResults.length === 0) {
        res
          .status(400)
          .json({ error: "NordicNumber does not exist in Products" });
      } else {
        const ProductCode = productCheckResults[0].ProductCode;
        const insertQuery =
          "INSERT INTO Entries (ProductCode, BatchNumber, ExpirationDate) VALUES (?, ?, ?)";
        db.query(
          insertQuery,
          [ProductCode, BatchNumber, ExpirationDate],
          (err, results) => {
            if (err) {
              res.status(500).json({ error: "Error inserting entry" });
            } else {
              res.status(201).json({ message: "Entry inserted successfully" });
            }
          }
        );
      }
    }
  );
});
