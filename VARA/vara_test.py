import xml.etree.ElementTree as ET

namespaces = {
    'asab': 'urn:schemas-asab:vara-export',
    'def': 'urn:schemas-asab:definitioner',
    'lex': 'urn:schemas-asab:lexikon',
    'lxd': 'urn:schemas-asab:lexikondata',
}

def count_unique_entries(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()

    unique_entries = set()

    # Assuming the def:streckkod element is the unique identifier
    for lmprodukt in root.findall('.//def:lmartikel', namespaces=namespaces):
        streckkod = lmprodukt.find('.//def:streckkod', namespaces=namespaces)
        if streckkod is not None:
            unique_entries.add(streckkod.text)

    return len(unique_entries)

if __name__ == "__main__":
    xml_file_path = "lm-data.xml"
    unique_entry_count = count_unique_entries(xml_file_path)

    print(f"Number of unique entries: {unique_entry_count}")
