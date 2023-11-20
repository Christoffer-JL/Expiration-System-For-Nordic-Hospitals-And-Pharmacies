const departmentsDataToInsert = [
  { DepartmentName: "Serviceförråd" },
  { DepartmentName: "Akutavdelning" },
  { DepartmentName: "Akutmottagning" },
  { DepartmentName: "Anestesiavdelning" },
  { DepartmentName: "Barn- och ungdomsavdelning" },
  { DepartmentName: "Hjärtavdelning" },
  { DepartmentName: "Intensivvårds- O Postop Avd" },
  { DepartmentName: "Kirurgiavd planerade Op" },
  { DepartmentName: "Medicinavdelning" },
  { DepartmentName: "Operationsavdelning" },
  { DepartmentName: "Ortopediavdelning 8" },
  { DepartmentName: "Endoskopimottagning" },
  { DepartmentName: "Medicinmottagning" },
  { DepartmentName: "Neurologimottagning" },
];

const productsDataToInsert = [
  {
    ProductCode: "00000000163618",
    Packaging: "Glasflaska, 20 ml",
    NordicNumber: "163618",
    ArticleName: "Resyl®",
  },
  {
    ProductCode: "00000000328203",
    Packaging: "Flaska, 50 milliliter",
    NordicNumber: "328203",
    ArticleName: "Metadon APL engångsdos",
  },
  {
    ProductCode: "00000000328211",
    Packaging: "Flaska, 50 milliliter",
    NordicNumber: "328211",
    ArticleName: "Metadon APL engångsdos",
  },
  {
    ProductCode: "00000021303104",
    Packaging: "Glasflaska, 25 ml",
    NordicNumber: "130310",
    ArticleName: "AD-vitamin Olja",
  },
  {
    ProductCode: "00073000901333",
    Packaging: "Blister, 60 kapslar",
    NordicNumber: "454110",
    ArticleName: "Prosabal",
  },
  {
    ProductCode: "00191778018264",
    Packaging: "Blister, 7 tabletter",
    NordicNumber: "11260",
    ArticleName: "Arcoxia®",
  },
  {
    ProductCode: "00704626016050",
    Packaging: "Singel tvåkammarpåse, 3 x 3000 ml, Skruvkoppling",
    NordicNumber: "16050",
    ArticleName: "Physioneal 40 Glucose Clear-Flex",
  },
  {
    ProductCode: "00643169060098",
    Packaging: "Beredningssats för implantat, 1 x (12 mg + 8 ml + matris)",
    NordicNumber: "181720",
    ArticleName: "InductOs®",
  },
  {
    ProductCode: "08901296019405",
    Packaging: "Blister, 90 tabletter",
    NordicNumber: "166709",
    ArticleName: "Alfuzosin Ranbaxy",
  },
];

const entriesDataToInsert = [
  {
    ProductCode: "00000000163618",
    BatchNumber: "05683415548207",
    ExpirationDate: "2025-03-31",
  },
  {
    ProductCode: "00000000328203",
    BatchNumber: "2123951",
    ExpirationDate: "2023-12-15",
  },
  {
    ProductCode: "00000000328203",
    BatchNumber: "21239315",
    ExpirationDate: "2023-12-10",
  },
  {
    ProductCode: "00000000328211",
    BatchNumber: "2107982",
    ExpirationDate: "2024-01-03",
  },
  {
    ProductCode: "00000021303104",
    BatchNumber: "21418",
    ExpirationDate: "2023-10-05",
  },
  {
    ProductCode: "00704626016050",
    BatchNumber: "JGVRGG23T9",
    ExpirationDate: "2023-12-07",
  },
  {
    ProductCode: "00643169060098",
    BatchNumber: "1120659410C94126",
    ExpirationDate: "2023-12-30",
  },
  {
    ProductCode: "08901296019405",
    BatchNumber: "2123951",
    ExpirationDate: "2023-01-30",
  },
];

const departmentEntryLinksDataToInsert = [
  {
    ProductCode: "00000000163618",
    ExpirationDate: "2025-03-31",
    DepartmentName: "Serviceförråd",
  },
  {
    ProductCode: "00000000328203",
    ExpirationDate: "2023-12-15",
    DepartmentName: "Akutavdelning",
  },
  {
    ProductCode: "00000000328203",
    ExpirationDate: "2023-12-10",
    DepartmentName: "Akutmottagning",
  },
  {
    ProductCode: "00000000328211",
    ExpirationDate: "2024-01-03",
    DepartmentName: "Anestesiavdelning",
  },
  {
    ProductCode: "00000021303104",
    ExpirationDate: "2023-10-05",
    DepartmentName: "Barn- och ungdomsavdelning",
  },
  {
    ProductCode: "00704626016050",
    ExpirationDate: "2023-12-07",
    DepartmentName: "Hjärtavdelning",
  },
  {
    ProductCode: "00643169060098",
    ExpirationDate: "2023-12-30",
    DepartmentName: "Intensivvårds- O Postop Avd",
  },
  {
    ProductCode: "08901296019405",
    ExpirationDate: "2023-01-30",
    DepartmentName: "Kirurgiavd planerade Op",
  },
  {
    ProductCode: "00073000901333",
    ExpirationDate: "2023-11-15",
    DepartmentName: "Medicinavdelning",
  },
  {
    ProductCode: "00191778018264",
    ExpirationDate: "2023-11-20",
    DepartmentName: "Operationsavdelning",
  },
  {
    ProductCode: "00704626016050",
    ExpirationDate: "2023-11-25",
    DepartmentName: "Ortopediavdelning 8",
  },
  {
    ProductCode: "00643169060098",
    ExpirationDate: "2023-11-30",
    DepartmentName: "Endoskopimottagning",
  },
  {
    ProductCode: "08901296019405",
    ExpirationDate: "2023-12-05",
    DepartmentName: "Medicinmottagning",
  },
  {
    ProductCode: "00000000328203",
    ExpirationDate: "2023-12-10",
    DepartmentName: "Neurologimottagning",
  },
];

const mysql = require("mysql2");

const dbConfig = {
  host: "104.248.81.249",
  user: "mandag",
  password: "regionskane",
  database: "region_skane",
  port: 3306,
};

const connection = mysql.createConnection(dbConfig);

connection.connect((err) => {
  if (err) {
    console.error("Error connecting to the database:", err);
    return;
  }

  console.log("Connected to the database");

  departmentsDataToInsert.forEach((department) => {
    connection.query(
      "INSERT IGNORE INTO Departments SET ?",
      department,
      (insertErr, results) => {
        if (insertErr) {
          console.error("Error inserting department data:", insertErr);
        } else {
          console.log("Department data inserted:", results);
        }
      }
    );
  });

  productsDataToInsert.forEach((product) => {
    connection.query(
      "INSERT IGNORE INTO Products SET ?",
      product,
      (insertErr, results) => {
        if (insertErr) {
          console.error("Error inserting product data:", insertErr);
        } else {
          console.log("Product data inserted:", results);
        }
      }
    );
  });

  entriesDataToInsert.forEach((entry) => {
    connection.query(
      "INSERT IGNORE INTO Entries SET ?",
      entry,
      (insertErr, results) => {
        if (insertErr) {
          console.error("Error inserting entry data:", insertErr);
        } else {
          console.log("Entry data inserted:", results);
        }
      }
    );
  });

  departmentEntryLinksDataToInsert.forEach((link) => {
    connection.query(
      "INSERT IGNORE INTO DepartmentEntryLinks SET ?",
      link,
      (insertErr, results) => {
        if (insertErr) {
          console.error(
            "Error inserting department entry link data:",
            insertErr
          );
        } else {
          console.log("Department entry link data inserted:", results);
        }
      }
    );
  });

  connection.end((endErr) => {
    if (endErr) {
      console.error("Error closing the connection:", endErr);
    } else {
      console.log("Connection closed");
    }
  });
});
