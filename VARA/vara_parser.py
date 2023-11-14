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
sftp_user = 'pe465'
sftp_password = 'ZaGa8K\\Z[M(#'
sftp_remote_dir = '6'

local_unzip_dir = 'unzip_folder'
prefix_to_match = 'vara'

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

try:
    ssh.connect(sftp_host, port=sftp_port, username=sftp_user, password=sftp_password)
    sftp = ssh.open_sftp()

    sftp.chdir(sftp_remote_dir)

    files = sftp.listdir()
    matching_files = [file for file in files if file.startswith(prefix_to_match)]


    if not matching_files:
        print("No matching files found.")
    else:
        remote_zip_file = max(matching_files)
        sftp.get(remote_zip_file, remote_zip_file)

        with zipfile.ZipFile(remote_zip_file, 'r') as zip_ref:
            zip_ref.extractall(local_unzip_dir)

        xml_file_path = os.path.join(local_unzip_dir, 'vara-export', 'lm-data.xml')
        print(xml_file_path)
        tree = ET.parse(xml_file_path)
        root = tree.getroot()

    db_config = {
        "host": "sql11.freesqldatabase.com",
        "user": "sql11653843",
        "password": "ri3ZrApRl4",
        "database": "sql11653843",
        "port": 3306,
    }

    try:
        cnx = mysql.connector.connect(**db_config)
        cursor = cnx.cursor()

        for lmprodukt in root.findall('.//def:lmprodukt', namespaces=namespaces):

            produktnamn = lmprodukt.find('./def:produktnamn', namespaces=namespaces).text
            varunummer_element = lmprodukt.find('.//def:artikel_id[@artikel_id_typ="nordiskt-varunr"]', namespaces=namespaces)
            varunummer = varunummer_element.attrib['id_varde'] if varunummer_element is not None else None
            forpackning_text_element = lmprodukt.find('.//def:forpackning_text', namespaces=namespaces)
            forpackning_text = forpackning_text_element.text if forpackning_text_element is not None else None
            streckkod_element = lmprodukt.find('.//def:artikel_id[@artikel_id_typ="streck-kod"]', namespaces=namespaces)
            streckkod = streckkod_element.attrib['id_varde'] if streckkod_element is not None else None

            if varunummer is not None and forpackning_text is not None and streckkod is not None:
                insert_query = """
                INSERT INTO Products (ProductCode, Packaging, NordicNumber, ArticleName)
                VALUES (%s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE
                Packaging = VALUES(Packaging), NordicNumber = VALUES(NordicNumber), ArticleName = VALUES(ArticleName)
                """
                data = (streckkod, forpackning_text, varunummer, produktnamn)
                cursor.execute(insert_query, data)
                
            cnx.commit()

    except mysql.connector.Error as err:
        print(f"An error occurred while inserting data into the database: {err}")

    finally:
        cursor.close()
        cnx.close()

    sftp.close()
    os.remove(remote_zip_file)
    shutil.rmtree(local_unzip_dir)

except Exception as e:
    print(f"An error occurred: {str(e)}")

finally:
    ssh.close()
