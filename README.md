# Data Quality Framework

The Data Quality Framework (DQF) is a testtool written in ABAP to test specified testcases in SAP Business Warehouse. You can test automatically predefined testcases which are stored in a customer table. You have the posibility to check a predefined result on specific conditions or compare a source and a target. For example the sales volumne of a product in one month for one country.

So you can easily check if your development is still valid or maybe something went wrong. As source you can either use a PSA Table, an ADSO or a query. As a target you can use an ADSO or a query. 

## Table of content

- [ ADSO Tables ](#adso-tables)
- [ Check Values ](#check-values)
- [ Equal/Not Equal Zero ](#not-equal-zero)
- [ Options ](#options)
- [ Source/Target ](#sourcetarget)
- [ Adjust result value with factor ](#adjust-result-value-with-factor)
- [ Hierarchy ](#hierarchy)
- [ Attribute ](#attribute)
- [ Query ](#query)
- [ Comments ](#comments)
- [ Rowcount ](#rowcount)
- [ Variables ](#variables)

How it works:
Run the program Z_DQF. Choose your work package or your testcase number and click execute. Before you can run the program you have to add your cases into the customer table ZTM_DQF_CASES.

The following information have to be provided so that the program can work correctly. If you want to check an ADSO or PSA you need this:
- ZZ_ADSO
- ZZ_KEYFIGURE
- ZZ_RESULT_(D)
- ZZ_RESULT_(Q)
- ZZ_RESULT_(P)

For the variable (D), (Q) and (P) you have to set the system id of your system landscape. For example W1D as development system. When you check the active table of an ADSO it have to look like this:

### ADSO Tables

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | ZZ_TM_ADSO1 | C | | **A** | 

If you want to check an inbound table of an ADSO you have to configure it like this:

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | ZZ_TM_ADSO1 | C | | **I** | 

You can also check a PSA table with the following parameter:

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | Z_CUSTOMER | C | | **P** | 

You can also check a HANA table with the following parameter (the table must published before in SAP NetWeaver):

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | Z_HANAVIEW | C | | **H** | 

You can also check a ODSO table with the following parameter:

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | Z_ODSO | C | | **O** | 


### Check values

As mentioned before you can either check for predefined values or compare a source with a target. For this you have to use the **type** field. This is how it should look like when you only check a predefined result:

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | ZZ_TM_ADSO1 | **C** | | A | 
| 010 | TM | 01 | ZZ_KEYFIGURE | 0AMOUNT | **C** |
| 010 | TM | 01 | ZZ_RESULT_W1D | 116 | **C** |  | EQ |
| 010 | TM | 01 | ZZ_RESULT_W1Q | 116 | **C** |  | EQ |
| 010 | TM | 01 | ZZ_RESULT_W1P | 1000 | **C** |  | EQ |
| 010 | TM | 01 | 0CALMONTH | 201906 | **C** |  | EQ | I | 

In this case you check on the development system (W1D) the result of the keyfigure 0AMOUNT for 06.2019 in the ADSO ZZ_TM_ADSO1. The result should be 116. 

![Image of Result type Check](https://github.com/reyemsaibot/dqf/blob/master/images/result_type_c.jpg)

### Equal/Not Equal Zero

You have to set the Option EQ für Equal or NE for not equal. So you can check with this if even data is available for your selection.

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 01 | ZZ_ADSO | ZZ_TM_ADSO1 | C | | A | 
| 010 | TM | 01 | ZZ_KEYFIGURE | 0AMOUNT | C |
| 010 | TM | 01 | ZZ_RESULT_W1D | 0 | C | | **NE** |
| 010 | TM | 01 | ZZ_RESULT_W1Q | 0 | C | | **NE** |
| 010 | TM | 01 | ZZ_RESULT_W1P | 0 | C | | **NE** |
| 010 | TM | 01 | 0CALMONTH | 201906 | C | | EQ | I | 

![Image of Result type Check Not equal 0](https://github.com/reyemsaibot/dqf/blob/master/images/result_type_c_ne_zero.jpg)

### Options

As option for your selection you can choose between the normal SAP options:
- BT
- NB
- GT
- GE
- LT
- LE

As sign you can choose between Include (I) and Exclude (E). 

Here is an example for a time range.

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | 
| 010 | TM | 01 | 0CALMONTH | 201901 | C | 201909 | BT | I |

### Source/Target

Besides the check option you can also choose to compare a source with a target. For this use as type S or T.

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | 
| 010 | TM | 02 | 0LGENT | 1234 | **S** | | EQ | I |
| 010 | TM | 02 | ZZ_ADSO | ZZ_ADSO1 | **S** | | A |
| 010 | TM | 02 | ZZ_KEYFIGURE | 0AMOUNT | **S** |
| 010 | TM | 02 | ZZ_FACTOR | /-100 | **S** |
| 010 | TM | 02 | ZLGENT | 4711 | **T** | | EQ | I |
| 010 | TM | 02 | ZZ_ADSO | ZZ_ADSO2 | **T** | | A |
| 010 | TM | 02 | ZZ_KEYFIGURE | 0AMOUNT | **T** |

![Image of Result type Source & Target](https://github.com/reyemsaibot/dqf/blob/master/images/result_type_source_target.jpg)

You can also check 2 source test cases versus 1 target case in case of mapping for example.

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | 
| 010 | TM | 02 | 0LGENT | 1234 | **S1** | | EQ | I |
| 010 | TM | 02 | ZZ_ADSO | ZZ_ADSO1 | **S1** | | A |
| 010 | TM | 02 | ZZ_KEYFIGURE | 0AMOUNT | **S1** |
| 010 | TM | 02 | 0LGENT | 0815 | **S2** | | EQ | I |
| 010 | TM | 02 | ZZ_ADSO | ZZ_ADSO1 | **S2** | | A |
| 010 | TM | 02 | ZZ_KEYFIGURE | 0AMOUNT | **S2** |
| 010 | TM | 02 | ZLGENT | 4711 | **T** | | EQ | I |
| 010 | TM | 02 | ZZ_ADSO | ZZ_ADSO2 | **T** | | A |
| 010 | TM | 02 | ZZ_KEYFIGURE | 0AMOUNT | **T** |

### Adjust result value with factor

In this case the active table of the ADSO ZZ_ADSO1 with the legal entity 1234 will be checked against the active table of the ADSO ZZ_ADSO2 with the legal entity 4711. The source has another factor of the data, we use the parameter **ZZ_FACTOR** to adjust the data. At the moment the following operators are supported:
- "/"
- "-"

### Hierarchy

You can also use hierarchies to filter your data. Here is how the entry must look like:

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 03 | 0LGENT | ZH_0LGENT_WLRD | C | EUROPE | HI | I | 

In the low value you add the technical name of the hierarchy. As option you have to use **HI** and as high value the node you want to use. In my case we use the hierarchy **ZH_0LGENT_WRLD** with the node and children of **EUROPE**.

You can also add multiple hierarchiy nodes for a InfoObject and also at the same time single values for the same InfoObject. 

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 03 | 0LGENT | ZH_0LGENT_WLRD | C | EUROPE | HI | I | 
| 010 | TM | 03 | 0LGENT | USA | C | | EQ | I | 
| 010 | TM | 03 | 0LGENT | CHINA | C | | EQ | I | 

Or you can also exclude a value from the hierarchy node you selected.

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 03 | 0LGENT | ZH_0LGENT_WLRD | C | EUROPE | HI | I | 
| 010 | TM | 03 | 0LGENT | FRANCE | C | | NE | I | 

### Attribute

You can also filter navigation and display attributes.

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | Hight Value | Option | Sign  | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 03 | 0LGENT_ZREGION | USA | C | | EQ | I | 

There will be all legal entiies, which have an entry in the master data table (p-table) and an entry with USA as region (ZREGION) determine.

### Query

Besides the checking of data directly in ADSOs, you can also analyze data in queries. For this you need the following information:
- ZZ_HCPR
- ZZ_KEYFIGURE
- ZZ_QUERY
- ZZ_RESULT_(D)
- ZZ_RESULT_(Q)
- ZZ_RESULT_(P)

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 04 | 0LGENT_ZREGION | USA | C | | EQ | I | 
| 010 | TM | 04 | ZZ_HCPR | Z_HCPR | C |
| 010 | TM | 04 | ZZ_KEYFIGURE | VALUE | C |
| 010 | TM | 04 | ZZ_QUERY | Z_QUERY_DQF | C |
| 010 | TM | 04 | ZZ_RESULT_W1D | 0 | C | | EQ |

You can also use the mentioned options above with a query.

### Comments
If you want to add a comment to your testcase, just write your comment either in the comment field of **ZZ_ADSO** or **ZZ_HCPR**. This comment will be displayed in the result. The Comment is limited to 256 characters.

### Rowcount 
If you want to count the rows of your ADSO and want to compare this number against a value, you can add COUNT(\*) to the high value of a keyfigure.

| MANDT | Workpackage | Number | InfoObject | Low Value | Type | High Value | Option | Sign | Comment
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 010 | TM | 05 | ZZ_KEYFIGURE | VALUE | C | COUNT(\*) |

With this statement you make a rowcount of the entries of your ADSO.

### Variables
You can use the following variables to determine flexible values for time infoobjects.
| Variable | Info |
|--- | --- |
| $CALMONTH$ | Delivers the current year/month |
| $CALMONTH2$ | Delivers the current month |
| $CALYEAR$ | Delivers the current year |
| $FISCPER$ | Delivers the current fiscal year/period |
| $FISCPER3$ | Delivers the current fiscal period |
| $FISCYEAR$ | Delivers the current fiscal year |

You can also work with offset. For example $CALMONTH$-1 delivers you the previous month of the year.

## Example 

1. Define a workpackage e.g. TM
2. Use the next free testcase number e.g. 1
3. Define your ZZ_ADSO or ZZ_HCPR e.g. ZZ_ADSO1
4. Add a comment to the row ZZ_ADSO or ZZ_HCPR
5. Define your ZZ_KEYFIGURE e.g. 0AMOUNT
6. Define your ZZ_RESULT_(D) e.g. ZZ_RESULT_W1D
7. Define your InfoObject with Low Value, High Value, Type, Option and Sign e.g. 0CALMONTH 201901 201909 C BT I
8. Define a factor if necessary e.g. ZZ_FACTOR /100