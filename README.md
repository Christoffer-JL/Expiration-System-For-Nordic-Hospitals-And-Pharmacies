# Hållbarhetssystem för bassortiment inom sjukhus och apotek
Välkommen till följande projekt för att hjälpa hålla reda på utgångsdatumen för sjukhus/apoteks bassortiment. Detta system var utvecklat åt Region Skåne Ystads försörjningsfarmaceuter, men projektet lades så småningom ned. Beslutet togs då istället att ladda upp systemet som öppen källkod i hopp om att det kan komma till någons nytta. Projektet är en produkt av mig själv och fyra andra individers enormt imponerande insats av tid, arbete, engagemang och kärlek. En demostration för systemets funktionalitet är gjord av mig själv och finns att hitta på följande länk: https://www.youtube.com/watch?v=jv9Z7DiGN-4.

## Översikt av projektet
Hållbarhetssystemet är en full-stack mobilapplikation (kan anpassas för webbläsare och dator) som tillåter hantering av medicin i bassortiment för olika avdelningar. Användare tillåts skanna medicin med hjälp av QR-kod, EAN-kod och manuell registrering för olika avdelningar. Åtkomst till olika avdelningar kan göras genom skanning av antingen en specifik avdelningskod eller manuell inmatning. Verifikation för giltiga läkemedel görs mot e-Hälsomyndighetens VARA system. Borttagning av läkemedel görs genom en integrerad katalogfunktion. Inom katalogen tillåts användaren filtrera läkemedel beroende på avdelning, batchnummer, produkt och utgångsdatum. Borttagningen görs även per avdelning. En utgångsskärm finns även som generar utgående läkedel för en månad frammåt och bakåt där användaren även kan välja att ta bort läkemdlet från systemet.

Systemets frontend är skriven i Flutter och backend är i Node.js med Express som ramverk. VARA:s integrering är gjord med hjälp utav ett hemmagjort Python script. Databasen är skriven med MySQL.


## Komma igång
För att komma igång:
* Klona repot genom `git clone https://github.com/Christoffer-JL/Region-Sk-ne-2.git`
* Följ installationsinstruktioner under **/lib/**
* Följ intruktion för att sätta upp databasen under **/lib/backend/**
* Följ instruktioner för att initiallisera VARA under **/VARA/**


## Extra resurser
Dokumentation kan finnas under **/documentation/**. Här finns info om databas, definitionslista, kända problem och framtida förbättringar. För frågor om projektet går det bra att kontakta mig direkt.

## Licens
Mjukvaran i detta repository använder sig av Apache 2.0 licens.

## Tack
Vi är mycket nöjda med projektet och stolta med vår insats. Jag vill passa på att tacka de fyra individer som jag fått chansen att jobba tillsammans med och lära känna. Kenny, Hugo, Junchao och Argtim - ni är grymma! Tack även till Region Skåne, Ystad Lassarett och de hjälpsamma, passionerade och trevliga människor som vi arbetat med.
