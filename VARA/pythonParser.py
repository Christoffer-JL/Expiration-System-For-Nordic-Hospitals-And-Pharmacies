import xml.etree.ElementTree as ET

# Define the namespace mapping
namespaces = {
    'asab': 'urn:schemas-asab:vara-export',
    'def': 'urn:schemas-asab:definitioner',
    'lex': 'urn:schemas-asab:lexikon',
    'lxd': 'urn:schemas-asab:lexikondata',
}

# Parse the XML file
tree = ET.parse('lm-data.xml')
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
