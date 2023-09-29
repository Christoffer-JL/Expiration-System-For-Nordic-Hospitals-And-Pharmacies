// Import required modules
const express = require('express');
const bodyParser = require('body-parser');

// Create an Express application
const app = express();

// Use middleware to parse JSON requests
app.use(bodyParser.json());

// Handle GET requests to /api-endpoint
app.get('/api-endpoint', (req, res) => {
  // Handle GET requests here (e.g., retrieve data)
  res.send('This is a GET request to /api-endpoint');
});

// Handle POST requests to /api-endpoint
app.post('/api-endpoint', (req, res) => {

  const data = req.body.data;
  insertData(data);
  // Insert 'data' into your MySQL database here
  // Respond to the client accordingly
  res.status(200).json({ message: 'Data received and processed.' });
});

app.post('/api-endpoint2', (req, res) => {
  const data = req.body.data;
  // Insert 'data' into table 2 here
  res.status(200).json({ message: 'Data received and processed for table 2.' });
  insertData2(data);
});



// Start the server
const port = process.env.PORT || 3000; // Use the specified port or 3000 as a default
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

const mysql = require('mysql');

const db = mysql.createConnection({
  host: 'sql11.freesqldatabase.com',
  user: 'sql11648708',
  password: 'bYlA6x4JHr',
  database: 'sql11648708',
  port: 3306
});

// Connect to MySQL
db.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
  } else {
    console.log('Connected to MySQL');
  }
});

// Insert data into MySQL
function insertData(data) {
    console.log(data);
    // Split the data into an array of values, assuming it's a comma-separated string
    const values = data.split(',');
  
    const sql = 'INSERT INTO dummy_table (name, age) VALUES (?, ?)';
    db.query(sql, values, (err, result) => {
      if (err) {
        console.error('Error inserting data:', err);
      } else {
        console.log('Data inserted successfully:', result);
      }
    });
  }
  
  function insertData2(data) {
    console.log(data);
    // Split the data into an array of values, assuming it's a comma-separated string
    const values = data.split(',');
  
    const sql = 'INSERT INTO dummy_table2 (name, age) VALUES (?, ?)';
    db.query(sql, values, (err, result) => {
      if (err) {
        console.error('Error inserting data:', err);
      } else {
        console.log('Data inserted successfully:', result);
      }
    });
  }