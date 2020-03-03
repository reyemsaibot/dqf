"! Automated Testing of specific Testcases
"! Testcases must be specified in the table
"! zvb0t_testing. How you can do this check the readme on github.
CLASS zcl_dqf DEFINITION
  PUBLIC
  CREATE PUBLIC .

PUBLIC SECTION.

  INTERFACES zif_dqf_select .
  ALIASES: _load_navigation_attributes FOR zif_dqf_select~get_navigation_attributes,
           _load_display_attributes FOR zif_dqf_select~get_display_attributes,
           _load_infoobjects FOR zif_dqf_select~get_infoobjects,
           _get_conversion_base_char FOR zif_dqf_select~get_conversion_base_char,
           _get_conversion_characteristic FOR zif_dqf_select~get_conversion_characteristic,
           _get_dataelement_masterdata FOR zif_dqf_select~get_dataelement_masterdata,
           _get_dataelement FOR zif_dqf_select~get_dataelement,
           _get_dataelement_keyfigure FOR zif_dqf_select~get_dataelement_keyfigure,
           _get_datatype_keyfigure FOR zif_dqf_select~get_datatype_keyfigure,
           _get_datatype_characteristic FOR zif_dqf_select~get_datatype_characteristic,
           _check_table FOR zif_dqf_select~check_if_table_exists,
           _get_dataelement_hierarchy FOR zif_dqf_select~get_dataelement_hierarchy.


  TYPES: "! <p class="shorttext synchronized" lang="en">Workpackage</p>
    ty_workpackage TYPE ztm_dqf_cases-wp .
  TYPES: "! <p class="shorttext synchronized" lang="en">Range of work package</p>
    tyt_workpackages TYPE RANGE OF ty_workpackage .
  TYPES: "! <p class="shorttext synchronized" lang="en">Test case number</p>
    tyt_cases TYPE RANGE OF int2 .
  TYPES: "! <p class="shorttext synchronized" lang="en">Mail address</p>
    ty_mailaddress TYPE c LENGTH 90 .
  TYPES: "! <p class="shorttext synchronized" lang="en">Table of mail addresses</p>
    tyt_mailaddresses TYPE RANGE OF ty_mailaddress .
  TYPES: "! <p class="shorttext synchronized" lang="en">Structure of possible break points which can set by the user</p>
    BEGIN OF ty_breakpoints,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_data</p>
        wherecondition TYPE boolean,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_hierarchy_elements</p>
        hierarchy      TYPE boolean,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_condition</p>
        condition      TYPE boolean,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_result</p>
        result         TYPE boolean,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_singleentries</p>
        entries        TYPE boolean,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_testcases</p>
        get_case       TYPE boolean,
    END OF ty_breakpoints .
  TYPES: "! <p class="shorttext synchronized" lang="en">Table of test cases</p>
    tyt_zvb0t_dqf TYPE STANDARD TABLE OF ztm_dqf_cases WITH EMPTY KEY .

  "! <p class="shorttext synchronized" lang="en">Run the data quality framework</p>
  "!
  "! @parameter i_mail           | <p class="shorttext synchronized" lang="en">Send Mail? Yes or No</p>
  "! @parameter i_mailaddresses  | <p class="shorttext synchronized" lang="en">Send Mail to who</p>
  METHODS run
    IMPORTING
      !i_mail          TYPE rs_bool OPTIONAL
      !i_mailaddresses TYPE tyt_mailaddresses OPTIONAL.

  "! <p class="shorttext synchronized" lang="en">Constructor</p>
  "!
  "! @parameter i_workpackage  | <p class="shorttext synchronized" lang="en">Workpackage</p>
  "! @parameter i_case         | <p class="shorttext synchronized" lang="en">Testcase</p>
  "! @raising cx_no_data_found | <p class="shorttext synchronized" lang="en">No data found for selection</p>
  METHODS constructor
    IMPORTING
      !i_workpackage TYPE tyt_workpackages OPTIONAL
      !i_case TYPE tyt_cases OPTIONAL
    RAISING
      cx_no_data_found .

  "! <p class="shorttext synchronized" lang="en">Skip red cases</p>
  "!
  "! @parameter i_red_cases | <p class="shorttext synchronized" lang="en">Yes or no?</p>
  METHODS set_red_cases
    IMPORTING
      !i_red_cases TYPE rs_bool.

  "! <p class="shorttext synchronized" lang="en">Hide green cases</p>
  "!
  "! @parameter i_green_cases | <p class="shorttext synchronized" lang="en">Yes or no?</p>
  METHODS set_green_cases
    IMPORTING
      !i_green_cases TYPE rs_bool.

  "! <p class="shorttext synchronized" lang="en">Set definied breakpoints</p>
  "!
  "! @parameter is_breakpoints | <p class="shorttext synchronized" lang="en">List of breakpoints</p>
  METHODS set_breakpoints
    IMPORTING
      !is_breakpoints TYPE ty_breakpoints.

  TYPES: "! <p class="shorttext synchronized" lang="en">Result value</p>
    ty_result_value TYPE p LENGTH 16 DECIMALS 2 .

  TYPES: "! <p class="shorttext synchronized" lang="en">Output for data rows</p>
    ty_datarows TYPE p LENGTH 16 DECIMALS 0 .

  TYPES:  "! <p class="shorttext synchronized" lang="en">Result of select statement</p>
    BEGIN OF ty_data,
      result   TYPE ty_result_value,
      datarows TYPE ty_datarows,
    END OF ty_data .

PROTECTED SECTION.





PRIVATE SECTION.

  TYPES: "! <p class="shorttext synchronized" lang="en">Output for ALV Grid </p>
    BEGIN OF ty_alv_grid,
      status     TYPE c LENGTH 4,
      wp         TYPE ty_workpackage,
      testcase   TYPE int2,
      expected   TYPE string,
      result     TYPE string,
      s_comment  TYPE ztm_dqf_cases-comments,
      s_datarows TYPE p LENGTH 16 DECIMALS 0,
      t_comment  TYPE ztm_dqf_cases-comments,
      t_datarows TYPE p LENGTH 16 DECIMALS 0,
      quote      TYPE p LENGTH 16 DECIMALS 2,
    END OF ty_alv_grid .
  TYPES: "! <p class="shorttext synchronized" lang="en">Table of result test cases</p>
    tyt_alv_grid TYPE STANDARD TABLE OF ty_alv_grid WITH EMPTY KEY .
  TYPES: "! <p class="shorttext synchronized" lang="en">Table of string</p>
    tyt_string TYPE STANDARD TABLE OF string WITH EMPTY KEY .
  TYPES: "! <p class="shorttext synchronized" lang="en">Table of where condition</p>
    tyt_wherecondition TYPE STANDARD TABLE OF string WITH EMPTY KEY .

  TYPES:  "! <p class="shorttext synchronized" lang="en">Type for check data element</p>
    BEGIN OF ty_dataelement,
      infoobject TYPE rsdiobjnm,
      sign       TYPE c LENGTH 1,
    END OF ty_dataelement .
  TYPES: "! <p class="shorttext synchronized" lang="en">Range for an InfoObject</p>
    BEGIN OF ty_range_infoobject,
      infoobject TYPE rsiobjnm,
      option     TYPE rsoption,
      sign       TYPE rssign,
      low        TYPE rslow,
      high       TYPE rshigh,
    END OF ty_range_infoobject .
  TYPES: "! <p class="shorttext synchronized" lang="en">Type for flat a hierarchy</p>
    BEGIN OF ty_hierarchy,
     "! <p class="shorttext synchronized" lang="en">Hierarchy node which must be flatten</p>
     hierarchy_node  TYPE rshigh,
     "! <p class="shorttext synchronized" lang="en">Technical name of the hierarchy</p>
     hierarchy       TYPE rshienm,
     "! <p class="shorttext synchronized" lang="en">Technical name of the InfoObject, the hierarchy is based on</p>
     infoobject      TYPE rsiobjnm,
     "! <p class="shorttext synchronized" lang="en">Valid From</p>
     validfrom       TYPE /bi0/oidate,
     "! <p class="shorttext synchronized" lang="en">Valid To</p>
     validto         TYPE /bi0/oidate,
    END OF ty_hierarchy .
  TYPES: "! <p class="shorttext synchronized" lang="en">Type for selection condition</p>
    BEGIN OF ty_conditions,
      lines          TYPE int2,
      infoobject     TYPE rsiobjnm,
      range          TYPE rsrange,
      wherecondition TYPE string,
    END OF ty_conditions .
  TYPES:  "! <p class="shorttext synchronized" lang="en">Result Structure</p>
    BEGIN OF ty_result,
      source_result         TYPE ty_result_value,
      source_datarows       TYPE p LENGTH 16 DECIMALS 0,
      target_result         TYPE ty_result_value,
      target_datarows       TYPE p LENGTH 16 DECIMALS 0,
    END OF ty_result .

  CONSTANTS:
    gc_ne TYPE c LENGTH 2 VALUE 'NE' ##NO_TEXT.
  CONSTANTS:
    gc_eq TYPE c LENGTH 2 VALUE 'EQ' ##NO_TEXT.
  CONSTANTS: "! <p class="shorttext synchronized" lang="en">Type Hierarchy</p>
    gc_hierarchy TYPE c  LENGTH 2 VALUE 'HI' ##NO_TEXT.
  CONSTANTS:
    gc_gt TYPE c  LENGTH 2 VALUE 'GT' ##NO_TEXT.
  CONSTANTS:
    gc_lt TYPE c  LENGTH 2 VALUE 'LT' ##NO_TEXT.
  CONSTANTS:
    gc_le TYPE c  LENGTH 2 VALUE 'LE' ##NO_TEXT.
  CONSTANTS:
    gc_ge TYPE c  LENGTH 2 VALUE 'GE' ##NO_TEXT.
  CONSTANTS:
    gc_bt TYPE c  LENGTH 2 VALUE 'BT' ##NO_TEXT.
  CONSTANTS:
    gc_nb TYPE c  LENGTH 2 VALUE 'NB' ##NO_TEXT.
  "! Bracket exists Yes or No
  CLASS-DATA gv_bracket TYPE boolean .
  "! Count Entries
  CLASS-DATA gv_count TYPE int2 .
  "! Does multiple hierarchies exist for one case
  CLASS-DATA gv_multiple_hierarchies TYPE int2 .
  "! Hide Green Entries
  DATA gv_skip_green_statements TYPE boolean VALUE rs_c_false ##NO_TEXT.
  "! Skip Failed Cases
  DATA gv_skip_failed_statements TYPE boolean VALUE rs_c_false ##NO_TEXT.
  "! Does Entries exist for an InfoObject besides a hierarchy
  CLASS-DATA gv_entry_beside_hierarchy TYPE boolean .
  "! Is there any breakpoint set
  DATA gs_breakpoints TYPE ty_breakpoints .
  "! Are there multiple entries for an InfoObject
  CLASS-DATA gv_multiple_entries TYPE int2 .
  "! Is there more than one hierarchy for an InfoObject
  CLASS-DATA gv_number_of_hierarchies TYPE int2 .

  DATA gv_workpackage  TYPE ty_workpackage.
  DATA gv_case         TYPE int2.
  DATA gs_parameters_s TYPE zcl_dqf_read_table=>ty_parameter.
  DATA gs_parameters_t TYPE zcl_dqf_read_table=>ty_parameter.
  DATA gv_type         TYPE char2.

  DATA gt_query_parameter TYPE rrxw3tquery.
  DATA go_dqf_query       TYPE REF TO zcl_dqf_query.

  DATA gt_cases TYPE tyt_zvb0t_dqf .

  METHODS _get_cases
    IMPORTING
      !i_workpackage TYPE tyt_workpackages
      !i_case_number TYPE tyt_cases
    RETURNING
      VALUE(r_cases) TYPE tyt_zvb0t_dqf .
  "! Determine the defined conversions of an InfoObject
  "!
  "! @parameter i_value      | Import value which may must be converted
  "! @parameter i_infoobject | InfoObject to lookup the conversion routine
  "! @parameter r_value      | Return the value after conversion routine
  METHODS get_conversion
    IMPORTING
      !i_infoobject TYPE rsiobjnm
      !i_value TYPE c
    RETURNING
      VALUE(r_value) TYPE string .
  "! Check if InfoObject exists and return its field name.
  "!
  "! @parameter i_infoobject | InfoObject which should be checked
  "! @parameter r_fieldname  | Returning field name of an InfoObject
  METHODS check_iobj
    IMPORTING
      !i_infoobject TYPE rsdiobjnm
    RETURNING
      VALUE(r_fieldname) TYPE rsdiobjfieldnm .
  "! Get the data from the database
  "!
  "! @parameter i_test_case_criteria | This structure has all necessary information like ADSO, key figure, where condition and so on.
  "! @parameter r_result             | Value and datarows for your selection.
  "!
  "! @raising ZCX_DQF | Raise an exception of ZCX_DQF
  METHODS get_data
    IMPORTING
      !i_whereconditions TYPE tyt_wherecondition
    RETURNING
      VALUE(r_value) TYPE ty_data

    RAISING
      zcx_dqf .
  "! Get Type for test case
  "!
  "! @parameter it_zvb0t_dqf | Table of test cases
  "! @parameter i_type       | Type Source/Target/Check
  "! @parameter rt_zvb0t_dqf | Return table of test case with specific type
  METHODS get_type
    IMPORTING
      !i_type TYPE char2
    RETURNING
      VALUE(rt_cases) TYPE tyt_zvb0t_dqf .
  "! Get Navigation Attributes
  "!
  "! @parameter i_zvb0t_dqf | Testcase
  "! @parameter r_values    | Return table with values for the navigation attribute
  METHODS get_navigation_attribute
    IMPORTING
      !i_zvb0t_dqf TYPE ztm_dqf_cases
    RETURNING
      VALUE(r_value) TYPE tyt_string .
  "! Create dynamic Where Condition
  "!
  "! @parameter i_test_case_criteria | Table of Testcases with parameters and where condition
  "! @parameter rt_whereconditions   | Return of the where condition
  METHODS create_wherecondition
    RETURNING
      VALUE(rt_whereconditions) TYPE tyt_wherecondition .

  METHODS determine_values
    IMPORTING
      i_case TYPE ztm_dqf_cases
    EXPORTING
      e_case TYPE ztm_dqf_cases.

  METHODS determine_variables
    IMPORTING
      i_type TYPE string
      i_case TYPE ztm_dqf_cases
    RETURNING
      VALUE(r_value) TYPE string.

  "! Get Testcases
  "!
  "! @parameter it_zvb0t_dqf | Table of Testcases
  "! @parameter rt_case      | Table of check cases
  METHODS get_testcases
    RETURNING
      VALUE(rt_case) TYPE tyt_alv_grid .
  "! Get Parameter
  "!
  "! @parameter i_nums      | Arbeitspaket & Number of Testcase
  "! @parameter r_parameter | Parameter for Export
  METHODS get_parameters
    IMPORTING
      !i_type TYPE char2
    RETURNING
      VALUE(rs_value) TYPE zcl_dqf_read_table=>ty_parameter.

  "! Get Result
  "!
  "! @parameter i_result | Information about the test case
  "! @parameter rt_cases | Table of checked cases
  METHODS get_result
    IMPORTING
      !i_result TYPE ty_result
    RETURNING
      VALUE(rt_cases) TYPE tyt_alv_grid .
  "! Get Single Entries
  "!
  "! @parameter it_values         | Table of Hierarchy Elements
  "! @parameter i_condition       | Table for Testcases
  "! @parameter rt_wherecondition | Whercondtion for select statement
  METHODS get_singleentries
    IMPORTING
      !it_values TYPE tyt_string OPTIONAL
      !i_condition TYPE ty_conditions
    RETURNING
      VALUE(rt_wherecondition) TYPE tyt_wherecondition .
  "! Send Mail
  "!
  "! @parameter i_cases | Table of test cases
  CLASS-METHODS send_mail
    IMPORTING
      !i_cases TYPE tyt_alv_grid
      !i_recipient TYPE STANDARD TABLE .
  "! Get Condition based on Sign and Option
  "!
  "! @parameter is_condition | Structure with lines, InfoObject and sign, option, low and high value
  "! @parameter r_wherecondition | Return where condition with sign, option and value
  "! @raising   zcx_uv_sign | Exception if sign or option is not found
  METHODS get_condition
    IMPORTING
      !is_condition TYPE ty_conditions
    RETURNING
      VALUE(r_wherecondition) TYPE string
    RAISING
      zcx_dqf .
  "! Get single members of a hierarchy
  "!
  "! @parameter i_hierarchy           | Structure with hierarchy, node and InfoObject
  "! @parameter r_flatlist            | List of Hierarchy Elements
  "! @raising   cx_rsr_hier_not_found | Hierarchy Not Found
  METHODS get_hierarchy_elements
    IMPORTING
      !i_hierarchy TYPE ty_hierarchy
    RETURNING
      VALUE(r_flatlist) TYPE tyt_string
    RAISING
      cx_rsr_hier_not_found .
  "! Get Output on Screen as ALV Grid.
  "!
  "! @parameter i_cases | Table of checked cases
  METHODS get_output
    IMPORTING
      !i_cases TYPE tyt_alv_grid .

  "! <p class="shorttext synchronized" lang="en">Determine multiple entries for one InfoObject</p>
  "!
  "! @parameter i_row    | <p class="shorttext synchronized" lang="en">Line of test case</p>
  "! @parameter i_option | <p class="shorttext synchronized" lang="en">Option if hierarchy or normal InfoObject</p>
  "! @parameter r_value  | <p class="shorttext synchronized" lang="en">Return number of entries</p>
  METHODS determine_multiple_entries
    IMPORTING
      !i_row    TYPE ztm_dqf_cases
      !i_option TYPE char2 OPTIONAL
    RETURNING
      VALUE(r_value) TYPE int2 .

  "! <p class="shorttext synchronized" lang="en">Create a test case on the given parameter</p>
  "!
  "! @parameter i_type  | <p class="shorttext synchronized" lang="en">Type of Test case either Change or Source/Target</p>
  "! @parameter r_value | <p class="shorttext synchronized" lang="en">Return result and datarows</p>
  METHODS build_test_case
    IMPORTING
       i_type TYPE char2
    RETURNING
      VALUE(r_value) TYPE ty_data.

  "! <p class="shorttext synchronized" lang="en">Set Workpackage</p>
  "!
  "! @parameter i_workpackage | <p class="shorttext synchronized" lang="en">Workpackage</p>
  METHODS set_workpackages
    IMPORTING
      i_workpackage TYPE ty_workpackage.

  "! <p class="shorttext synchronized" lang="en">Set Case Number</p>
  "!
  "! @parameter i_case | <p class="shorttext synchronized" lang="en">Case Number</p>
  METHODS set_case_number
    IMPORTING
      i_case TYPE int2.

  "! <p class="shorttext synchronized" lang="en">Set Case Type</p>
  "!
  "! @parameter i_type | <p class="shorttext synchronized" lang="en">Case Type S/T/C</p>
  METHODS set_type
    IMPORTING
      i_type TYPE char2.

ENDCLASS.



CLASS zcl_dqf IMPLEMENTATION.


METHOD build_test_case.

DATA: ls_parameter TYPE zcl_dqf_read_table=>ty_parameter.

IF line_exists( me->gt_cases[ num = gv_case wp = gv_workpackage type = i_type ] ).
  set_type( i_type ).
  IF i_type(1) = 'S'.
    gs_parameters_s = get_parameters( i_type ).
    ls_parameter = gs_parameters_s.
  ELSE.
    gs_parameters_t = get_parameters( i_type ).
    ls_parameter = gs_parameters_t.
  ENDIF.
  TRY.
    IF ls_parameter-query EQ ''. "Normal Testcase
      r_value = get_data( create_wherecondition( ) ).
    ELSEIF ls_parameter-query NE ''. "Query Testcase
    create_wherecondition( ). "ToDo
       r_value = go_dqf_query->get_data( gt_query_parameter  ).
    ENDIF.
  CATCH zcx_dqf INTO DATA(cx_dqf).
     IF me->gv_skip_failed_statements = rs_c_true.
       RETURN. "Skip this record
     ENDIF.
     MESSAGE cx_dqf->get_text(  ) TYPE 'E'.
  ENDTRY.
ENDIF.
ENDMETHOD.


METHOD check_iobj.

DATA: lv_infoobject        TYPE rsiobjnm,
      lv_display_attribute TYPE rsiobjnm.

"Check for navigation attribute
IF i_infoobject CS '__'.
  TRY.
    DATA(lt_navigation_infoobjects) = _load_navigation_attributes( i_infoobject = i_infoobject ).
    TRY.
      lv_infoobject = lt_navigation_infoobjects[ atrnavnm = i_infoobject ]-chanm.
    CATCH cx_sy_itab_line_not_found INTO DATA(cx_table).
      MESSAGE cx_table->get_text(  ) TYPE 'E'.
    ENDTRY.
  CATCH zcx_dqf.
    lv_infoobject = i_infoobject.
    DATA(lv_infoobject_length) = sy-fdpos.

    CALL FUNCTION 'STRING_SPLIT_AT_POSITION'
      EXPORTING
        string  = lv_infoobject
        pos     = lv_infoobject_length + 2 "Offset for __
      IMPORTING
       string1  = lv_infoobject
       string2  = lv_display_attribute.

    lv_infoobject = lv_infoobject(lv_infoobject_length).

    TRY.
      DATA(lt_display_infoobjects) = _load_display_attributes( lv_display_attribute ).
    CATCH zcx_dqf INTO DATA(cx_infoobject).
      MESSAGE cx_infoobject->get_text(  ) TYPE 'E'.
    ENDTRY.
  ENDTRY.
ELSE.
  lv_infoobject = i_infoobject.
ENDIF.

TRY.
  DATA(lt_infoobjects) = _load_infoobjects( to_upper( lv_infoobject ) ).
  TRY.
    r_fieldname = lt_infoobjects[ iobjnm = lv_infoobject ]-fieldnm.
  CATCH cx_sy_itab_line_not_found INTO DATA(cx_fieldnm).
    MESSAGE cx_fieldnm->get_text( ) TYPE 'E'.
  ENDTRY.
CATCH zcx_dqf INTO DATA(cx_infoobjects).
  MESSAGE cx_infoobjects->get_text(  ) TYPE 'E'.
ENDTRY.
ENDMETHOD.


METHOD constructor.

me->gt_cases = _get_cases( EXPORTING i_workpackage = i_workpackage
                                     i_case_number = i_case ).

IF me->gt_cases[] IS INITIAL.
  RAISE EXCEPTION TYPE cx_no_data_found.
ENDIF.

ENDMETHOD.


METHOD create_wherecondition.

DATA: lt_wherecondition  TYPE tyt_wherecondition,
      ls_hierarchy       TYPE ty_hierarchy,
      ls_condition       TYPE ty_conditions,
      wa_testcase        TYPE ztm_dqf_cases,
      ls_parameter       TYPE zcl_dqf_read_table=>ty_parameter.

SORT me->gt_cases ASCENDING BY wp num iobjnm opt.

"Create the dynamic where condition
LOOP AT me->gt_cases ASSIGNING FIELD-SYMBOL(<ls_test_case>) WHERE wp   = gv_workpackage
                                                             AND num  = gv_case
                                                             AND type = gv_type.

  IF <ls_test_case>-iobjnm+0(2) = 'ZZ' OR <ls_test_case>-num NE gv_case.
    "Skip this record, as we do not use this in this case
  ELSE.
    "Check if it is a query or adso we need to check
    IF gv_type(1) = 'S'.
      ls_parameter = gs_parameters_s.
    ELSE.
      ls_parameter = gs_parameters_t.
    ENDIF.

    IF ls_parameter-query = ''.

      "Check if it is a hierarchy
      IF <ls_test_case>-opt = gc_hierarchy.
        TRY.
           IF gv_multiple_hierarchies = 0.
             "Loop for multiple entries
             gv_multiple_hierarchies = determine_multiple_entries( i_option = gc_hierarchy
                                                                   i_row    = <ls_test_case> ).
           ENDIF.

           "Get time information to determine the next valid hierarchy in case of time dependency.
           ls_hierarchy-validfrom       = <ls_test_case>-validfrom.
           ls_hierarchy-validto         = <ls_test_case>-validto.
           ls_hierarchy-hierarchy       = <ls_test_case>-low.
           ls_hierarchy-hierarchy_node  = get_conversion( i_infoobject = <ls_test_case>-iobjnm
                                                          i_value      = <ls_test_case>-high ).
           ls_hierarchy-infoobject      = <ls_test_case>-iobjnm.

           DATA(hierarchy_elements) = get_hierarchy_elements( ls_hierarchy  ).
        CATCH cx_rsr_hier_not_found INTO DATA(gex_hierarchy).
          MESSAGE gex_hierarchy->get_text( ) TYPE 'E'.
        ENDTRY.
      ELSE.
        CLEAR: hierarchy_elements.
      ENDIF.

      "Need for Conversion Routine
      determine_values( EXPORTING i_case = <ls_test_case>
                        IMPORTING e_case = wa_testcase ).

      gv_number_of_hierarchies = me->determine_multiple_entries( i_option = gc_hierarchy
                                                                 i_row    = wa_testcase ).

      ls_condition-infoobject   = check_iobj( wa_testcase-iobjnm ).
      ls_condition-lines        = determine_multiple_entries( i_row = wa_testcase ).
      ls_condition-range-sign   = wa_testcase-sign.
      ls_condition-range-option = wa_testcase-opt.
      ls_condition-range-low    = wa_testcase-low.
      ls_condition-range-high   = wa_testcase-high.

      IF lt_wherecondition IS INITIAL.
        ls_condition-wherecondition = rs_c_false.
      ELSE.
        ls_condition-wherecondition = rs_c_true.
      ENDIF.

      IF hierarchy_elements[] IS INITIAL.
        IF wa_testcase-opt = gc_ne OR wa_testcase-opt = gc_eq AND wa_testcase-sign = 'E'.
          gv_entry_beside_hierarchy = rs_c_false.
        ELSEIF gv_number_of_hierarchies > 0.
          gv_entry_beside_hierarchy = rs_c_true.
        ENDIF.
      ENDIF.

      "Get Entries for Navigation Attributes
      IF wa_testcase-iobjnm CS '__'.
        DATA(lt_values) = get_navigation_attribute( wa_testcase ).
      ENDIF.

      "Check if a hierarchy exists
      IF hierarchy_elements[] IS NOT INITIAL.
        lt_values = hierarchy_elements.
      ELSEIF hierarchy_elements[] IS INITIAL AND wa_testcase-iobjnm NS '__'.
        CLEAR lt_values.
      ENDIF.
      APPEND LINES OF get_singleentries( it_values   = lt_values
                                         i_condition = ls_condition ) TO lt_wherecondition.
      CLEAR: wa_testcase.

    ELSE.
      go_dqf_query = NEW zcl_dqf_query( ).
      determine_values( EXPORTING i_case = <ls_test_case>
                        IMPORTING e_case = wa_testcase ).

      go_dqf_query->count_query_elements( 1 ).
      go_dqf_query->set_parameters( ls_parameter ).
      go_dqf_query->read_query_variables( ).

      APPEND LINES OF go_dqf_query->get_query_filter( wa_testcase ) TO gt_query_parameter.
      APPEND LINES OF go_dqf_query->read_query_keyfigure( ) TO gt_query_parameter.

    ENDIF.
  ENDIF.
ENDLOOP.
APPEND LINES OF lt_wherecondition TO rt_whereconditions.
ENDMETHOD.


METHOD determine_multiple_entries.
IF i_option NE gc_hierarchy.
  r_value = REDUCE i( INIT x = 0 FOR wa IN me->gt_cases WHERE ( num = i_row-num AND iobjnm = i_row-iobjnm AND wp = i_row-wp AND opt <> 'HI' ) NEXT x = x + 1 ).
ELSE.
  r_value = REDUCE i( INIT x = 0 FOR wa IN me->gt_cases WHERE ( num = i_row-num AND iobjnm = i_row-iobjnm AND wp = i_row-wp AND opt = 'HI' ) NEXT x = x + 1 ).
ENDIF.
ENDMETHOD.


METHOD determine_values.

e_case = i_case.

IF i_case-low(1) = '$'.
  e_case-low = determine_variables( i_case = i_case
                                    i_type = 'low' ).
ELSE.
  e_case-low = get_conversion( EXPORTING i_infoobject = i_case-iobjnm
                                         i_value      = i_case-low ).
ENDIF.

IF i_case-high(1) = '$'.
  e_case-high = determine_variables( i_case = i_case
                                     i_type = 'high' ).
ELSE.
  e_case-high = get_conversion( EXPORTING i_infoobject = i_case-iobjnm
                                          i_value      = i_case-high ).
ENDIF.

ENDMETHOD.


METHOD determine_variables.

DATA lv_calmonth  TYPE /bi0/oicalmonth.
DATA lv_calyear   TYPE /bi0/oicalyear.
DATA lv_calmonth2 TYPE /bi0/oicalmonth2.
DATA lv_fiscper   TYPE /bi0/oifiscper.
DATA lv_fiscper3  TYPE /bi0/oifiscper3.
DATA lv_fiscyear  TYPE /bi0/oifiscyear.

ASSIGN COMPONENT i_type OF STRUCTURE i_case TO FIELD-SYMBOL(<lv_variable_value>).

IF <lv_variable_value>(10) = '$CALMONTH$'.
  lv_calmonth = sy-datum(6).
  "Offset
  IF <lv_variable_value>+10(1) = '-'.
    lv_calmonth = lv_calmonth - <lv_variable_value>+11(2).
  ENDIF.
  r_value = lv_calmonth.
ELSEIF <lv_variable_value>(9) = '$CALYEAR$'.
  lv_calyear = sy-datum(4).
  IF <lv_variable_value>+9(1) = '-'.
    lv_calyear = lv_calyear - <lv_variable_value>+10(2).
  ENDIF.
  r_value = lv_calyear.
ELSEIF <lv_variable_value>(11) = '$CALMONTH2$'.
  lv_calmonth2 = sy-datum+4(2).
  IF <lv_variable_value>+11(1) = '-'.
    lv_calmonth2 = lv_calmonth2 - <lv_variable_value>+12(2).
  ENDIF.
  r_value = lv_calmonth2.
ELSEIF <lv_variable_value>(9) = '$FISCPER$'.
  lv_fiscper = |{ sy-datum(4) }0{ sy-datum+4(2) }|.
  IF <lv_variable_value>+9(1) = '-'.
    lv_fiscper = lv_fiscper - <lv_variable_value>+10(2).
  ENDIF.
  r_value = lv_fiscper.
ELSEIF <lv_variable_value>(10) = '$FISCPER3$'.
  lv_fiscper3 = |0{ sy-datum+4(2) }|.
  IF <lv_variable_value>+10(1) = '-'.
    lv_fiscper3 = lv_fiscper3 - <lv_variable_value>+11(2).
  ENDIF.
  r_value = lv_fiscper3.
ELSEIF <lv_variable_value>(10) = '$FISCYEAR$'.
  lv_fiscyear = sy-datum(4).
  IF <lv_variable_value>+10(1) = '-'.
    lv_fiscyear = lv_fiscyear - <lv_variable_value>+11(2).
  ENDIF.
  r_value = lv_fiscyear.
ENDIF.

ENDMETHOD.


METHOD get_condition.

DATA: wherecondition TYPE string.

IF me->gs_breakpoints-condition = rs_c_true.
  BREAK-POINT.
ENDIF.

"More than one entry and table is empty
IF is_condition-lines > 1 AND is_condition-wherecondition = rs_c_false.
  wherecondition = `( ` && is_condition-infoobject.
  gv_bracket = rs_c_true.
  gv_count = gv_count + 1.
"It exists entries for the same InfoObjet besides a hierarchy
ELSEIF is_condition-lines > 1 AND is_condition-wherecondition = rs_c_true AND gv_bracket = rs_c_true AND gv_entry_beside_hierarchy = rs_c_true.
  wherecondition = ` OR ` && is_condition-infoobject.
  gv_count = gv_count + 1.
"When it starts with a single entry and a hierarchy also exists
ELSEIF is_condition-lines = 1 AND is_condition-wherecondition = rs_c_true AND gv_entry_beside_hierarchy = rs_c_true AND gv_bracket = rs_c_false.
  wherecondition = `AND ( ` && is_condition-infoobject.
  gv_bracket = rs_c_true.
  gv_count = gv_count + 1.
  gv_entry_beside_hierarchy = rs_c_false.
"More than one entry but table is not empty
ELSEIF is_condition-lines > 1 AND is_condition-wherecondition = rs_c_true AND gv_bracket = rs_c_false.
  wherecondition = `AND ( ` && is_condition-infoobject.
  gv_bracket = rs_c_true.
  gv_count = gv_count + 1.
ELSEIF is_condition-lines > 1 AND is_condition-wherecondition = rs_c_true AND gv_bracket = rs_c_true AND is_condition-range-sign = 'E'.
  wherecondition = ` AND ` && is_condition-infoobject.
  gv_count = gv_count + 1.
"More than one entry and table is not empty and not all conditions are added
ELSEIF is_condition-lines > 1 AND is_condition-wherecondition = rs_c_true AND gv_bracket = rs_c_true.
  wherecondition = ` OR ` && is_condition-infoobject.
  gv_count = gv_count + 1.
ELSEIF is_condition-wherecondition = rs_c_false.
  wherecondition = is_condition-infoobject
  .
ELSE.
  wherecondition = ` AND ` && is_condition-infoobject.
ENDIF.

"Conditions
IF is_condition-range-low CS '%' OR is_condition-range-high CS '%'.
  IF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_eq ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_ne ).
     wherecondition = wherecondition && ` like ` && '''' && is_condition-range-low && ''''.
  ELSEIF ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_eq ) OR ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_ne ).
     wherecondition = wherecondition && ` not like ` && '''' && is_condition-range-low && ''''.
  ENDIF.
ELSE.
    IF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_eq ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_ne ).
      wherecondition = wherecondition && ` = ` && '''' && is_condition-range-low && ''''.
    ELSEIF ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_eq ) OR ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_ne ).
      wherecondition = wherecondition && ` <> ` && '''' && is_condition-range-low && ''''.
    ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_bt ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_nb ).
      wherecondition = wherecondition && ` BETWEEN ` && '''' && is_condition-range-low && '''' &&  ` AND ` && '''' && is_condition-range-high && ''''.
    ELSEIF ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_bt ) OR ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_nb ).
      wherecondition = wherecondition && ` NOT BETWEEN ` && '''' && is_condition-range-low && '''' &&  ` AND ` && '''' && is_condition-range-high && ''''.
    ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_gt ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_le ).
      wherecondition = wherecondition && ` GT ` && '''' && is_condition-range-low && ''''.
    ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_le ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_gt ) .
      wherecondition = wherecondition && ` LE ` && '''' && is_condition-range-low && ''''.
    ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_ge ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_lt ) .
      wherecondition = wherecondition && ` GE ` && '''' && is_condition-range-low && ''''.
    ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_lt ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_ge ) .
      wherecondition = wherecondition && ` LT ` && '''' && is_condition-range-low && ''''.
    ELSE.
     RAISE EXCEPTION TYPE zcx_dqf
       EXPORTING
         textid   = zcx_dqf=>sign_option_not_exists
         sign = is_condition-range-sign
         option = is_condition-range-option.
    ENDIF.
ENDIF.

IF is_condition-lines = 1.
  r_wherecondition = wherecondition.
  gv_count = 0.
ELSEIF is_condition-lines = gv_count AND gv_bracket = rs_c_true AND gv_multiple_hierarchies > 1.
  r_wherecondition = wherecondition.
  gv_count = 0.
  gv_multiple_hierarchies = gv_multiple_hierarchies - 1.
ELSEIF is_condition-lines = gv_count AND gv_bracket = rs_c_true AND gv_entry_beside_hierarchy = rs_c_true.
  r_wherecondition = wherecondition.
  gv_count = 0.
  gv_multiple_hierarchies = 0.
  gv_entry_beside_hierarchy = rs_c_false.
ELSEIF is_condition-lines = gv_count AND gv_bracket = rs_c_true.
  r_wherecondition = wherecondition && ` )`.
  gv_bracket = rs_c_false.
  gv_count = 0.
  gv_multiple_hierarchies = 0.
ELSE.
  r_wherecondition = wherecondition.
ENDIF.

ENDMETHOD.


METHOD get_conversion.

DATA: lv_value         TYPE string,
      lv_numeric_value TYPE string,
      lv_datatype      TYPE datatype_d.

TRY.
  DATA(ls_convexit) = _get_conversion_base_char( i_infoobject ).
CATCH zcx_dqf.
  TRY.
    DATA(lv_rsdcha) = _get_conversion_characteristic( i_infoobject ).
    ls_convexit     = _get_conversion_base_char( lv_rsdcha ).
  CATCH zcx_dqf INTO DATA(cx_infoobject_not_exists).
    MESSAGE cx_infoobject_not_exists->get_text( ) TYPE 'E'.
  ENDTRY.
ENDTRY.

IF ls_convexit-convexit = 'ALPHA'.

  CALL FUNCTION 'NUMERIC_CHECK'
    EXPORTING
      string_in   = i_value
   IMPORTING
     string_out   = lv_numeric_value
     htype        = lv_datatype.

  IF lv_datatype <> 'CHAR'.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input         = i_value
      IMPORTING
        output        = lv_value.
    DATA(lv_offset) = strlen( lv_value ) - ls_convexit-outputlen.
    r_value = lv_value+lv_offset(ls_convexit-outputlen).
  ELSE.
    r_value = i_value.
  ENDIF.
ELSEIF ls_convexit-convexit = 'PERI6'.
  IF strlen( i_value ) > 6.
    CALL FUNCTION 'CONVERSION_EXIT_PERI6_INPUT'
      EXPORTING
        input                 = i_value
     IMPORTING
        output                = lv_value.
    r_value = lv_value.
  ELSE.
    r_value = i_value.
  ENDIF.
ELSE.
  r_value = i_value.
ENDIF.
ENDMETHOD.


METHOD get_data.

TYPES: ty_wherecond TYPE STANDARD TABLE OF string WITH EMPTY KEY.

DATA: lr_result_adso        TYPE REF TO data,
      lv_column_name        TYPE string,
      lv_datarows           TYPE p DECIMALS 0,
      lv_multiple_keyfigure TYPE i VALUE 0,
      lt_fieldcat           TYPE lvc_t_fcat,
      ls_fieldcat           TYPE lvc_s_fcat,
      lv_kyf_sum            TYPE ty_result_value,
      lr_rtti_struc         TYPE REF TO cl_abap_structdescr,
      lt_comp               TYPE cl_abap_structdescr=>component_table,
      ls_parameter          TYPE zcl_dqf_read_table=>ty_parameter.

FIELD-SYMBOLS: <fs_result_adso> TYPE any,
               <fs_dyn_field>   TYPE any,
               <ft_result_adso> TYPE ANY TABLE.

IF gv_type(1) = 'S'.
  ls_parameter = gs_parameters_s.
ELSE.
  ls_parameter = gs_parameters_t.
ENDIF.

LOOP AT ls_parameter-keyfigure ASSIGNING FIELD-SYMBOL(<ls_keyfigure>).
  DATA(lv_fieldname) = check_iobj( <ls_keyfigure> ).
  DATA(lv_type_keyfigure) = _get_dataelement_keyfigure( <ls_keyfigure> ).
  lv_multiple_keyfigure = lv_multiple_keyfigure + 1.
  TRY.
   ls_fieldcat-datatype = _get_datatype_keyfigure( <ls_keyfigure> ).
  CATCH zcx_dqf.
    TRY.
      ls_fieldcat-datatype = _get_datatype_characteristic( <ls_keyfigure> ).
    CATCH zcx_dqf INTO DATA(cx_datatype).
      MESSAGE cx_datatype->get_text(  ) TYPE 'E'.
    ENDTRY.
  ENDTRY.
  ls_fieldcat-fieldname = <ls_keyfigure>.
  APPEND ls_fieldcat TO lt_fieldcat.
  CONCATENATE lv_column_name ` SUM( ` lv_fieldname ' )' INTO lv_column_name.
ENDLOOP.

IF lv_multiple_keyfigure = 0.
  IF sy-subrc NE 0.
    RAISE EXCEPTION TYPE zcx_dqf
      EXPORTING
        textid   = zcx_dqf=>infoobjects_not_exists
        iobjnm   = ''.
  ENDIF.
ELSEIF lv_multiple_keyfigure = 1.
  CREATE DATA lr_result_adso TYPE (lv_type_keyfigure).
  ASSIGN lr_result_adso->* TO <fs_result_adso>.
  IF sy-subrc NE 0.
    RETURN.
  ENDIF.

  IF ls_parameter-rowcount = 'COUNT(*)'.
    lv_column_name = ls_parameter-rowcount.
  ELSE.
    CONCATENATE `SUM( ` lv_fieldname ' )' INTO lv_column_name.
  ENDIF.

ELSE.

  cl_alv_table_create=>create_dynamic_table(
   EXPORTING
     it_fieldcatalog = lt_fieldcat
   IMPORTING
     ep_table = lr_result_adso ).

  ASSIGN lr_result_adso->* TO <ft_result_adso>.

ENDIF.

TRY.
  _check_table( ls_parameter-table ).
CATCH zcx_dqf INTO DATA(cx_table).
  MESSAGE cx_table->get_text( ) TYPE 'E'.
ENDTRY.
DATA(lt_wherecondition) = VALUE ty_wherecond( FOR <ls_wherecond> IN i_whereconditions ( <ls_wherecond> ) ).

TRY.

  IF me->gs_breakpoints-wherecondition = rs_c_true.
    BREAK-POINT.
  ENDIF.

  IF lv_multiple_keyfigure = 1.

    "Select data
    SELECT (lv_column_name)
      FROM (ls_parameter-table)
      INTO <fs_result_adso>
      WHERE (lt_wherecondition). "#EC CI_SEL_NESTED
    ENDSELECT.

  ELSE.

    SELECT (lv_column_name)
      FROM (ls_parameter-table)
      INTO TABLE <ft_result_adso>
      WHERE (lt_wherecondition).

    LOOP AT <ft_result_adso> ASSIGNING FIELD-SYMBOL(<f_line>).
      lr_rtti_struc ?= cl_abap_structdescr=>describe_by_data( <f_line> ). " Get the description of the data
      lt_comp = lr_rtti_struc->get_components( ). "Get the fields of the structure
      LOOP AT lt_comp ASSIGNING FIELD-SYMBOL(<ls_comp>).
        ASSIGN COMPONENT <ls_comp>-name OF STRUCTURE <f_line> TO <fs_dyn_field>.
        lv_kyf_sum = lv_kyf_sum + <fs_dyn_field>.
      ENDLOOP.
    ENDLOOP.

  ENDIF.

  "Count data
  SELECT COUNT(*)
    FROM (ls_parameter-table)
    INTO lv_datarows
    WHERE (lt_wherecondition). "#EC CI_SEL_NESTED

  IF lv_multiple_keyfigure = 1.
    r_value-result  = <fs_result_adso>.
  ELSE.
    r_value-result = lv_kyf_sum.
  ENDIF.
  r_value-datarows = lv_datarows.

CATCH cx_sy_dynamic_osql_syntax.
  IF gv_skip_failed_statements = rs_c_true.
    RETURN. "Skip this record
  ENDIF.
  MESSAGE `The Where Condition in Testcase ` && gv_case && ` of AP ` && gv_workpackage && ` is incorrect.` TYPE 'E'.
CATCH cx_sy_dynamic_osql_semantics INTO DATA(gex_semantics).
  IF gv_skip_failed_statements = rs_c_true.
    RETURN. "Skip this Record
  ENDIF.
  MESSAGE gex_semantics->get_text( ) && ` in table: ` && ls_parameter-table TYPE 'E'.
ENDTRY.
ENDMETHOD.


METHOD get_hierarchy_elements.
TYPES: ty_time_dep_hierarchy TYPE STANDARD TABLE OF rshiedir WITH EMPTY KEY.

DATA: lt_hierarchies         TYPE rssh_t_hiedir,
      ls_hierarchy           TYPE rshiedir,
      ls_subtree             TYPE rssh_s_nodebyname,
      lr_hierarchy_structure TYPE REF TO data,
      lv_infoobject          TYPE rsiobjnm,
      ls_hierarchy_selection TYPE rssh_s_hiesel.

FIELD-SYMBOLS: <fs_node>              TYPE any,
               <ft_hierarchy_as_list> TYPE ANY TABLE.

IF me->gs_breakpoints-hierarchy = rs_c_true.
  BREAK-POINT.
ENDIF.

TRY.
  DATA(lv_dataelement) = _get_dataelement_hierarchy( check_iobj( i_hierarchy-infoobject ) ).
CATCH zcx_dqf INTO DATA(cx_infoobject).
  MESSAGE cx_infoobject->get_text( ) TYPE 'E'.
ENDTRY.

lv_infoobject = lv_dataelement+7.

CREATE DATA lr_hierarchy_structure TYPE (lv_dataelement).
ASSIGN lr_hierarchy_structure->* TO <ft_hierarchy_as_list>.
CHECK <ft_hierarchy_as_list> IS ASSIGNED.

CALL FUNCTION 'RSSH_HIER_OF_IOBJ_GET'
 EXPORTING
   i_objvers      = rs_c_objvers-active
   i_iobjnm       = lv_infoobject
   i_langu        = sy-langu
 IMPORTING
   e_t_rshiedir  = lt_hierarchies.

IF i_hierarchy-validfrom IS INITIAL AND i_hierarchy-validto IS INITIAL.

  TRY.
    ls_hierarchy = lt_hierarchies[ hienm   = i_hierarchy-hierarchy
                                   objvers = rs_c_objvers-active ].
  CATCH cx_sy_itab_line_not_found.
    "Hierarchy was not found
    RAISE EXCEPTION TYPE cx_rsr_hier_not_found.
  ENDTRY.

ELSE.

  DATA(lt_time_dependent_hierarchy) = VALUE ty_time_dep_hierarchy( FOR <ls_hierarchy> IN lt_hierarchies WHERE ( hienm     = i_hierarchy-hierarchy AND
                                                                                                                objvers   = rs_c_objvers-active AND
                                                                                                                dateto   >= i_hierarchy-validto AND
                                                                                                                datefrom <= i_hierarchy-validfrom ) ( <ls_hierarchy> ) ).

  TRY.
    ls_hierarchy = lt_time_dependent_hierarchy[ hienm = i_hierarchy-hierarchy ].
  CATCH cx_sy_itab_line_not_found.
    RAISE EXCEPTION TYPE cx_rsr_hier_not_found.
  ENDTRY.
  ls_hierarchy_selection-iobjnm = i_hierarchy-infoobject.
  ls_hierarchy_selection-hienm  = i_hierarchy-hierarchy.
  ls_hierarchy_selection-dateto = i_hierarchy-validto.

ENDIF.

"Subtree to node/leave
CLEAR: ls_subtree.
ls_subtree-iobjnm   = lv_infoobject.
ls_subtree-nodename = i_hierarchy-hierarchy_node.

cl_rssh_hierarchy_func=>get( EXPORTING i_objvers       = rs_c_objvers-active
                                       i_hieid         = ls_hierarchy-hieid
                                       i_s_subtreesel  = ls_subtree
                                       i_s_hiesel      = ls_hierarchy_selection
                             IMPORTING e_t_hiestrucall = <ft_hierarchy_as_list> ).

LOOP AT <ft_hierarchy_as_list> ASSIGNING FIELD-SYMBOL(<fs_hiestrucall>).
  ASSIGN COMPONENT 'NODENAME' OF STRUCTURE <fs_hiestrucall> TO <fs_node>.
  APPEND <fs_node> TO r_flatlist.
ENDLOOP.

CLEAR: ls_hierarchy_selection, ls_hierarchy.

ENDMETHOD.


METHOD get_navigation_attribute.

DATA: lv_navigation_attribute  TYPE c LENGTH 20,
      lv_infoobject            TYPE c LENGTH 30,
      lv_master_data_table     TYPE string,
      lv_infoobject_navigation TYPE rsdiobjnm,
      lr_infoobject_ref        TYPE REF TO data,
      ls_condition             TYPE ty_conditions.

FIELD-SYMBOLS: <fs_infoobject> TYPE ANY TABLE.

DATA(lv_fieldname) = check_iobj( i_zvb0t_dqf-iobjnm ).
TRY.
  lv_master_data_table  = _get_dataelement_masterdata( lv_fieldname ).
CATCH zcx_dqf INTO DATA(cx_md_infoobject).
  MESSAGE cx_md_infoobject->get_text( ) TYPE 'E'.
ENDTRY.

IF i_zvb0t_dqf-iobjnm CA '_'.

  lv_infoobject = i_zvb0t_dqf-iobjnm.
  DATA(lv_position) = sy-fdpos.

  CALL FUNCTION 'STRING_SPLIT_AT_POSITION'
    EXPORTING
      string  = lv_infoobject
      pos     = lv_position + 2 "Offset for __
    IMPORTING
     string1  = lv_infoobject
     string2  = lv_navigation_attribute.

ENDIF.

"Get InfoObject
lv_infoobject_navigation = lv_navigation_attribute.

TRY.
  DATA(lv_dataelement) = _get_dataelement( lv_fieldname ).
CATCH zcx_dqf INTO DATA(cx_infoobject).
  MESSAGE cx_infoobject->get_text( ) TYPE 'E'.
ENDTRY.
CREATE DATA lr_infoobject_ref TYPE TABLE OF (lv_dataelement).
ASSIGN lr_infoobject_ref->* TO <fs_infoobject>.

IF sy-subrc EQ 0.
  TRY.
    ls_condition-range-sign   = i_zvb0t_dqf-sign.
    ls_condition-range-option = i_zvb0t_dqf-opt.
    ls_condition-range-low    = i_zvb0t_dqf-low.
    ls_condition-range-high   = i_zvb0t_dqf-high.
    ls_condition-infoobject   = check_iobj( lv_infoobject_navigation ).
    DATA(whereconditions)  = get_condition( ls_condition ).
  CATCH zcx_dqf INTO DATA(cx_sign_option).
    MESSAGE cx_sign_option->get_text(  ) TYPE 'E'.
  ENDTRY.

  TRY.
    SELECT (lv_fieldname)
      FROM (lv_master_data_table)
      INTO TABLE <fs_infoobject>
      WHERE (whereconditions). "#EC CI_SEL_NESTED
    r_value = <fs_infoobject>.
  CATCH cx_sy_dynamic_osql_syntax.
    MESSAGE | The Where Condition in Testcase { gv_case } of AP { gv_workpackage } is incorrect. | TYPE 'E'.
  ENDTRY.
ENDIF.
ENDMETHOD.


METHOD get_output.

DATA: lt_fieldcat TYPE slis_t_fieldcat_alv,
      ls_fieldcat TYPE slis_fieldcat_alv,
      lv_layout   TYPE slis_layout_alv.

DATA(lt_case) = i_cases.

"Optimize ALV Grid Output
lv_layout-colwidth_optimize  = 'X'.

*Create field catalog
ls_fieldcat-fieldname = 'STATUS'.
ls_fieldcat-seltext_m = TEXT-001.
APPEND ls_fieldcat TO lt_fieldcat.
CLEAR: ls_fieldcat.

ls_fieldcat-fieldname = 'WP'.
ls_fieldcat-seltext_m = TEXT-003.
APPEND ls_fieldcat TO lt_fieldcat.
CLEAR: ls_fieldcat.

ls_fieldcat-fieldname = 'TESTCASE'.
ls_fieldcat-seltext_m = TEXT-004.
APPEND ls_fieldcat TO lt_fieldcat.
CLEAR: ls_fieldcat.

ls_fieldcat-fieldname = 'T_COMMENT'.
ls_fieldcat-seltext_l = TEXT-009.
APPEND ls_fieldcat TO lt_fieldcat.
CLEAR: ls_fieldcat.

ls_fieldcat-fieldname = 'EXPECTED'.
ls_fieldcat-seltext_m = TEXT-005.
APPEND ls_fieldcat TO lt_fieldcat.
CLEAR: ls_fieldcat.

ls_fieldcat-fieldname = 'RESULT'.
ls_fieldcat-seltext_m = TEXT-006.
APPEND ls_fieldcat TO lt_fieldcat.
CLEAR: ls_fieldcat.

ls_fieldcat-fieldname = 'S_DATAROWS'.
ls_fieldcat-seltext_l = TEXT-008.
APPEND ls_fieldcat TO lt_fieldcat.
CLEAR: ls_fieldcat.

ls_fieldcat-fieldname = 'T_DATAROWS'.
ls_fieldcat-seltext_l = TEXT-010.
APPEND ls_fieldcat TO lt_fieldcat.
CLEAR: ls_fieldcat.

ls_fieldcat-fieldname = 'S_COMMENT'.
ls_fieldcat-seltext_l = TEXT-007.
ls_fieldcat-no_out    = 'X'.
APPEND ls_fieldcat TO lt_fieldcat.
CLEAR: ls_fieldcat.

ls_fieldcat-fieldname = 'QUOTE'.
ls_fieldcat-seltext_l = 'Quote'.
APPEND ls_fieldcat TO lt_fieldcat.
CLEAR: ls_fieldcat.

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
   is_layout   = lv_layout
   it_fieldcat = lt_fieldcat
 TABLES
   t_outtab    = lt_case.

ENDMETHOD.


METHOD get_parameters.
DATA(ls_parameters) = NEW zcl_dqf_read_table( ).
ls_parameters->set_case( gv_case ).
ls_parameters->set_workpackage( gv_workpackage ).
ls_parameters->set_type( i_type ).
rs_value = ls_parameters->get_parameter( ).
ENDMETHOD.


METHOD get_result.

DATA: lv_s_result_value TYPE ty_result_value,
      lv_t_result_value TYPE ty_result_value,

      lv_flag           TYPE boolean,
      lt_case           TYPE tyt_alv_grid,
      lv_case           TYPE ty_alv_grid.

IF me->gs_breakpoints-result = rs_c_true.
  BREAK-POINT.
ENDIF.


"If there is a Source / Target Case
IF gs_parameters_s-keyfigure IS NOT INITIAL.

  IF gs_parameters_s-factor NE ''.
    lv_s_result_value = cl_java_script=>create( )->evaluate( 'eval( ' && i_result-source_result && gs_parameters_s-factor && ' );' ).
  ELSE.
    lv_s_result_value = i_result-source_result.
  ENDIF.

  IF gs_parameters_t-factor NE ''.
    lv_t_result_value = cl_java_script=>create( )->evaluate( 'eval( ' && i_result-target_result && gs_parameters_t-factor && ' );' ).
  ELSE.
    lv_t_result_value = i_result-target_result.
  ENDIF.

  IF lv_s_result_value = lv_t_result_value.
    lv_flag = rs_c_true.
  ELSE.
    lv_flag = rs_c_false.
  ENDIF.

ELSE.

  "Replace , with a .
  DATA(number_as_string) =  gs_parameters_t-result_expected.
  REPLACE ',' IN number_as_string WITH '.'.

  lv_s_result_value = number_as_string.
  lv_t_result_value = i_result-target_result.

  IF gs_parameters_t-factor NE ''.
    lv_t_result_value = cl_java_script=>create( )->evaluate( 'eval( ' && i_result-target_result && gs_parameters_t-factor && ' );' ).
  ENDIF.

  "Check option of zz_result
  IF gs_parameters_t-result_opt = gc_eq.
    IF lv_s_result_value = lv_t_result_value.
      lv_flag = rs_c_true.
    ELSE.
      lv_flag = rs_c_false.
    ENDIF.
  ELSEIF gs_parameters_t-result_opt = gc_ne.
    IF lv_s_result_value = lv_t_result_value AND i_result-target_datarows > 0. "Zero Values
      lv_flag = rs_c_true.
    ELSEIF lv_s_result_value <> lv_t_result_value.
      lv_flag = rs_c_true.
    ELSE.
      lv_flag = rs_c_false.
    ENDIF.
  ENDIF.

ENDIF.

IF lv_flag = rs_c_true AND me->gv_skip_green_statements = rs_c_true.
  "Do nothing when Hide Green Option is active and case is green.

ELSEIF lv_flag = rs_c_true.

   lv_case-status     = '@08@'.
   lv_case-wp         = gv_workpackage.
   lv_case-testcase   = gv_case.
   lv_case-expected   = lv_s_result_value.
   lv_case-result     = lv_t_result_value.
   lv_case-s_comment  = gs_parameters_s-comment .
   lv_case-t_comment  = gs_parameters_t-comment.
   lv_case-s_datarows = i_result-source_datarows .
   lv_case-t_datarows = i_result-target_datarows.
   TRY.
    lv_case-quote      = lv_t_result_value /  lv_s_result_value.
   CATCH cx_sy_zerodivide.
    lv_case-quote     = 0.
   ENDTRY.

   APPEND lv_case TO lt_case.

 ELSE.

   lv_case-status     = '@0A@'.
   lv_case-wp         = gv_workpackage.
   lv_case-testcase   = gv_case.
   lv_case-s_comment  = gs_parameters_s-comment.
   lv_case-t_comment  = gs_parameters_t-comment.
   lv_case-expected   = lv_s_result_value.
   lv_case-result     = lv_t_result_value.
   lv_case-s_datarows = i_result-source_datarows .
   lv_case-t_datarows = i_result-target_datarows.
   TRY.
    lv_case-quote      = lv_t_result_value /  lv_s_result_value.
   CATCH cx_sy_zerodivide.
    lv_case-quote     = 0.
   ENDTRY.
   APPEND lv_case TO lt_case.

ENDIF.
rt_cases = lt_case.
ENDMETHOD.


METHOD get_singleentries.
DATA: condition TYPE ty_conditions.

IF me->gs_breakpoints-entries = rs_c_true.
  BREAK-POINT.
ENDIF.

IF it_values[] IS NOT INITIAL.
  DESCRIBE TABLE it_values LINES gv_multiple_entries.
  LOOP AT it_values ASSIGNING FIELD-SYMBOL(<ls_value>).
    TRY.
      condition-lines                = gv_multiple_entries.
      condition-infoobject           = i_condition-infoobject.
      condition-range-sign           = i_condition-range-sign.
      condition-range-option         = gc_eq.
      condition-range-low            = CONV rslow( <ls_value> ).
      condition-range-high           = ''.
      condition-wherecondition       = i_condition-wherecondition.

      APPEND get_condition( condition ) TO rt_wherecondition.
    CATCH zcx_dqf INTO DATA(cx_sign_option).
      MESSAGE cx_sign_option->get_text(  ) TYPE 'E'.
    ENDTRY.
  ENDLOOP.
ELSE.
  TRY.
    APPEND get_condition( i_condition ) TO rt_wherecondition.
  CATCH zcx_dqf INTO DATA(cx_option_sign).
    MESSAGE cx_option_sign->get_text(  ) TYPE 'E'.
  ENDTRY.
ENDIF.
ENDMETHOD.


METHOD get_testcases.
TYPES:
    BEGIN OF ty_workpackage_with_case,
      wp   TYPE ty_workpackage,
      case TYPE int2,
    END OF ty_workpackage_with_case .

TYPES: ty_single_cases TYPE STANDARD TABLE OF ty_workpackage_with_case WITH EMPTY KEY.
TYPES: ty_type TYPE STANDARD TABLE OF char2 WITH DEFAULT KEY.


DATA: lt_case_final          TYPE tyt_alv_grid,
      ls_result              TYPE ty_result,
      ""  ls_s_query             TYPE ty_query_keyfigure,
      "  ls_t_query             TYPE ty_query_keyfigure,
     "  single_case            TYPE ty_workpackage_with_case,
      ls_source_value          TYPE ty_data,
      lv_case_type              TYPE char2,
      lv_flag_no_entries    TYPE rs_bool VALUE rs_c_true. "Check flag for no entries

IF me->gs_breakpoints-get_case = rs_c_true.
  BREAK-POINT.
ENDIF.

DATA(lt_s_zvb0t_dqf) = get_type( 'S' ).
DATA(lt_t_zvb0t_dqf) = get_type( 'T' ).
IF lt_t_zvb0t_dqf[] IS INITIAL.
  lt_t_zvb0t_dqf     = get_type( 'C' ).
ENDIF.

DATA(lt_single_cases) = VALUE ty_single_cases( FOR <ls_cases> IN gt_cases ( wp  = <ls_cases>-wp case = <ls_cases>-num ) ).
SORT lt_single_cases ASCENDING BY wp case.
DELETE ADJACENT DUPLICATES FROM lt_single_cases COMPARING case wp.

LOOP AT lt_single_cases ASSIGNING FIELD-SYMBOL(<ls_single_case>).

  "Reset Multiple Hierarchy Option
  gv_multiple_hierarchies = 0.

  set_workpackages( <ls_single_case>-wp ).
  set_case_number( <ls_single_case>-case ).

  "There is a Source / Target to check
  IF lt_s_zvb0t_dqf[] IS NOT INITIAL.

    DATA(lt_source_case_type) = VALUE ty_type( FOR <type> IN lt_s_zvb0t_dqf ( <type>-type ) ).
    SORT lt_source_case_type ASCENDING.
    DELETE ADJACENT DUPLICATES FROM lt_source_case_type COMPARING ALL FIELDS.

    "If there are more than one source case to get the result
    LOOP AT lt_source_case_type ASSIGNING FIELD-SYMBOL(<ls_source_case_type>).
      DATA(ls_source_case_result) = me->build_test_case( <ls_source_case_type> ).
      ls_source_value-result   = ls_source_value-result + ls_source_case_result-result.
      ls_source_value-datarows = ls_source_value-datarows + ls_source_case_result-datarows.
    ENDLOOP.
    lv_flag_no_entries = rs_c_false.
  ENDIF.

  IF lt_t_zvb0t_dqf[] IS NOT INITIAL.
    IF line_exists( me->gt_cases[ num = gv_case wp = gv_workpackage type = 'T' ] ).
      lv_case_type = 'T'.
    ELSE.
      lv_case_type = 'C'.
    ENDIF.
    DATA(ls_target_case_result) = me->build_test_case( lv_case_type ).

    lv_flag_no_entries = rs_c_false.
  ENDIF.

  IF lv_flag_no_entries = rs_c_true.
    RETURN.
  ENDIF.

  ls_result-source_result         = ls_source_value-result.
  ls_result-source_datarows       = ls_source_value-datarows.
  ls_result-target_result         = ls_target_case_result-result.
  ls_result-target_datarows       = ls_target_case_result-datarows.
  DATA(lt_case) = get_result( ls_result ).
  APPEND LINES OF lt_case TO lt_case_final.
  "Delete Variable for other test cases
  CLEAR: ls_source_value, ls_target_case_result.

ENDLOOP.
rt_case = lt_case_final.
ENDMETHOD.


METHOD get_type.
rt_cases = VALUE tyt_zvb0t_dqf( FOR <ls_case> IN gt_cases WHERE ( type(1) = i_type ) ( <ls_case> ) ).
ENDMETHOD.


METHOD run.
**********************************************************************
* Author: T.Meyer, extern, Windhoff Software Services, 03.04.2019
**********************************************************************
*
* Automated Testing of specific testcases which are stored in
* table zvb0t_testing. Dokumentation can be get by the author.
*
**********************************************************************
* Change log
**********************************************************************
* 03.04.19 TM/CR initial version
* 09.04.19 TM Change to Methods
* 10.04.19 TM Add Exceptions
* 28.05.19 TM Change to ALV Grid Output
* 29.05.19 TM Add Query
* 04.06.19 TM Refactoring
* 25.06.19 TM Minor Changes to all Methods.
* 17.09.19 TM Add multiple hierarchies
* 18.09.19 TM Fix some slight bugs
* 25.09.19 TM Change variable names to more meaningful names
*             https://github.com/SAP/styleguides/blob/master/clean-abap/CleanABAP.md#names
* 10.10.19 TM Simplification of code
* 19.11.19 TM Change to new table and add date for time dependency
* 28.11.19 TM Change to more flexibilty with standalone classes
* 02.12.19 TM Add more than one source to check
* 14.02.20 TM Add Variables for Selection
**********************************************************************
*&---------------------------------------------------------------------*
"Guten Morgen ... Oh, und falls wir uns nicht mehr sehen, guten Tag, guten Abend und gute Nacht!
TYPES: ty_recipient TYPE STANDARD TABLE OF ty_mailaddress WITH EMPTY KEY.

SORT me->gt_cases ASCENDING BY num iobjnm type.

IF i_mail = rs_c_true.
  DATA(lt_recipient) = VALUE ty_recipient( FOR <ls_mail> IN i_mailaddresses ( <ls_mail>-low ) ).
  send_mail( EXPORTING i_cases     = get_testcases( )
                       i_recipient = lt_recipient ).
ELSE.
  get_output( get_testcases( ) ).
ENDIF.
ENDMETHOD.


METHOD send_mail.

CONSTANTS:  gc_subject TYPE so_obj_des VALUE 'Status Testcases',
            gc_raw     TYPE char03 VALUE 'RAW'.

DATA: gv_sent_to_all   TYPE os_boolean,
      gv_email         TYPE adr6-smtp_addr,
      gv_text          TYPE bcsy_text,
      gr_send_request  TYPE REF TO cl_bcs,
      gr_bcs_exception TYPE REF TO cx_bcs,
      gr_recipient     TYPE REF TO if_recipient_bcs,
      gr_sender        TYPE REF TO cl_sapuser_bcs,
      gr_document      TYPE REF TO cl_document_bcs,
      lv_mail          TYPE string.

TRY.
  "Create send request
  gr_send_request = cl_bcs=>create_persistent( ).

  "Email FROM...
  gr_sender = cl_sapuser_bcs=>create( sy-uname ).
  "Add sender to send request
  gr_send_request->set_sender( i_sender = gr_sender ).

  "Email TO...
  LOOP AT i_recipient ASSIGNING FIELD-SYMBOL(<ls_recipient>).
    gv_email = <ls_recipient>.
    gr_recipient = cl_cam_address_bcs=>create_internet_address( gv_email ).
    "Add recipient to send request
    gr_send_request->add_recipient( i_recipient = gr_recipient i_express = 'X' ).
  ENDLOOP.

  "Email BODY
  APPEND 'Hallo,'  TO gv_text.
  APPEND 'folgende Testcases sind nicht in Ordnung:' TO gv_text.
  APPEND ' ' TO gv_text.
  APPEND `Testcase ` && `Expected Result ` && `Result ` && TEXT-007 TO gv_text.
  LOOP AT i_cases ASSIGNING FIELD-SYMBOL(<ls_case>).

    IF <ls_case>-status = '@0A@'.
      lv_mail = <ls_case>-testcase && ` ` && <ls_case>-expected && ` ` && <ls_case>-result && ` ` && <ls_case>-s_comment && ` ` && <ls_case>-t_comment.
      APPEND lv_mail TO gv_text.
    ENDIF.

  ENDLOOP.

  gr_document = cl_document_bcs=>create_document(
                  i_type    = gc_raw
                  i_text    = gv_text
                  i_length  = '12'
                  i_subject = gc_subject ).
  "Add document to send request
  gr_send_request->set_document( gr_document ).

  "Send email
  gr_send_request->send(
    EXPORTING
      i_with_error_screen = 'X'
    RECEIVING
      result              = gv_sent_to_all ).
  IF gv_sent_to_all = 'X'.
    WRITE 'Email sent!'.
  ENDIF.

  "Commit to send email
  COMMIT WORK.

"Exception handling
CATCH cx_bcs INTO gr_bcs_exception.
  WRITE:
    'Error!',
    'Error type:',
    gr_bcs_exception->error_type.
ENDTRY.

ENDMETHOD.


METHOD set_breakpoints.
  me->gs_breakpoints = is_breakpoints.
ENDMETHOD.


METHOD set_case_number.
me->gv_case = i_case.
ENDMETHOD.


METHOD set_green_cases.
  me->gv_skip_green_statements = i_green_cases.
ENDMETHOD.


METHOD set_red_cases.
  me->gv_skip_failed_statements = i_red_cases.
ENDMETHOD.


METHOD set_type.
me->gv_type = i_type.
ENDMETHOD.


METHOD set_workpackages.
me->gv_workpackage = i_workpackage.
ENDMETHOD.


METHOD zif_dqf_select~get_conversion_base_char.
SELECT SINGLE convexit,
              outputlen
  FROM rsdchabas
  INTO @r_value
  WHERE objvers  = @rs_c_objvers-active
  AND   chabasnm = @i_infoobject.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
    EXPORTING
      textid = zcx_dqf=>infoobjects_not_exists
      iobjnm = i_infoobject.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~get_conversion_characteristic.
 SELECT SINGLE chabasnm
    FROM rsdcha
    INTO @r_value
    WHERE objvers = @rs_c_objvers-active
    AND   chanm   = @i_infoobject.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
    EXPORTING
      textid  = zcx_dqf=>infoobjects_not_exists
      iobjnm  = i_infoobject.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~get_dataelement.
SELECT SINGLE rollname
  FROM dd04l
  INTO @r_value
  WHERE shlpfield = @i_infoobject.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
    EXPORTING
      textid  = zcx_dqf=>infoobjects_not_exists
      iobjnm  = i_infoobject.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~get_dataelement_hierarchy.
DATA(tabname) = '%WH%' && i_infoobject && '%'.
SELECT SINGLE typename
  FROM dd40l
  INTO @r_value
  WHERE typename  LIKE @tabname.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
    EXPORTING
      textid  = zcx_dqf=>infoobjects_not_exists
      iobjnm  = i_infoobject.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~get_dataelement_keyfigure.
DATA ls_properties TYPE rsd_s_cob_pro.

CALL FUNCTION 'RSD_IOBJ_GET'
  EXPORTING
    i_iobjnm              = i_infoobject
    i_objvers             = rs_c_objvers-active
  IMPORTING
    e_s_cob_pro           = ls_properties
  EXCEPTIONS
    iobj_not_found        = 1
    illegal_input         = 2
    bct_comp_invalid      = 3
    OTHERS                = 4.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
    EXPORTING
      textid  = zcx_dqf=>infoobjects_not_exists
      iobjnm  = i_infoobject.
ELSE.
  r_value = ls_properties-dtelnm.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~get_dataelement_masterdata.
DATA(lv_tabname) = '%P%' && i_infoobject && '%'.
SELECT SINGLE tabname
  FROM dd02l
  INTO @r_value
  WHERE tabclass = 'TRANSP'
    AND tabname LIKE @lv_tabname.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
    EXPORTING
      textid  = zcx_dqf=>infoobjects_not_exists
      iobjnm  = i_infoobject.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~get_datatype_characteristic.
SELECT SINGLE datatp
  FROM rsdchabas
  INTO @r_value
  WHERE objvers  = @rs_c_objvers-active
    AND chabasnm = @i_infoobject.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
      EXPORTING
        textid   = zcx_dqf=>infoobjects_not_exists
        iobjnm   = i_infoobject.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~get_datatype_keyfigure.
SELECT SINGLE datatp
  FROM rsdkyf
  INTO @r_value
  WHERE objvers = @rs_c_objvers-active
    AND kyfnm   = @i_keyfigure.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
      EXPORTING
        textid   = zcx_dqf=>infoobjects_not_exists
        iobjnm   = i_keyfigure.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~get_display_attributes.
SELECT chabasnm,
       attrinm,
       attritp
  FROM rsdbchatr
  INTO TABLE @rt_value
  WHERE objvers = @rs_c_objvers-active AND
        attritp = 'DIS' AND
        attrinm = @i_display_attribute.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
    EXPORTING
      textid   = zcx_dqf=>infoobjects_not_exists
      iobjnm   = i_display_attribute.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~get_infoobjects.
SELECT iobjnm,
       fieldnm
  FROM rsdiobj
  INTO TABLE @rt_value
  WHERE iobjnm  = @i_infoobject AND
        objvers = @rs_c_objvers-active.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
    EXPORTING
      textid   = zcx_dqf=>infoobjects_not_exists
      iobjnm   = i_infoobject.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~get_navigation_attributes.
SELECT chanm,
       atrnavnm
  FROM rsdatrnav
  INTO TABLE @gt_cases
  WHERE atrnavnm = @i_infoobject AND
        objvers  = @rs_c_objvers-active.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
    EXPORTING
      textid   = zcx_dqf=>infoobjects_not_exists
      iobjnm   = i_infoobject.
ENDIF.
ENDMETHOD.


METHOD zif_dqf_select~check_if_table_exists.
SELECT SINGLE @abap_true
  FROM dd02l
  INTO @DATA(exists)
 WHERE tabname = @i_table.

IF sy-subrc NE 0.
  RAISE EXCEPTION TYPE zcx_dqf
      EXPORTING
        textid   = zcx_dqf=>table_not_found
        table    = i_table.
ENDIF.
ENDMETHOD.


METHOD _get_cases.

SELECT *
  FROM ztm_dqf_cases
  INTO TABLE @r_cases
  WHERE wp  IN @i_workpackage AND
        num IN @i_case_number.

ENDMETHOD.
ENDCLASS.
