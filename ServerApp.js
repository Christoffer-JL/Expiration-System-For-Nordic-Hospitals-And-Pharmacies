/*
 * Run server with "node ServerApp.js"
 * Exit with Ctrl+c
 */

const express = require("express");
const bodyParser = require("body-parser");
const mysql = require("mysql2");
const Client = require("ssh2").Client; // Import SSH2 client

const app = express();

app.use(bodyParser.json());

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

// SSH Configuration
const sshConfig = {
  host: "192.168.0.110",
  port: 22, // Default SSH port
  username: "christoffer1917",
  password: "rspi_temp",
};

// MySQL Database Configuration
const dbConfig = {
  host: "localhost", // MariaDB will be available locally through the SSH tunnel
  port: "/var/run/mysqld/mysqld.sock",
  user: "root",
  password: "password",
  database: "mysql",
};

// Create an SSH tunnel
const ssh = new Client();
ssh.on("ready", () => {
  console.log("SSH tunnel established");

  // Create MySQL connection via SSH tunnel
  const db = mysql.createConnection(dbConfig);

  db.connect((err) => {
    if (err) {
      console.error("Error connecting to MariaDB:", err);
    } else {
      console.log("Connected to MariaDB");
    }
  });

  // Add this error handler
  db.on("error", (err) => {
    console.error("MySQL error:", err);
  });

  // Define your routes and logic here

  // Close the SSH tunnel and MySQL connection when the server shuts down
  app.on("close", () => {
    ssh.end();
    db.end();
  });
});

// Connect to the SSH server
ssh.connect(sshConfig);

// Define your routes and logic here

// Close the SSH tunnel and MySQL connection when the server shuts down
app.on("close", () => {
  ssh.end();
});

app.get("/department", (req, res) => {
  const data = req.body.data;
  // TODO: Get department name with help of DepartmentId
  res.status(200).json({ message: "" });
});

app.get("/entries", (req, res) => {
  const data = req.body.data;
  /* TODO: Get entries with filters. If no filter is provided, return all entries.
   * Filters should allow for filtration on DepartmentName, BatchNr, ProductCode, ProductName
   */
  res.status(200).json({ message: "" });
});

app.get("/expiration-entries", (req, res) => {
  const data = req.body.data;
  // TODO: Get all entries with expiration date that has an expiration date in the following 3 months.
  res.status(200).json({ message: "" });
});

// Requires e-VIS
app.get("/entry", (req, res) => {
  const data = req.body.data;
  // TODO: Get ProductName and ProductNumber with help of ProductCode (This can change depending on how the // API works)
  res.status(200).json({ message: "" });
});

app.post("/remove-entry-from-single-departement", (req, res) => {
  const data = req.body.data;
  // TODO: Removes an entry from a single specified department
  res.status(200).json({ message: "" });
});

app.post("/remove-entry-from-all-departments", (req, res) => {
  const data = req.body.data;
  // TODO: Removes an entry from all departments
  res.status(200).json({ message: "" });
});

app.post("/add-entry", (req, res) => {
  const data = req.body.data;
  // TODO: Adds an entry to the database with a unique ProductNumber, ExpirationDate, ProductName, BatchNr and // ProductCode
  res.status(200).json({ message: "" });
});

// Requires e-VIS
app.post("/add-new-entry-type", (req, res) => {
  const data = req.body.data;
  // TODO: Adds a new ProductNumber mapped to unique ProductName
  res.status(200).json({ message: "" });
});
