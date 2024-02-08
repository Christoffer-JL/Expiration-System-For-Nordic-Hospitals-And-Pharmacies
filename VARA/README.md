## Instruktioner för VARA-applikation

# Översikt
[VARA](https://www.ehalsomyndigheten.se/yrkesverksam/vara--produkt--och-artikelregister/) är ett nationellt produkt- och artikelregister i norden. I detta system används VARA för att validera giltiga inmatade artiklar, samt för att få fram produktnamn, förpackningstyp och varunummer.

# Användning
1. Se till att instruktionerna för att sätta upp databasen är klara. Dessa finns att hitta under **/lib/backend/**.
2. För att kunna använda VARA-applikationen krävs giltig inloggning till e-Hälsomyndigheten. Vänligen kontakta servicedesk@ehalsomyndigheten.se för att få inloggningsuppgifter.
3. Fyll i inloggningsuppgifterna i vara_parser.py (sftp_user och sftp_password).
4. Fyll i databas inloggningsuppgifter i scriptet (under db_config).
5. Kör skriptet med `python vara_parser.py`
6. Ta en kopp kaffe, det kan ta en liten stund.
