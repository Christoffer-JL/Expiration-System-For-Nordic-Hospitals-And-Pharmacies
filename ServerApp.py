from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name)

# MariaDB configuration
db_config = {
    "host": "sql11.freesqldatabase.com",
    "user": "sql11652098",
    "password": "X1j3W3Q5Ir",
    "database": "sql11652098",
    "port": 3306,
}

db = mysql.connector.connect(**db_config)

@app.route("/")
def index():
    return "Server is running"

# Fetches all departments
@app.route("/all-departments")
def all_departments():
    department_id = request.args.get("DepartmentId")
    cursor = db.cursor(dictionary=True)
    query = "SELECT * FROM Departments"
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    return jsonify(results)

# Fetches all product names
@app.route("/all-productnames")
def all_productnames():
    article_name = request.args.get("ArticleName")
    cursor = db.cursor(dictionary=True)
    query = "SELECT ArticleName FROM Products"
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    return jsonify(results)

# Get all entries with optional provided filters
@app.route("/entries")
def entries():
    department_name = request.args.get("DepartmentName")
    batch_nr = request.args.get("BatchNr")
    product_code = request.args.get("ProductCode")
    product_name = request.args.get("ProductName")

    cursor = db.cursor(dictionary=True)
    query = """
        SELECT E.*, P.Packaging, P.NordicNumber, P.ArticleName
        FROM Entries E
        JOIN Products P ON E.ProductCode = P.ProductCode
        """
    conditions = []
    values = []

    if department_name:
        conditions.append("E.DepartmentName = %s")
        values.append(department_name)
    if batch_nr:
        conditions.append("E.BatchNumber = %s")
        values.append(batch_nr)
    if product_code:
        conditions.append("E.ProductCode = %s")
        values.append(product_code)
    if product_name:
        conditions.append("P.ArticleName = %s")
        values.append(product_name)

    if conditions:
        query += " WHERE " + " AND ".join(conditions)

    cursor.execute(query, values)
    results = cursor.fetchall()
    cursor.close()
    return jsonify(results)

# Get all entries with expiration date in the next 3 months
@app.route("/expiration-entries")
def expiration_entries():
    cursor = db.cursor(dictionary=True)
    query = """
        SELECT E.*, P.Packaging, P.NordicNumber, P.ArticleName
        FROM Entries E
        JOIN Products P ON E.ProductCode = P.ProductCode
        WHERE E.ExpirationDate <= DATE_ADD(NOW(), INTERVAL 3 MONTH)
    """
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    return jsonify(results)

# Inserts an entry into a department
@app.route("/insert-entry-in-department", methods=["POST"])
def insert_entry_in_department():
    data = request.json
    department_name = data["DepartmentName"]
    product_code = data["ProductCode"]
    batch_number = data["BatchNumber"]
    expiration_date = data["ExpirationDate"]

    cursor = db.cursor()
    check_query = "SELECT COUNT(*) AS entryCount FROM Entries WHERE DepartmentName = %s AND ProductCode = %s"
    cursor.execute(check_query, (department_name, product_code))
    entry_count = cursor.fetchone()[0]

    if entry_count == 0:
        insert_query = "INSERT INTO Entries (DepartmentName, ProductCode, BatchNumber, ExpirationDate) VALUES (%s, %s, %s, %s)"
        cursor.execute(insert_query, (department_name, product_code, batch_number, expiration_date))
        db.commit()
        return "Entry inserted successfully", 201
    else:
        return "Entry for the specified department and product already exists", 200

if __name__ == "__main__":
    app.run()
