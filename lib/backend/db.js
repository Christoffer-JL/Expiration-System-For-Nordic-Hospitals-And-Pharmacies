const mysql = require("mysql2");

const db = mysql.createConnection({
  host: "104.248.81.249",
  user: "mandag",
  password: "regionskane",
  database: "region_skane",
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
