const express = require("express");
const bodyParser = require("body-parser");
var cors = require("cors");
const db = require("./db");
const { exec } = require("child_process");

const app = express();

app.use(bodyParser.json());
app.use(cors());

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

// Webhook for deployment script
app.post("/webhook", (req, res) => {
  try {
    exec("./deploy.sh", (error, stdout, stderr) => {
      res.status(200).json({ message: "Deployment successful" });
    });
  } catch (err) {
    res.status(500).json({ message: "Internal Server Error" });
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

// Fetches entries for catalogue purposes
app.get("/entries-with-departments", (req, res) => {
  const query = `
    SELECT
        e.ProductCode,
        e.BatchNumber,
        e.ExpirationDate,
        p.Packaging,
        p.NordicNumber,
        p.ArticleName,
        (
            SELECT GROUP_CONCAT(DISTINCT DepartmentName SEPARATOR ', ')
            FROM DepartmentEntryLinks del
            WHERE del.ProductCode = e.ProductCode
            AND del.ExpirationDate = e.ExpirationDate
        ) AS Departments
    FROM Entries e
    JOIN Products p ON e.ProductCode = p.ProductCode
    WHERE EXISTS (
        SELECT 1
        FROM DepartmentEntryLinks del
        WHERE del.ProductCode = e.ProductCode
        AND del.ExpirationDate = e.ExpirationDate
    )
    ORDER BY e.ExpirationDate;`;

  db.query(query, (err, results) => {
    if (err) {
      res
        .status(500)
        .json({ error: "Error retrieving entries with departments" });
    } else {
      res.status(200).json(results);
    }
  });
});

// Fetches all departments that have a specific entry
app.get("departments-containing-entry", (req, res) => {
  const departmentId = req.query.DepartmentId;
  const query =
    "SELECT DepartmentName FROM DepartmentEntryLinks WHERE ProductCode = ? AND BatchNumber = ?";
  db.query(query, [ProductCode, BatchNr], (err, results) => {
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
  const {
    DepartmentName,
    BatchNr,
    NordicNumber,
    ProductName,
    ExpirationDate,
    Packaging,
  } = req.query;
  const subquery = `
    SELECT
        e.BatchNumber,
        e.ExpirationDate,
        p.Packaging,
        p.NordicNumber,
        p.ArticleName,
        (
            SELECT GROUP_CONCAT(DISTINCT DepartmentName SEPARATOR ', ')
            FROM DepartmentEntryLinks del
            WHERE del.ProductCode = e.ProductCode
            AND del.ExpirationDate = e.ExpirationDate
            
        ) AS Departments
    FROM Entries e
    JOIN Products p ON e.ProductCode = p.ProductCode
    WHERE EXISTS (
        SELECT 1
        FROM DepartmentEntryLinks del
        WHERE del.ProductCode = e.ProductCode
        AND del.ExpirationDate = e.ExpirationDate
     
    )
  `;
  let query = `SELECT * FROM (${subquery}) AS subresult`;

  const conditions = [];
  const values = [];
  if (DepartmentName) {
    conditions.push("subresult.Departments LIKE ?");
    values.push(`%${DepartmentName}%`);
  }
  if (BatchNr) {
    conditions.push("subresult.BatchNumber LIKE ?");
    values.push(`%${BatchNr}%`);
  }
  if (NordicNumber) {
    conditions.push("subresult.NordicNumber LIKE ?");
    values.push(`%${NordicNumber}%`);
  }
  if (ProductName) {
    conditions.push("subresult.ArticleName LIKE ?");
    values.push(`%${ProductName}%`);
  }
  if (Packaging) {
    conditions.push("subresult.Packaging LIKE ?");
    values.push(`%${Packaging}%`);
  }
  if (ExpirationDate) {
    conditions.push("subresult.ExpirationDate = ?");
    values.push(ExpirationDate);
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

// Get entries with expiration dates in the upcoming month and those that have already expired
app.get("/expiration-entries", (req, res) => {
  const query =
    "SELECT DEL.ProductCode, DEL.DepartmentName, E.ExpirationDate, P.Packaging, P.ArticleName " +
    "FROM DepartmentEntryLinks DEL " +
    "JOIN Entries E ON DEL.ProductCode = E.ProductCode AND DEL.ExpirationDate = E.ExpirationDate " +
    "JOIN Products P ON E.ProductCode = P.ProductCode " +
    "JOIN Departments D ON DEL.DepartmentName = D.DepartmentName " +
    "WHERE E.ExpirationDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 1 MONTH)";

  db.query(query, (err, results) => {
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
  
  // Check if the entry already exists for the specified department and product
  const checkQuery =
    "SELECT COUNT(*) AS entryCount FROM DepartmentEntryLinks WHERE DepartmentName = ? AND ProductCode = ? AND ExpirationDate = ?";
  
  db.query(
    checkQuery,
    [DepartmentName, ProductCode, ExpirationDate],
    (checkErr, checkResults) => {
      if (checkErr) {
        res.status(500).json({ error: "Error checking entry existence" });
      } else {
        const entryCount = checkResults[0].entryCount;

        if (entryCount === 0) {
          // Entry does not exist, insert a new entry
          const insertQuery =
            "INSERT INTO DepartmentEntryLinks (DepartmentName, ProductCode, BatchNumber, ExpirationDate) VALUES (?, ?, ?, ?)";
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
          // Entry already exists
          res.status(200).json({
            message: "Entry for the specified department and product already exists",
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
app.delete("/delete-medication", (req, res) => {
  const { ProductCode, DepartmentName, ExpirationDate } = req.body;
  const deleteQuery =
    "DELETE From DepartmentEntryLinks WHERE ProductCode = ? AND ExpirationDate = ? AND DepartmentName = ?";

  db.query(
    deleteQuery,
    [ProductCode, ExpirationDate, DepartmentName],
    (err, results) => {
      if (err) {
        res.status(500).json({ error: "Error deleting medication" });
      } else {
        res.status(200).json({ message: "Medication deleted successfully" });
      }
    }
  );
});
