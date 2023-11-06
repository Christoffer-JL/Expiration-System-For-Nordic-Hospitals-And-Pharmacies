import xml.etree.ElementTree as ET
import paramiko
import zipfile
import os
import shutil

# Define the namespace mapping
namespaces = {
    'asab': 'urn:schemas-asab:vara-export',
    'def': 'urn:schemas-asab:definitioner',
    'lex': 'urn:schemas-asab:lexikon',
    'lxd': 'urn:schemas-asab:lexikondata',
}

# SFTP Configuration
sftp_host = 'sftp.ehalsomyndigheten.se'
sftp_port = 22
sftp_user = 'pe465'
sftp_password = 'ZaGa8K\\Z[M(#'  # Note the double backslash to escape the special characters
sftp_remote_dir = '6'
remote_zip_file = 'vara-export-6_20231106_003156.zip'

# Local directory to unpack the ZIP file
local_unzip_dir = 'unzip_folder'

# Create a Paramiko SSH client and SFTP client
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

try:
    ssh.connect(sftp_host, port=sftp_port, username=sftp_user, password=sftp_password)
    sftp = ssh.open_sftp()

    # Change to the remote directory and get the ZIP file
    sftp.chdir(sftp_remote_dir)
    sftp.get(remote_zip_file, remote_zip_file)

    # Unzip the downloaded ZIP file
    with zipfile.ZipFile(remote_zip_file, 'r') as zip_ref:
        zip_ref.extractall(local_unzip_dir)

    # Parse the XML file from the unzipped folder
    xml_file_path = os.path.join(local_unzip_dir, 'vara-export', 'lm-data.xml')
    print(xml_file_path)
    tree = ET.parse(xml_file_path)
    root = tree.getroot()

    # Iterate through each 'def:lmprodukt' element
    for lmprodukt in root.findall('.//def:lmprodukt', namespaces=namespaces):
        produktnamn = lmprodukt.find('./def:produktnamn', namespaces=namespaces).text
        varunummer_element = lmprodukt.find('.//def:artikel_id[@artikel_id_typ="nordiskt-varunr"]', namespaces=namespaces)
        varunummer = varunummer_element.attrib['id_varde'] if varunummer_element is not None else None
        forpackning_text_element = lmprodukt.find('.//def:forpackning_text', namespaces=namespaces)
        forpackning_text = forpackning_text_element.text if forpackning_text_element is not None else None
        streckkod_element = lmprodukt.find('.//def:artikel_id[@artikel_id_typ="streck-kod"]', namespaces=namespaces)
        streckkod = streckkod_element.attrib['id_varde'] if streckkod_element is not None else None

        # Check if any of the values is not "N/A" before printing
        if varunummer is not None and forpackning_text is not None and streckkod is not None:
            # Do something with the extracted data, e.g., print it
            print(f"Produktnamn: {produktnamn}")
            print(f"Varunummer: {varunummer}")
            print(f"Förpackning: {forpackning_text}")
            print(f"Produktkod: {streckkod}")

        # Close the SFTP connection
    sftp.close()

        # Clean up: Delete the local unzip folder
    os.remove(remote_zip_file)
    shutil.rmtree(local_unzip_dir)

except Exception as e:
    print(f"An error occurred: {str(e)}")

finally:
    # Close the SSH connection
    ssh.close()
