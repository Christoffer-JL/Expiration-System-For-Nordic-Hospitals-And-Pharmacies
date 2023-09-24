// Import required modules
const express = require('express');
const bodyParser = require('body-parser');

// Create an Express application
const app = express();

// Use middleware to parse JSON requests
app.use(bodyParser.json());

// Define a route for handling POST requests
app.post('/your-api-endpoint', (req, res) => {
  const data = req.body.data; // Access the data sent from the client
  // Insert 'data' into your MySQL database here
  // Handle any necessary validation and error handling
  // Respond to the client accordingly
  res.status(200).json({ message: 'Data received and processed.' });
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
    console.log("Entered");
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
  
  