const mysql = require("mysql");

const db = mysql.createConnection({
  host: "sql11.freesqldatabase.com",
  user: "sql11653843",
  password: "ri3ZrApRl4",
  database: "sql11653843",
  port: 3306,
});

db.connect((err) => {
  if (err) {
    console.error("Error connecting to MySQL:", err);
    return;
  } else {
    console.log("Connected to MySQL");
  }
});

db.on("error", (err) => {
  console.error("MySQL connection error:", err.message);
  if (err.code === "PROTOCOL_CONNECTION_LOST") {
    // Attempt to reconnect
    db.connect();
  } else {
    throw err;
  }
});

module.exports = {
  query: (sql, params, callback) => {
    return db.query(sql, params, callback);
  },
};