CLASS zcl_dqf_query DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  GLOBAL FRIENDS zcl_dqf .

PUBLIC SECTION.

    "! <p class="shorttext synchronized" lang="en">Constructor</p>
    "!
    METHODS constructor.

PROTECTED SECTION.
PRIVATE SECTION.

  TYPES: "! <p class="shorttext synchronized" lang="en">Query Keyfigure Structure</p>
    BEGIN OF ty_keyfigure,
      keyfigure TYPE rschanm,
      structure TYPE rschavl_maxlen,
    END OF ty_keyfigure.

  TYPES: "! <p class="shorttext synchronized" lang="en">Table of Query Keyfigure Structure</p>
    tyt_keyfigure TYPE STANDARD TABLE OF ty_keyfigure WITH EMPTY KEY.

  DATA: "! <p class="shorttext synchronized" lang="en">Parameters</p>
    gs_parameter TYPE zcl_dqf_read_table=>ty_parameter.

  DATA: "! <p class="shorttext synchronized" lang="en">Number of Query Elements</p>
    gv_query_elements TYPE int2.

  DATA: "! <p class="shorttext synchronized" lang="en">Table of Query Variables</p>
    gt_variables TYPE rsr_t_variable_definition.

  DATA: "! <p class="shorttext synchronized" lang="en">Structure of Keyfigure</p>
    gs_keyfigure TYPE ty_keyfigure.

  "! <p class="shorttext synchronized" lang="en">Get Data from Query</p>
  "!
  "! @parameter it_parameter | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter r_value      | <p class="shorttext synchronized" lang="en">Return result of query</p>
  METHODS get_data
    IMPORTING
      it_parameter TYPE rrxw3tquery
    RETURNING
      VALUE(r_value) TYPE zcl_dqf=>ty_data.

  "! <p class="shorttext synchronized" lang="en">Set Testcase Parameter</p>
  "!
  "! @parameter is_parameters | <p class="shorttext synchronized" lang="en">Testcase Parameter</p>
  METHODS set_parameters
    IMPORTING
      is_parameters TYPE zcl_dqf_read_table=>ty_parameter.

  "! <p class="shorttext synchronized" lang="en">Read Query Variables from Query</p>
  "!
  METHODS read_query_variables.

  "! <p class="shorttext synchronized" lang="en">Build Query Filter</p>
  "!
  "! @parameter it_variable  | <p class="shorttext synchronized" lang="en">Table of Variables</p>
  "! @parameter is_keyfigure | <p class="shorttext synchronized" lang="en">Structure of Keyfigure</p>
  "! @parameter i_case       | <p class="shorttext synchronized" lang="en">Testcase</p>
  "! @parameter rt_parameter | <p class="shorttext synchronized" lang="en">Return query parameter</p>
  METHODS get_query_filter
    IMPORTING
      !i_case       TYPE ztm_dqf_cases OPTIONAL
    RETURNING
      VALUE(rt_parameter) TYPE rrxw3tquery .

  "! <p class="shorttext synchronized" lang="en">Read Query Keyfigure</p>
  "!
  "! @parameter rt_keyfigure | <p class="shorttext synchronized" lang="en">Return table of keyfigures</p>
  METHODS read_query_keyfigure
    RETURNING
      VALUE(rt_keyfigure) TYPE rrxw3tquery.

  "! <p class="shorttext synchronized" lang="en">Count Query Elements</p>
  "!
  "! @parameter i_number | <p class="shorttext synchronized" lang="en">Number to add</p>
  METHODS count_query_elements
    IMPORTING
      i_number TYPE int2.


ENDCLASS.

CLASS zcl_dqf_query IMPLEMENTATION.

METHOD constructor.

ENDMETHOD.

METHOD count_query_elements.
  me->gv_query_elements = gv_query_elements + i_number.
ENDMETHOD.

METHOD get_data.
TYPES: ty_table TYPE STANDARD TABLE OF rrxfloat WITH EMPTY KEY.

DATA: lt_result  TYPE rrws_t_cell.

CALL FUNCTION 'RS_VC_GET_QUERY_VIEW_DATA'
 EXPORTING
   i_infoprovider                = gs_parameter-hcpr
   i_query                       = gs_parameter-query
   i_t_parameter                 = it_parameter
 IMPORTING
   e_cell_data                   = lt_result
 EXCEPTIONS
   no_applicable_data            = 1
   invalid_variable_values       = 2
   no_authority                  = 3
   abort                         = 4
   invalid_input                 = 5
   invalid_view                  = 6
   OTHERS                        = 7.

IF sy-subrc = 0.
  r_value-result = REDUCE i( INIT x = 0 FOR wa IN lt_result NEXT x = x + wa-value ).
ENDIF.

ENDMETHOD.

METHOD read_query_variables.
DATA: lt_variable TYPE rsr_t_variable_definition.

CALL FUNCTION 'RS_VC_GET_QUERY_VIEW_DEF'
  EXPORTING
    i_infoprovider                = gs_parameter-hcpr
    i_query                       = gs_parameter-query
  IMPORTING
    e_t_variable_definition       = gt_variables
  EXCEPTIONS
    no_applicable_data            = 1
    invalid_variable_values       = 2
    no_authority                  = 3
    abort                         = 4
    invalid_input                 = 5
    invalid_view                  = 6
    OTHERS                        = 7.

ENDMETHOD.

METHOD get_query_filter.

TYPES: ty_variable TYPE rsr_t_variable_definition.

DATA: ls_parameter TYPE w3query,
      lt_parameter TYPE rrxw3tquery.

"Check if there is a variable for the infoobject
"Skip hierarchy variables
DATA(lt_variable) = VALUE ty_variable( FOR <ls_variable> IN gt_variables WHERE ( vartyp <> '5' ) ( <ls_variable> ) ).

IF line_exists( lt_variable[ iobjnm = i_case-iobjnm ] ).

  DATA(ls_variable) = lt_variable[ iobjnm = i_case-iobjnm ].

  ls_parameter-name  = 'VAR_SIGN_' && gv_query_elements.
  ls_parameter-value = i_case-sign.

  APPEND ls_parameter TO lt_parameter.

  ls_parameter-name  = 'VAR_OPERATOR_' && gv_query_elements.
  ls_parameter-value = i_case-opt.

  APPEND ls_parameter TO lt_parameter.

  IF i_case-opt = 'EQ'.

    "Hierarchy Node
    IF ls_variable-vartyp = '2'.
      ls_parameter-name  = 'VAR_VALUE_EXT_' && gv_query_elements.
    ELSE.
      ls_parameter-name  = 'VAR_VALUE_LOW_EXT_' && gv_query_elements.
    ENDIF.
    ls_parameter-value = i_case-low.
    APPEND ls_parameter TO lt_parameter.

  ELSEIF i_case-opt = 'BT'.

    ls_parameter-name  = 'VAR_VALUE_LOW_EXT_' && gv_query_elements.
    ls_parameter-value = i_case-low.
    APPEND ls_parameter TO lt_parameter.
    ls_parameter-name  = 'VAR_VALUE_HIGH_EXT_' && gv_query_elements.
    ls_parameter-value = i_case-high.
    APPEND ls_parameter TO lt_parameter.

  ENDIF.

  IF ls_variable-vproctp = 3.
    ls_parameter-name  = 'VAR_ID_' && gv_query_elements.
  ELSE.
    ls_parameter-name  = 'VAR_NAME_' && gv_query_elements.
  ENDIF.
  ls_parameter-value = ls_variable-vnam.
  APPEND ls_parameter TO lt_parameter.

ELSE.

  "Create filter if there is no variable
  "Filter values can only be single values with Include
  ls_parameter-name  = 'FILTER_IOBJNM_' && gv_query_elements.

  IF i_case IS INITIAL.
    ls_parameter-value = gs_keyfigure-keyfigure.
  ELSE.
    ls_parameter-value = i_case-iobjnm.
  ENDIF.

  APPEND ls_parameter TO lt_parameter.
  ls_parameter-name  = 'FILTER_VALUE_' && gv_query_elements.

  IF i_case IS INITIAL.
    ls_parameter-value = gs_keyfigure-structure.
  ELSE.
    ls_parameter-value = i_case-low.
  ENDIF.
  APPEND ls_parameter TO lt_parameter.

ENDIF.

rt_parameter = lt_parameter.

ENDMETHOD.


METHOD read_query_keyfigure.
DATA: lt_columns      TYPE TABLE OF rrx_x_axis_data.

CALL FUNCTION 'RS_VC_GET_QUERY_VIEW_DATA_FLAT'
  EXPORTING
    i_infoprovider                = gs_parameter-hcpr
    i_query                       = gs_parameter-query
  TABLES
    e_t_axis_data_columns         = lt_columns
  EXCEPTIONS
   no_applicable_data            = 1
   invalid_variable_values       = 2
   no_authority                  = 3
   abort                         = 4
   invalid_input                 = 5
   invalid_view                  = 6
   OTHERS                        = 7.

IF sy-subrc = 0.
  TRY.
    LOOP AT gs_parameter-keyfigure ASSIGNING FIELD-SYMBOL(<ls_keyfigure>).
      gs_keyfigure-keyfigure = lt_columns[ caption = to_mixed( <ls_keyfigure> ) ]-chanm.
      gs_keyfigure-structure = lt_columns[ caption = to_mixed( <ls_keyfigure> ) ]-chavl.
      count_query_elements( 1 ).
      APPEND LINES OF get_query_filter( ) TO rt_keyfigure.
    ENDLOOP.
  CATCH cx_sy_itab_line_not_found INTO DATA(gex_table).
    MESSAGE gex_table->get_text( ) TYPE 'E'.
  ENDTRY.
ENDIF.
ENDMETHOD.

METHOD set_parameters.
me->gs_parameter = is_parameters.
ENDMETHOD.

ENDCLASS.
