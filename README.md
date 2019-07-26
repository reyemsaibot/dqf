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
| 010 | TM | 01 | ZZ_ADSO | ZZ_TM_ADSO1 | C | **A** | 

If you want to check an inbound table of an ADSO you have to configure it like this:

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | Option | Sign | High Value |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | ZZ_TM_ADSO1 | C | **I** | 

You can also check a PSA table with the following parameter:

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | Option | Sign | High Value |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | ZZ_TM_ADSO1 | C | **P** | 

As mentioned before you can either check for predefined values or compare a source with a target. For this you have to use the **type** field. This is how it should look like when you only check a predefined result:

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | Option | Sign | High Value |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | ZZ_TM_ADSO1 | **C** | A | 
| 010 | TM | 01 | ZZ_KEYFIGURE | 0AMOUNT | **C** |
| 010 | TM | 01 | ZZ_RESULT_W1D | 116 | **C** | EQ |
| 010 | TM | 01 | ZZ_RESULT_W1Q | 116 | **C** | EQ |
| 010 | TM | 01 | ZZ_RESULT_W1P | 1000 | **C** | EQ |
| 010 | TM | 01 | 0CALMONTH | 201906 | **C** | EQ | I | 

In this case you check on the development system (W1D) the result of the keyfigure 0AMOUNT for 06.2019 in the ADSO ZZ_TM_ADSO1. The result should be 116.





Bei ZZ_RESULT muss als Option entweder EQ für Gleich oder NE für Ungleich mitgegeben werden. Somit kann man mit z.B. ZZ_RESULT NE 0 prüfen ob überhaupt Daten vorhanden sind. Wenn man nun das Beispiel von oben in die Tabelle eintragen würde, sieht dies folgendermaßen aus:
