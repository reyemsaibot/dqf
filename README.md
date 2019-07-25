# Data Quality Framework

The Data Quality Framework (DQF) is a testtool written in ABAP to test specified testcases in SAP Business Warehouse. You can test automatically predefined testcases which are stored in a customer table. You have the posibility to check a predefined result on specific conditions or compare a source and a target. For example the sales volumne of a product in one month for one country.

So you can easily check if your development is still valid or maybe something went wrong. As source you can either use a PSA Table, an ADSO or a query. As a target you can use an ADSO or a query. 

How it works:
Run the program Z_DQF. Choose your work package or your testcase number and click execute. Before you can run the program you have to add your cases into the customer table ZTM_DQF_CASES.

The following information have to be provided so that the program can work correctly. If you want to check an ADSO or PSA you need this:
- ZZ_ADSO
- ZZ_KEYFIGURE
- ZZ_RESULT_(D)
- ZZ_RESULT_(Q)
- ZZ_RESULT_(P)

For the variable (D), (Q) and (P) you have to set the system id of your system landscape. When you check the active table of an ADSO it have to look like this:

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | Option | Sign | High Value |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | C | A | 

If you want to 





Als ZZ_ADSO muss der technische Name des ADSO z.B. VB0AUNVT angegeben werden. Als ZZ_KEYFIGURE muss der technische Name der Kennzahl, die man überprüfen möchte angeben, z.B. VF0KBEHW. Als ZZ_RESULT muss das erwartete Ergebnis angegeben werden, z.B. 116. Bei ZZ_RESULT muss als Option entweder EQ für Gleich oder NE für Ungleich mitgegeben werden. Somit kann man mit z.B. ZZ_RESULT NE 0 prüfen ob überhaupt Daten vorhanden sind. Wenn man nun das Beispiel von oben in die Tabelle eintragen würde, sieht dies folgendermaßen aus:
