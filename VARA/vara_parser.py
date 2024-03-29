import xml.etree.ElementTree as ET
import paramiko
import zipfile
import os
import shutil
import mysql.connector

namespaces = {
    'asab': 'urn:schemas-asab:vara-export',
    'def': 'urn:schemas-asab:definitioner',
    'lex': 'urn:schemas-asab:lexikon',
    'lxd': 'urn:schemas-asab:lexikondata',
}

sftp_host = 'sftp.ehalsomyndigheten.se'
sftp_port = 22
sftp_user = ''
sftp_password = ''
sftp_remote_dir = '5'
local_unzip_dir = 'unzip_folder'
prefix_to_match = 'vara'

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

try:
    ssh.connect(sftp_host, port=sftp_port, username=sftp_user, password=sftp_password)
    ssh.get_transport().set_keepalive(120)
    sftp = ssh.open_sftp()

    sftp.chdir(sftp_remote_dir)

    files = sftp.listdir()
    matching_files = [file for file in files if file.startswith(prefix_to_match)]

    if not matching_files:
        print("No matching files found.")
    else:
        for remote_zip_file in matching_files:
            sftp.get(remote_zip_file, remote_zip_file)

            with zipfile.ZipFile(remote_zip_file, 'r') as zip_ref:
                zip_ref.extractall(local_unzip_dir)

            xml_file_path = os.path.join(local_unzip_dir, 'vara-export', 'lm-data.xml')
            print(xml_file_path)
            tree = ET.parse(xml_file_path)
            root = tree.getroot()

            db_config = {
                "host": "",
                "user": "",
                "password": "",
                "database": "",
                "port": 3306,
            }

            batch_size = 100

            try:
                cnx = mysql.connector.connect(**db_config)
                cursor = cnx.cursor()

                values_to_insert = []
                for lmprodukt in root.findall('.//def:lmprodukt', namespaces=namespaces):
                    produktnamn = lmprodukt.find('./def:produktnamn', namespaces=namespaces)
                    for lmartikel in lmprodukt.findall('.//def:artiklar/def:lmartikel', namespaces=namespaces):
                        varunummer = lmartikel.find('.//def:varunummer', namespaces=namespaces)
                        forpackning_text = lmartikel.find('.//def:forpackning_text', namespaces=namespaces)
                        streckkod = lmartikel.find('.//def:streckkod', namespaces=namespaces)

                        if varunummer.text is not None and forpackning_text.text is not None and streckkod.text is not None:
                            data = (streckkod.text, forpackning_text.text, varunummer.text, produktnamn.text)
                            values_to_insert.append(data)

                            if len(values_to_insert) >= batch_size:
                                insert_query = """
                                    INSERT INTO Products (ProductCode, Packaging, NordicNumber, ArticleName)
                                    VALUES (%s, %s, %s, %s)
                                    ON DUPLICATE KEY UPDATE
                                    Packaging = VALUES(Packaging), NordicNumber = VALUES(NordicNumber), ArticleName = VALUES(ArticleName)
                                """
                                cursor.executemany(insert_query, values_to_insert)
                                cnx.commit()

                                values_to_insert = []

                # Insert any remaining values
                if values_to_insert:
                    cursor.executemany(insert_query, values_to_insert)
                    cnx.commit()

            except mysql.connector.Error as err:
                print(f"An error occurred while inserting data into the database: {err}")

            finally:
                cursor.close()
                cnx.close()

            os.remove(remote_zip_file)
            shutil.rmtree(local_unzip_dir)

except Exception as e:
    print(f"An error occurred: {str(e)}")

finally:
    ssh.close()



