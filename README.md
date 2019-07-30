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
| 010 | TM | 01 | ZZ_ADSO | Z_CUSTOMER | C | **P** | 

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

![Image of Result type Check](https://github.com/reyemsaibot/dqf/blob/master/images/result_type_c.jpg)


You have to set the Option EQ für Equal or NE for not equal. So you can check with this if even data is available for your selection.

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | Option | Sign | High Value |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | ZZ_TM_ADSO1 | C | A | 
| 010 | TM | 01 | ZZ_KEYFIGURE | 0AMOUNT | C |
| 010 | TM | 01 | ZZ_RESULT_W1D | 0 | C | **NE** |
| 010 | TM | 01 | ZZ_RESULT_W1Q | 0 | C | **NE** |
| 010 | TM | 01 | ZZ_RESULT_W1P | 0 | C | **NE** |
| 010 | TM | 01 | 0CALMONTH | 201906 | C | EQ | I | 

As option for your selection you can choose between the normal SAP options:
- BT
- NB
- GT
- GE
- LT
- LE

As sign you can choose between Include (I) and Exclude (E). 

Besides the check option you can also choose to compare a source with a target. For this use as type S or T.

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | Option | Sign | High Value |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 02 | 0LGENT | 1234 | **S** | EQ | I |
| 010 | TM | 02 | ZZ_ADSO | ZZ_ADSO1 | **S** | A |
| 010 | TM | 02 | ZZ_KEYFIGURE | 0AMOUNT | **S** |
| 010 | TM | 02 | ZZ_FACTOR | /-100 | **S** |
| 010 | TM | 02 | ZLGENT | 4711 | **T** | EQ | I |
| 010 | TM | 02 | ZZ_ADSO | ZZ_ADSO2 | **T** | A |
| 010 | TM | 02 | ZZ_KEYFIGURE | 0AMOUNT | **T** |

In this case the active table of the ADSO ZZ_ADSO1 with the legal entity 1234 will be checked against the active table of the ADSO ZZ_ADSO2 with the legal entity 4711. The source has another factor of the data, we use the parameter **ZZ_FACTOR** to adjust the data. At the moment the following operators are supported:
- "/"
- "-"

You can also use hierarchies to filter your data. Here is how the entry must look like:

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | Option | Sign | High Value |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 02 | 0LGENT | ZH_0LGENT_WLRD | C | HI | I | EUROPE |

In the low value you add the technical name of the hierarchy. As option you have to use **HI** and as high value the node you want to use. In my case we use the hierarchy **ZH_0LGENT_WRLD** with the node and children of **EUROPE**.


