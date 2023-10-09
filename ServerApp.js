/*
 * Run server with "node ServerApp.js"
 * Exit with Ctrl+c
 */

// Import required modules
const express = require("express");
const bodyParser = require("body-parser");

// Create an Express application
const app = express();

// Use middleware to parse JSON requests
app.use(bodyParser.json());

// Start the server
const port = process.env.PORT || 3000; // Use the specified port or 3000 as a default
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

const mysql = require("mysql");

const db = mysql.createConnection({
  host: "sql11.freesqldatabase.com",
  user: "sql11652098",
  password: "X1j3W3Q5Ir",
  database: "sql11652098",
  port: 3306,
});

// Connect to MySQL
db.connect((err) => {
  if (err) {
    console.error("Error connecting to MySQL:", err);
  } else {
    console.log("Connected to MySQL");
  }
});

app.get("/department", (req, res) => {
  const data = req.body.data;
  // TODO: Get department name with help of DepartmentId
  es.status(200).json({ message: "" });
});

app.get("/entries", (req, res) => {
  const data = req.body.data;
  /* TODO: Get entries with filters. If no filter is provided, return all entries.
   * Filters should allow for filtration on DepartmentName, BatchNr, ProductCode, ProductName
   */
  es.status(200).json({ message: "" });
});

app.get("/expiration-entries", (req, res) => {
  const data = req.body.data;
  // TODO: Get all entries with expiration date that has an expiration date in the following 3 months.
  es.status(200).json({ message: "" });
});

// Requires e-VIS
app.get("/entry", (req, res) => {
  const data = req.body.data;
  // TODO: Get ProductName and ProductNumber with help of ProductCode (This can change depending on how the // API works)
  es.status(200).json({ message: "" });
});

app.post("/remove-entry-from-single-departement", (req, res) => {
  const data = req.body.data;
  // TODO: Removes an entry from a single specified department
  es.status(200).json({ message: "" });
});

app.post("/remove-entry-from-all-departments", (req, res) => {
  const data = req.body.data;
  // TODO: Removes an entry from all departments
  es.status(200).json({ message: "" });
});

app.post("/add-entry", (req, res) => {
  const data = req.body.data;
  // TODO: Adds an entry to the database with a unique ProductNumber, ExpirationDate, ProductName, BatchNr and // ProductCode
  es.status(200).json({ message: "" });
});

// Requires e-VIS
app.post("/add-new-entry-type", (req, res) => {
  const data = req.body.data;
  // TODO: Adds a new ProductNumber mapped to unique ProductName
  es.status(200).json({ message: "" });
});
