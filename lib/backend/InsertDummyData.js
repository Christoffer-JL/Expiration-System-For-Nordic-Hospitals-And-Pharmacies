const mysql = require("mysql");

const dbConfig = {
  host: "sql11.freesqldatabase.com",
  user: "sql11653843",
  password: "ri3ZrApRl4",
  database: "sql11653843",
  port: 3306,
};

const dataToInsert = [
  {
    ProductCode: 1,
    Packaging: "Bottle",
    NordicNumber: 12345,
    ArticleName: "Painkiller A",
  },
  {
    ProductCode: 2,
    Packaging: "Box",
    NordicNumber: 67890,
    ArticleName: "Antibiotic B",
  },
  {
    ProductCode: 3,
    Packaging: "Blister Pack",
    NordicNumber: 54321,
    ArticleName: "Cough Syrup C",
  },
  {
    ProductCode: 4,
    Packaging: "Bottle",
    NordicNumber: 98765,
    ArticleName: "Painkiller D",
  },
  {
    ProductCode: 5,
    Packaging: "Box",
    NordicNumber: 43210,
    ArticleName: "Vitamin E",
  },
];

const connection = mysql.createConnection(dbConfig);

connection.connect((err) => {
  if (err) {
    console.error("Error connecting to the database:", err);
    return;
  }

  console.log("Connected to the database");

  dataToInsert.forEach((product) => {
    connection.query(
      "INSERT IGNORE INTO Products SET ?",
      product,
      (insertErr, results) => {
        if (insertErr) {
          console.error("Error inserting data:", insertErr);
        } else {
          console.log("Data inserted:", results);
        }
      }
    );
  });

  connection.end((endErr) => {
    if (endErr) {
      console.error("Error closing the connection:", endErr);
    } else {
      console.log("Connection closed");
    }
  });
});
