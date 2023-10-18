from flask import Flask
import paramiko
import mysql.connector
import atexit

app = Flask(__name__)

# SSH Configuration
ssh_config = {
    'hostname': '192.168.0.110',
    'port': 22,
    'username': 'christoffer1917',
    'password': 'rspi_temp'
}

# MySQL Database Configuration
db_config = {
    'host': '127.0.0.1',
    'port': 3306,
    'user': 'root',
    'password': 'password',
    'database': 'regionskane',
}

ssh_client = paramiko.SSHClient()
ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

db_connection = mysql.connector.connect(**db_config)
db_cursor = db_connection.cursor()

@app.route('/')
def index():
    return "Server is running on port 3000"

@app.route('/your_route', methods=['POST', 'GET'])
def your_route():
    # Route logic
    pass

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)

@atexit.register
def cleanup():
    ssh_client.close()
