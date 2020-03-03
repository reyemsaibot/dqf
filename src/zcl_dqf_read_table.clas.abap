class zcl_dqf_read_table definition
  public
  create public

  global friends ZCL_DQF.

public section.

  types:  "! <p class="shorttext synchronized" lang="en">Keyfigure Table</p>
    tyt_keyfigure TYPE STANDARD TABLE OF rsdiobjnm WITH EMPTY KEY .

  types:   "! <p class="shorttext synchronized" lang="en">Structure for parameter</p>
    BEGIN OF ty_parameter,
      query           TYPE rszcompid,
      hcpr            TYPE rsinfoprov,
      keyfigure       TYPE tyt_keyfigure,
      table           TYPE string,
      comment         TYPE string,
      result_expected TYPE string,
      result_opt      TYPE c LENGTH 2,
      factor          TYPE string,
      rowcount        TYPE string,
    END OF ty_parameter .

  "! <p class="shorttext synchronized" lang="en">Constructor</p>
  "!
  methods CONSTRUCTOR .
protected section.
private section.

  Types: "! <p class="shorttext synchronized" lang="en">Table of Testcases</p>
    tyt_ztm_dqf_cases  type STANDARD TABLE OF ztm_dqf_cases with empty key.

  data: "! <p class="shorttext synchronized" lang="en">Parameters</p>
    gt_parameters type tyt_ztm_dqf_cases .

  data: "! <p class="shorttext synchronized" lang="en">Testcase</p>
    gv_case type int2.

  data: "! <p class="shorttext synchronized" lang="en">Workpackage</p>
    gv_workpackage type ztm_dqf_cases-wp.

  data: "! <p class="shorttext synchronized" lang="en">Testcase Type</p>
    gv_type type char2.

  class-data: "! <p class="shorttext synchronized" lang="en">Factor for calculation</p>
    gc_factor type string value 'ZZ_FACTOR'.
  class-data: "! <p class="shorttext synchronized" lang="en">Keyfigure to check</p>
    gc_keyfigure type string value 'ZZ_KEYFIGURE'.
  class-data: "! <p class="shorttext synchronized" lang="en">Expected result</p>
    gc_result type string value 'ZZ_RESULT_'.
  class-data: "! <p class="shorttext synchronized" lang="en">Table to check</p>
    gc_table type string value 'ZZ_ADSO'.
  class-data: "! <p class="shorttext synchronized" lang="en">Composite Provider to check</p>
    gc_hcpr type string value 'ZZ_HCPR'.
  class-data: "! <p class="shorttext synchronized" lang="en">Query to check</p>
    gc_query type string value 'ZZ_QUERY'.

  "! <p class="shorttext synchronized" lang="en">Get Parameter for testcase</p>
  "!
  "! @parameter rs_parameter | <p class="shorttext synchronized" lang="en">Return paraemter structure</p>
  METHODS get_parameter
    RETURNING
      VALUE(rs_parameter) type ty_parameter.

  "! <p class="shorttext synchronized" lang="en">Set Testcase</p>
  "!
  "! @parameter i_case | <p class="shorttext synchronized" lang="en">Testcase</p>
  METHODS set_case
    Importing
      i_case type int2.

  "! <p class="shorttext synchronized" lang="en">Set Workpackage</p>
  "!
  "! @parameter i_workpackage | <p class="shorttext synchronized" lang="en">Workpackage</p>
  METHODS set_workpackage
    Importing
      i_workpackage type ztm_dqf_cases-wp.

  "! <p class="shorttext synchronized" lang="en">Get all information for a testcase from the database</p>
  "!
  "! @parameter rt_value | <p class="shorttext synchronized" lang="en">Return all information for a testcase</p>
  METHODS get_data
    RETURNING
      VALUE(rt_value) type tyt_ztm_dqf_cases.

  "! <p class="shorttext synchronized" lang="en">Read factor for calculation</p>
  "!
  "! @parameter r_value | <p class="shorttext synchronized" lang="en">Return factor</p>
  METHODS read_factor
    Returning
      Value(r_value) type string.

  "! <p class="shorttext synchronized" lang="en">Read keyfigure for selection</p>
  "!
  "! @parameter rt_value | <p class="shorttext synchronized" lang="en">Return keyfigures</p>
  METHODS read_keyfigure
    Returning
      Value(rt_value) type tyt_keyfigure.

  "! <p class="shorttext synchronized" lang="en">Read if only rowcount</p>
  "!
  "! @parameter r_value | <p class="shorttext synchronized" lang="en">Return information that only rowcount</p>
  METHODS read_rowcount
    RETURNING
      VALUE(r_value) type string.

  "! <p class="shorttext synchronized" lang="en">Read expected result for testcase</p>
  "!
  "! @parameter r_value | <p class="shorttext synchronized" lang="en">Return expected result</p>
  METHODS read_expected_result
    RETURNING
      VALUE(r_value) type string.


  "! <p class="shorttext synchronized" lang="en">Read expected result option</p>
  "!
  "! @parameter r_value | <p class="shorttext synchronized" lang="en">Return sign e.g. EQ, NE, LT...</p>
  METHODS read_result_option
    RETURNING
      VALUE(r_value) type char2.

  "! <p class="shorttext synchronized" lang="en">Read table for data selection</p>
  "!
  "! @parameter r_value | <p class="shorttext synchronized" lang="en">Return table</p>
  METHODS read_table
    RETURNING
      VALUE(r_value) type string.

  "! <p class="shorttext synchronized" lang="en">Get PSA table</p>
  "!
  "! @parameter i_table  | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter r_result | <p class="shorttext synchronized" lang="en">Return technical PSA Table</p>
  METHODS get_psa_table
    IMPORTING
      !i_table TYPE string
    RETURNING
      VALUE(r_result) TYPE rsodstech .

    "! <p class="shorttext synchronized" lang="en">Read comment for testcase</p>
    "!
    "! @parameter r_value | <p class="shorttext synchronized" lang="en">Return comment</p>
    METHODS read_comment
      RETURNING
        VALUE(r_value) TYPE string.

    "! <p class="shorttext synchronized" lang="en">Set testcase type</p>
    "!
    "! @parameter i_type | <p class="shorttext synchronized" lang="en">Testcase type</p>
    METHODS set_type
      IMPORTING
        i_type TYPE char2.

    "! <p class="shorttext synchronized" lang="en">Read Composite Provider</p>
    "!
    "! @parameter r_value | <p class="shorttext synchronized" lang="en">Return Composite Provider</p>
    METHODS read_hcpr
      RETURNING
        value(r_value) TYPE rsinfoprov.

    "! <p class="shorttext synchronized" lang="en">Read Query</p>
    "!
    "! @parameter r_value | <p class="shorttext synchronized" lang="en">Return technical query name</p>
    METHODS read_query
      RETURNING
        value(r_value) TYPE rszcompid.

ENDCLASS.

CLASS zcl_dqf_read_table IMPLEMENTATION.

method CONSTRUCTOR.
endmethod.


method get_parameter.
me->gt_parameters = get_data( ).

rs_parameter-factor = read_factor( ).
rs_parameter-keyfigure = read_keyfigure( ).
rs_parameter-rowcount = read_rowcount( ).
rs_parameter-result_expected = read_expected_result( ).
rs_parameter-result_opt = read_result_option( ).

rs_parameter-comment = read_comment( ).
rs_parameter-hcpr = read_hcpr( ).
rs_parameter-query = read_query( ).
rs_parameter-table = read_table( ).

endmethod.

method read_comment.
Try.
  r_value = gt_parameters[ iobjnm = gc_table ]-comments.
Catch cx_sy_itab_line_not_found.

Endtry.
ENDMETHOD.

method read_table.
Try.
  data(lv_option) = gt_parameters[ iobjnm = gc_table ]-opt.
  data(lv_table)  = gt_parameters[ iobjnm = gc_table ]-low.
  Case lv_option.
    When 'A'. "Active Table
      r_value = |/BIC/A{ lv_table }2|.
    When 'I'. "Inbound Table
      r_value = |/BIC/A{ lv_table }1|.
    When 'P'. "PSA
      r_value = get_psa_table( CONV string( lv_table ) ).
    When 'O'. "ODSO
      r_value = |/BIC/A{ lv_table }00|.
    When 'H'. "HANA View
      r_value = lv_table.
  ENDCASE.
Catch cx_sy_itab_line_not_found.

Endtry.
ENDMETHOD.

METHOD get_psa_table.
TYPES: ty_psa TYPE STANDARD TABLE OF rsodstech WITH EMPTY KEY.

SELECT odsname_tech,
       userobj
  FROM rstsods
  INTO TABLE @DATA(lt_rstsods). "#EC CI_SEL_NESTED "#EC CI_GENBUFF

IF sy-subrc = 0.
 DATA(psa) = VALUE ty_psa( FOR <ls_rstsods> IN lt_rstsods  WHERE ( userobj CS i_table ) ( <ls_rstsods>-odsname_tech ) ).
 r_result = psa[ 1 ].
ENDIF.
ENDMETHOD.

method read_expected_result.
Try.
 r_value = gt_parameters[ iobjnm = |{ gc_result }{ sy-sysid }| ]-low.
Catch cx_sy_itab_line_not_found.

Endtry.
endmethod.

method read_result_option.
Try.
 r_value = gt_parameters[ iobjnm = |{ gc_result }{ sy-sysid }| ]-opt.
Catch cx_sy_itab_line_not_found.

Endtry.
endmethod.

method read_rowcount.
Try.
  r_value = gt_parameters[ iobjnm = gc_keyfigure ]-high.
Catch cx_sy_itab_line_not_found.

Endtry.
ENDMETHOD.

method read_keyfigure.
rt_value = value tyt_keyfigure( FOR <ls_parameter> in gt_parameters WHERE ( iobjnm = gc_keyfigure ) ( CONV rsdiobjnm( <ls_parameter>-low ) ) ).
endmethod.

method read_factor.
Try.
  r_value = me->gt_parameters[ iobjnm = gc_factor ]-low.
Catch cx_sy_itab_line_not_found.

Endtry.
ENDMETHOD.

method get_data.
Select *
  from ztm_dqf_cases
  into table @rt_value
  where num  = @gv_case
    and wp   = @gv_workpackage
    and type = @gv_type
    and iobjnm like 'ZZ%'.

ENDMETHOD.

method set_type.
me->gv_type = i_type.
ENDMETHOD.

method set_case.
me->gv_case = i_case.
ENDMETHOD.

method set_workpackage.
me->gv_workpackage = i_workpackage.
ENDMETHOD.

METHOD read_hcpr.
Try.
  r_value = me->gt_parameters[ iobjnm = gc_hcpr ]-low.
Catch cx_sy_itab_line_not_found.

Endtry.
ENDMETHOD.

METHOD read_query.
Try.
  r_value = me->gt_parameters[ iobjnm = gc_query ]-low.
Catch cx_sy_itab_line_not_found.

Endtry.
ENDMETHOD.

ENDCLASS.
