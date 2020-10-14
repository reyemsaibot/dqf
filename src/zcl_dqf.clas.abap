"#autoformat
"! Automated Testing of specific Testcases
"! Testcases must be specified in the table
"! zvb0t_testing. How you can do this check the readme on github.
CLASS zcl_dqf DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES ty_workpackage TYPE ztm_dqf_cases-wp.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Range of work package</p>
      ty_r_workpackages  TYPE RANGE OF ty_workpackage,
      "! <p class="shorttext synchronized" lang="en">Test case number</p>
      ty_r_cases         TYPE RANGE OF int2,
      "! <p class="shorttext synchronized" lang="en">Mail address</p>
      ty_mailaddress     TYPE c LENGTH 90,
      "! <p class="shorttext synchronized" lang="en">Table of mail addresses</p>
      ty_r_mailaddresses TYPE RANGE OF ty_mailaddress,
      "! <p class="shorttext synchronized" lang="en">Table of test cases</p>
      ty_t_dqf           TYPE STANDARD TABLE OF ztm_dqf_cases WITH EMPTY KEY,
      "! <p class="shorttext synchronized" lang="en">Result value</p>
      ty_result_value    TYPE p LENGTH 16 DECIMALS 2,
      "! <p class="shorttext synchronized" lang="en">Output for data rows</p>
      ty_datarows        TYPE p LENGTH 16 DECIMALS 0.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Structure of possible break points which can set by the user</p>
      BEGIN OF ty_breakpoints,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_data</p>
        wherecondition TYPE rs_bool,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_hierarchy_elements</p>
        hierarchy      TYPE rs_bool,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_condition</p>
        condition      TYPE rs_bool,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_result</p>
        result         TYPE rs_bool,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_singleentries</p>
        entries        TYPE rs_bool,
        "! <p class="shorttext synchronized" lang="en">Breakpoint in method get_testcases</p>
        get_case       TYPE rs_bool,
      END OF ty_breakpoints.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Structure of output data</p>
      BEGIN OF ty_data,
        "! <p class="shorttext synchronized" lang="en">Result value</p>
        result   TYPE ty_result_value,
        "! <p class="shorttext synchronized" lang="en">Number of data rows</p>
        datarows TYPE ty_datarows,
      END OF ty_data.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Structure of analyze data output</p>
      BEGIN OF ty_analyze_result,
        "! <p class="shorttext synchronized" lang="en">Date of the run</p>
        date        TYPE sy-datum,
        "! <p class="shorttext synchronized" lang="en">Time of the run</p>
        time        TYPE sy-uzeit,
        status      TYPE c LENGTH 4,
        workpackage TYPE ty_workpackage,
        testcase    TYPE int2,
        expected    TYPE string,
        result      TYPE string,
        s_comment   TYPE ztm_dqf_cases-comments,
        s_datarows  TYPE p LENGTH 16 DECIMALS 0,
        t_comment   TYPE ztm_dqf_cases-comments,
        t_datarows  TYPE p LENGTH 16 DECIMALS 0,
        quote       TYPE p LENGTH 16 DECIMALS 2,
      END OF ty_analyze_result.

    TYPES: ty_t_analyze_result TYPE STANDARD TABLE OF ty_analyze_result WITH EMPTY KEY.

    CLASS-METHODS analyze_results
      IMPORTING
        it_cases TYPE ty_t_analyze_result.


    "! <p class="shorttext synchronized" lang="en">Run the data quality framework</p>
    "!
    "! @parameter iv_mail           | <p class="shorttext synchronized" lang="en">Send Mail? Yes or No</p>
    "! @parameter ir_mailaddresses  | <p class="shorttext synchronized" lang="en">Send Mail to who</p>
    METHODS run
      IMPORTING
        !iv_mail          TYPE rs_bool OPTIONAL
        !ir_mailaddresses TYPE ty_r_mailaddresses OPTIONAL.

    "! <p class="shorttext synchronized" lang="en">Constructor</p>
    "!
    "! @parameter ir_workpackage  | <p class="shorttext synchronized" lang="en">Workpackage</p>
    "! @parameter ir_case         | <p class="shorttext synchronized" lang="en">Test case</p>
    "! @raising cx_no_data_found  | <p class="shorttext synchronized" lang="en">No data found for selection</p>
    METHODS constructor
      IMPORTING
        !ir_workpackage TYPE ty_r_workpackages OPTIONAL
        !ir_case        TYPE ty_r_cases OPTIONAL
      RAISING
        cx_no_data_found.

    "! <p class="shorttext synchronized" lang="en">Skip red cases</p>
    "!
    "! @parameter iv_red_cases | <p class="shorttext synchronized" lang="en">Yes or no?</p>
    METHODS set_red_cases
      IMPORTING
        !iv_red_cases TYPE rs_bool.

    "! <p class="shorttext synchronized" lang="en">Hide green cases</p>
    "!
    "! @parameter iv_green_cases | <p class="shorttext synchronized" lang="en">Yes or no?</p>
    METHODS set_green_cases
      IMPORTING
        !iv_green_cases TYPE rs_bool.

    "! <p class="shorttext synchronized" lang="en">Set definied breakpoints</p>
    "!
    "! @parameter is_breakpoints | <p class="shorttext synchronized" lang="en">List of breakpoints</p>
    METHODS set_breakpoints
      IMPORTING
        !is_breakpoints TYPE ty_breakpoints.

    "! <p class="shorttext synchronized" lang="en">Save result to database</p>
    "!
    "! @parameter iv_save_result | <p class="shorttext synchronized" lang="en">Save result?</p>
    METHODS set_save_result
      IMPORTING
        !iv_save_result TYPE rs_bool.


  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Output for ALV Grid</p>
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
      END OF ty_alv_grid.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Table of result test cases</p>
      ty_t_alv_grid TYPE STANDARD TABLE OF ty_alv_grid WITH EMPTY KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Table of string</p>
      ty_t_string TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Table of where condition</p>
      ty_t_wherecondition TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Type for check data element</p>
      BEGIN OF ty_dataelement,
        infoobject TYPE rsdiobjnm,
        sign       TYPE c LENGTH 1,
      END OF ty_dataelement.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Range for an InfoObject</p>
      BEGIN OF ty_range_infoobject,
        infoobject TYPE rsiobjnm,
        option     TYPE rsoption,
        sign       TYPE rssign,
        low        TYPE rslow,
        high       TYPE rshigh,
      END OF ty_range_infoobject.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Type for flat a hierarchy</p>
      BEGIN OF ty_hierarchy,
        "! <p class="shorttext synchronized" lang="en">Hierarchy node which must be flatten</p>
        hierarchy_node TYPE rshigh,
        "! <p class="shorttext synchronized" lang="en">Technical name of the hierarchy</p>
        hierarchy      TYPE rshienm,
        "! <p class="shorttext synchronized" lang="en">Technical name of the InfoObject, the hierarchy is based on</p>
        infoobject     TYPE rsiobjnm,
        "! <p class="shorttext synchronized" lang="en">Valid From</p>
        validfrom      TYPE /bi0/oidate,
        "! <p class="shorttext synchronized" lang="en">Valid To</p>
        validto        TYPE /bi0/oidate,
      END OF ty_hierarchy.

    TYPES: "! <p class="shorttext synchronized" lang="en">Type for selection condition</p>
      BEGIN OF ty_conditions,
        lines          TYPE int2,
        infoobject     TYPE rsiobjnm,
        range          TYPE rsrange,
        wherecondition TYPE string,
      END OF ty_conditions.

    TYPES:  "! <p class="shorttext synchronized" lang="en">Result Structure</p>
      BEGIN OF ty_result,
        source_result   TYPE ty_result_value,
        source_datarows TYPE p LENGTH 16 DECIMALS 0,
        target_result   TYPE ty_result_value,
        target_datarows TYPE p LENGTH 16 DECIMALS 0,
      END OF ty_result.

    TYPES: "! <p class="shorttext synchronized" lang="en">Structure of Navigation Attribute</p>
      BEGIN OF ty_nav_attribute,
        chanm    TYPE rschanm,
        atrnavnm TYPE rsatrnavnm,
      END OF ty_nav_attribute.

    TYPES: "! <p class="shorttext synchronized" lang="en">Table of Navigation Attributes</p>
      ty_t_navigation_attributes TYPE STANDARD TABLE OF ty_nav_attribute WITH EMPTY KEY.

    TYPES: "! <p class="shorttext synchronized" lang="en">Structure of Display Attribute</p>
      BEGIN OF ty_display_attribute,
        chabasnm TYPE rschabasnm,
        attrinm  TYPE rsattrinm,
        attritp  TYPE rsattritp,
      END OF ty_display_attribute.

    TYPES: "! <p class="shorttext synchronized" lang="en">Table of Display Attributes</p>
      ty_t_display_attributes TYPE STANDARD TABLE OF ty_display_attribute WITH EMPTY KEY.

    TYPES: "! <p class="shorttext synchronized" lang="en">Structure of InfoObject and Fieldname</p>
      BEGIN OF ty_infoobject_with_field,
        iobjnm  TYPE rsdiobjnm,
        fieldnm TYPE rsdiobjnm,
      END OF ty_infoobject_with_field.

    TYPES: "! <p class="shorttext synchronized" lang="en">Table of InfoObjects with Fieldname</p>
      ty_t_infoobject_with_field TYPE  STANDARD TABLE OF ty_infoobject_with_field WITH EMPTY KEY.

    TYPES: "! <p class="shorttext synchronized" lang="en">Conversion Exit with output length</p>
      BEGIN OF ty_conv_char,
        convexit  TYPE convexit,
        outputlen TYPE outputlen,
      END OF ty_conv_char.

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Not Equal to</p>
      gc_ne        TYPE c LENGTH 2 VALUE 'NE' ##NO_TEXT,
      "! <p class="shorttext synchronized" lang="en">Equal to</p>
      gc_eq        TYPE c LENGTH 2 VALUE 'EQ' ##NO_TEXT,
      "! <p class="shorttext synchronized" lang="en">Type Hierarchy</p>
      gc_hierarchy TYPE c  LENGTH 2 VALUE 'HI' ##NO_TEXT,
      "! <p class="shorttext synchronized" lang="en">Greater Than</p>
      gc_gt        TYPE c  LENGTH 2 VALUE 'GT' ##NO_TEXT,
      "! <p class="shorttext synchronized" lang="en">Lower Than</p>
      gc_lt        TYPE c  LENGTH 2 VALUE 'LT' ##NO_TEXT.
    CONSTANTS:
      gc_le TYPE c  LENGTH 2 VALUE 'LE' ##NO_TEXT.
    CONSTANTS:
      gc_ge TYPE c  LENGTH 2 VALUE 'GE' ##NO_TEXT.
    CONSTANTS:
      gc_bt TYPE c  LENGTH 2 VALUE 'BT' ##NO_TEXT.
    CONSTANTS:
      gc_nb TYPE c  LENGTH 2 VALUE 'NB' ##NO_TEXT.

    "! <p class="shorttext synchronized" lang="en">Bracket exists Yes or No</p>
    CLASS-DATA gv_bracket TYPE rs_bool.
    "! <p class="shorttext synchronized" lang="en">Count Entries</p>
    CLASS-DATA gv_count TYPE int2 .
    "! <p class="shorttext synchronized" lang="en">Does multiple hierarchies exist for one case</p>
    CLASS-DATA gv_multiple_hierarchies TYPE int2.
    "! <p class="shorttext synchronized" lang="en">Are there multiple entries for an InfoObject</p>
    CLASS-DATA gv_multiple_entries TYPE int2 .
    "! <p class="shorttext synchronized" lang="en">Is there more than one hierarchy for an InfoObject</p>
    CLASS-DATA gv_number_of_hierarchies TYPE int2.
    "! <p class="shorttext synchronized" lang="en">Does Entries exist for an InfoObject besides a hierarchy</p>
    CLASS-DATA gv_entry_beside_hierarchy TYPE rs_bool.
    "! <p class="shorttext synchronized" lang="en">Hide Green Entries</p>
    DATA gv_skip_green_statements TYPE rs_bool VALUE rs_c_false ##NO_TEXT.
    "! <p class="shorttext synchronized" lang="en">Skip Failed Cases</p>
    DATA gv_skip_failed_statements TYPE rs_bool VALUE rs_c_false ##NO_TEXT.
    "! <p class="shorttext synchronized" lang="en">Save test result</p>
    DATA gv_save_result  TYPE rs_bool VALUE rs_c_false ##NO_TEXT.
    "! <p class="shorttext synchronized" lang="en">Is there any breakpoint set</p>
    DATA gs_breakpoints TYPE ty_breakpoints.
    "! <p class="shorttext synchronized" lang="en">Workpackage</p>
    DATA gv_workpackage  TYPE ty_workpackage.
    "! <p class="shorttext synchronized" lang="en">Test case</p>
    DATA gv_case         TYPE int2.
    "! <p class="shorttext synchronized" lang="en">Structure of source parameter</p>
    DATA gs_parameters_s TYPE zcl_dqf_read_table=>ty_parameter.
    "! <p class="shorttext synchronized" lang="en">Structure of target parameter</p>
    DATA gs_parameters_t TYPE zcl_dqf_read_table=>ty_parameter.
    "! <p class="shorttext synchronized" lang="en">Test case type</p>
    DATA gv_type         TYPE char2.

    "TODO [2020-08-13, MEYER]:
    DATA gt_query_parameter TYPE rrxw3tquery.
    DATA go_dqf_query       TYPE REF TO zcl_dqf_query.

    "! <p class="shorttext synchronized" lang="en">Table of test cases</p>
    DATA gt_cases TYPE ty_t_dqf.

    "! <p class="shorttext synchronized" lang="en">Determine the defined conversions of an InfoObject</p>
    "!
    "! @parameter iv_valu       | <p class="shorttext synchronized" lang="en">Import value which may must be converted</p>
    "! @parameter iv_infoobject | <p class="shorttext synchronized" lang="en">InfoObject to lookup the conversion routine</p>
    "! @parameter rv_converted_value | <p class="shorttext synchronized" lang="en">Return the value after conversion routine</p>
    METHODS get_conversion
      IMPORTING
        !iv_infoobject            TYPE rsiobjnm
        !iv_value                 TYPE c
      RETURNING
        VALUE(rv_converted_value) TYPE string.

    "! <p class="shorttext synchronized" lang="en">Check if InfoObject exists and return its field name</p>
    "!
    "! @parameter iv_infoobject | <p class="shorttext synchronized" lang="en">InfoObject which should be checked</p>
    "! @parameter rv_fieldname  | <p class="shorttext synchronized" lang="en">Returning field name of an InfoObject</p>
    METHODS check_iobj
      IMPORTING
        !iv_infoobject      TYPE rsdiobjnm
      RETURNING
        VALUE(rv_fieldname) TYPE rsdiobjfieldnm.

    "! <p class="shorttext synchronized" lang="en">Get the data from the database</p>
    "!
    "! @parameter it_whereconditions | <p class="shorttext synchronized" lang="en">Where condition for the select statement</p>
    "! @parameter rv_result          | <p class="shorttext synchronized" lang="en">Value and datarows for your selection</p>
    "!
    "! @raising ZCX_DQF | <p class="shorttext synchronized" lang="en">Raise an exception of ZCX_DQF</p>
    METHODS get_data
      IMPORTING
        !it_whereconditions TYPE ty_t_wherecondition
      RETURNING
        VALUE(rs_result)    TYPE ty_data
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Get Type for test case</p>
    "!
    "! @parameter iv_type  | <p class="shorttext synchronized" lang="en">Type Source/Target/Check</p>
    "! @parameter rt_cases | <p class="shorttext synchronized" lang="en">Return table of test case with specific type</p>
    METHODS get_type
      IMPORTING
        !iv_type        TYPE char2
      RETURNING
        VALUE(rt_cases) TYPE ty_t_dqf.

    "! <p class="shorttext synchronized" lang="en">Get Navigation Attributes</p>
    "!
    "! @parameter is_dqf_case | <p class="shorttext synchronized" lang="en">Test case structure</p>
    "! @parameter r_values     | <p class="shorttext synchronized" lang="en">Return table with values for the navigation attribute</p>
    METHODS get_navigation_attribute
      IMPORTING
        !is_dqf_case                   TYPE ztm_dqf_cases
      RETURNING
        VALUE(rt_navigation_attribute) TYPE ty_t_string.

    "! <p class="shorttext synchronized" lang="en">Create dynamic where condition</p>
    "!
    "! @parameter rt_whereconditions   | <p class="shorttext synchronized" lang="en">Return of the where condition</p>
    METHODS create_wherecondition
      RETURNING
        VALUE(rt_whereconditions) TYPE ty_t_wherecondition.


    "! <p class="shorttext synchronized" lang="en">Determine value of one test case row</p>
    "!
    "! @parameter is_case | <p class="shorttext synchronized" lang="en">Test case structure</p>
    "! @parameter es_case | <p class="shorttext synchronized" lang="en">Test case structure</p>
    METHODS determine_values
      IMPORTING
        is_case TYPE ztm_dqf_cases
      EXPORTING
        es_case TYPE ztm_dqf_cases.

    "! <p class="shorttext synchronized" lang="en">Determine variables values</p>
    "!
    "! @parameter iv_type | <p class="shorttext synchronized" lang="en">Field (low or high)</p>
    "! @parameter is_case | <p class="shorttext synchronized" lang="en">Test case</p>
    "! @parameter r_value | <p class="shorttext synchronized" lang="en">Value of the variable</p>
    METHODS determine_variables
      IMPORTING
        iv_type        TYPE string
        is_case        TYPE ztm_dqf_cases
      RETURNING
        VALUE(r_value) TYPE string.


    "! <p class="shorttext synchronized" lang="en">Save results of test cases to database</p>
    "!
    "! @parameter it_cases | <p class="shorttext synchronized" lang="en">List of checked test cases</p>
    METHODS save_results
      IMPORTING
        it_cases TYPE ty_t_alv_grid.

    "! <p class="shorttext synchronized" lang="en">Get test cases</p>
    "!
    "! @parameter rt_case | <p class="shorttext synchronized" lang="en">Table of checked test cases</p>
    METHODS get_testcases
      RETURNING
        VALUE(rt_case) TYPE ty_t_alv_grid.

    "! <p class="shorttext synchronized" lang="en">Get parameter</p>
    "!
    "! @parameter iv_type      | <p class="shorttext synchronized" lang="en">Type of test case</p>
    "! @parameter rs_parameter | <p class="shorttext synchronized" lang="en">Parameter for test case</p>
    METHODS get_parameters
      IMPORTING
        !iv_type            TYPE char2
      RETURNING
        VALUE(rs_parameter) TYPE zcl_dqf_read_table=>ty_parameter.

    "! <p class="shorttext synchronized" lang="en">Get result</p>
    "!
    "! @parameter is_result | <p class="shorttext synchronized" lang="en">Information about the test case</p>
    "! @parameter rt_cases  | <p class="shorttext synchronized" lang="en">Table of checked cases</p>
    METHODS get_result
      IMPORTING
        !is_result      TYPE ty_result
      RETURNING
        VALUE(rt_cases) TYPE ty_t_alv_grid.

    "! <p class="shorttext synchronized" lang="en">Get single entries</p>
    "!
    "! @parameter it_values         | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter iv_condition      | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter rt_wherecondition | <p class="shorttext synchronized" lang="en">Where condition for select statement</p>
    METHODS get_singleentries
      IMPORTING
        !it_values               TYPE ty_t_string OPTIONAL
        !is_condition            TYPE ty_conditions
      RETURNING
        VALUE(rt_wherecondition) TYPE ty_t_wherecondition.

    "! <p class="shorttext synchronized" lang="en">Send mail</p>
    "!
    "! @parameter it_cases     | <p class="shorttext synchronized" lang="en">Table of test cases</p>
    "! @parameter it_recipient | <p class="shorttext synchronized" lang="en">List of recipients</p>
    CLASS-METHODS send_mail
      IMPORTING
        !it_cases     TYPE ty_t_alv_grid
        !it_recipient TYPE STANDARD TABLE.

    "! <p class="shorttext synchronized" lang="en">Get Condition based on Sign and Option</p>
    "!
    "! @parameter is_condition     | <p class="shorttext synchronized" lang="en">Condition for Selection</p>
    "! @parameter r_wherecondition | <p class="shorttext synchronized" lang="en">Return where condition with sign, option and value</p>
    "! @raising   zcx_dqf          | <p class="shorttext synchronized" lang="en">Exception if sign or option is not found</p>
    METHODS get_condition
      IMPORTING
        !is_condition           TYPE ty_conditions
      RETURNING
        VALUE(r_wherecondition) TYPE string
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Get single members of a hierarchy</p>
    "!
    "! @parameter is_hierarchy          | <p class="shorttext synchronized" lang="en">Structure with hierarchy, node and InfoObject</p>
    "! @parameter rt_flatlist           | <p class="shorttext synchronized" lang="en">List of hierarchy elements</p>
    "! @raising   cx_rsr_hier_not_found | <p class="shorttext synchronized" lang="en">Hierarchy not found</p>
    METHODS get_hierarchy_elements
      IMPORTING
        !is_hierarchy      TYPE ty_hierarchy
      RETURNING
        VALUE(rt_flatlist) TYPE ty_t_string
      RAISING
        cx_rsr_hier_not_found.

    "! <p class="shorttext synchronized" lang="en">Get Output on Screen as ALV Grid</p>
    "!
    "! @parameter i_cases | <p class="shorttext synchronized" lang="en">Table of checked cases</p>
    METHODS get_output
      IMPORTING
        !it_cases TYPE ty_t_alv_grid.

    "! <p class="shorttext synchronized" lang="en">Determine multiple entries for one InfoObject</p>
    "!
    "! @parameter iv_row    | <p class="shorttext synchronized" lang="en">Line of test case</p>
    "! @parameter iv_option | <p class="shorttext synchronized" lang="en">Option if hierarchy or normal InfoObject</p>
    "! @parameter r_value  | <p class="shorttext synchronized" lang="en">Return number of entries</p>
    METHODS determine_multiple_entries
      IMPORTING
        !is_row                    TYPE ztm_dqf_cases
        !iv_option                 TYPE char2 OPTIONAL
      RETURNING
        VALUE(rv_number_of_values) TYPE int2.

    "! <p class="shorttext synchronized" lang="en">Create a test case on the given parameter</p>
    "!
    "! @parameter iv_type  | <p class="shorttext synchronized" lang="en">Type of Test case either Change or Source/Target</p>
    "! @parameter r_value | <p class="shorttext synchronized" lang="en">Return result and datarows</p>
    METHODS build_test_case
      IMPORTING
        iv_type        TYPE char2
      RETURNING
        VALUE(r_value) TYPE ty_data.

    "! <p class="shorttext synchronized" lang="en">Set Workpackage</p>
    "!
    "! @parameter iv_workpackage | <p class="shorttext synchronized" lang="en">Workpackage</p>
    METHODS set_workpackages
      IMPORTING
        iv_workpackage TYPE ty_workpackage.

    "! <p class="shorttext synchronized" lang="en">Set Case number</p>
    "!
    "! @parameter iv_case | <p class="shorttext synchronized" lang="en">Case number</p>
    METHODS set_case_number
      IMPORTING
        iv_case TYPE int2.

    "! <p class="shorttext synchronized" lang="en">Set Case Type</p>
    "!
    "! @parameter iv_type | <p class="shorttext synchronized" lang="en">Case type S/T/C</p>
    METHODS set_type
      IMPORTING
        iv_type TYPE char2.

    "! <p class="shorttext synchronized" lang="en">Check if InfoObject is a navigation attribute</p>
    "!
    "! @parameter iv_infoobject            | <p class="shorttext synchronized" lang="en">InfoObject</p>
    "! @parameter rt_navigation_attributes | <p class="shorttext synchronized" lang="en">Return table of navigation attributes</p>
    "! @raising zcx_dqf                    | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
    METHODS _check_if_navigation_attribute
      IMPORTING
        !iv_infoobject                  TYPE rsdiobjnm
      RETURNING
        VALUE(rt_navigation_attributes) TYPE ty_t_navigation_attributes
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Check if InfoObject is display attribute</p>
    "!
    "! @parameter iv_infoobject         | <p class="shorttext synchronized" lang="en">InfoObject</p>
    "! @parameter rt_display_attributes | <p class="shorttext synchronized" lang="en">Return table of display attributes</p>
    "! @raising ZCX_DQF                 | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
    METHODS _check_if_display_attribute
      IMPORTING
        !iv_infoobject               TYPE rsiobjnm
      RETURNING
        VALUE(rt_display_attributes) TYPE ty_t_display_attributes
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Get Fieldname for an InfoObject</p>
    "!
    "! @parameter I_INFOOBJECT | <p class="shorttext synchronized" lang="en">Infoobject</p>
    "! @parameter rt_infoobject_with_fieldname     | <p class="shorttext synchronized" lang="en">Return table of Infoobjects and Fieldnames</p>
    "! @raising ZCX_DQF        | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
    METHODS _get_fieldname_of_infoobject
      IMPORTING
        !iv_infoobject                      TYPE rsiobjnm
      RETURNING
        VALUE(rt_infoobject_with_fieldname) TYPE ty_t_infoobject_with_field
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter iv_infoobject | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter rv_value | <p class="shorttext synchronized" lang="en"></p>
    "! @raising zcx_dqf | <p class="shorttext synchronized" lang="en"></p>
    METHODS _get_conversion_base_char
      IMPORTING
        !iv_infoobject  TYPE rsiobjnm
      RETURNING
        VALUE(rv_value) TYPE ty_conv_char
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter iv_infoobject | <p class="shorttext synchronized" lang="en"></p>
    "! @parameter rv_value | <p class="shorttext synchronized" lang="en"></p>
    "! @raising zcx_dqf | <p class="shorttext synchronized" lang="en"></p>
    METHODS _get_conversion_characteristic
      IMPORTING
        !iv_infoobject  TYPE rsiobjnm
      RETURNING
        VALUE(rv_value) TYPE rschabasnm
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Get data element for infoobject master data table</p>
    "!
    "! @parameter iv_infoobject | <p class="shorttext synchronized" lang="en">Infoobject</p>
    "! @parameter rv_value      | <p class="shorttext synchronized" lang="en">Return data element of infoobject</p>
    "! @raising zcx_dqf         | <p class="shorttext synchronized" lang="en">Raise Exception if infoobject is not found</p>
    METHODS _get_dataelement_masterdata
      IMPORTING
        !iv_infoobject  TYPE rsiobjnm
      RETURNING
        VALUE(rv_value) TYPE rschabasnm
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Get Dataelement for Infoobject</p>
    "!
    "! @parameter iv_INFOOBJECT | <p class="shorttext synchronized" lang="en">InfoObject</p>
    "! @parameter rv_value      | <p class="shorttext synchronized" lang="en">Return Dataelement of InfoObject</p>
    "! @raising ZCX_DQF         | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
    METHODS _get_dataelement
      IMPORTING
        !iv_infoobject  TYPE rsiobjnm
      RETURNING
        VALUE(rv_value) TYPE rschabasnm
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Get Dataelement for Keyfigure</p>
    "!
    "! @parameter iv_infoobject | <p class="shorttext synchronized" lang="en">InfoOBject</p>
    "! @parameter rv_value      | <p class="shorttext synchronized" lang="en">Return Dataelement of KEyfigure</p>
    "! @raising zcx_dqf         | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
    METHODS _get_dataelement_keyfigure
      IMPORTING
        !iv_infoobject  TYPE rsiobjnm
      RETURNING
        VALUE(rv_value) TYPE rschabasnm
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Get Datatype for Keyfigure</p>
    "!
    "! @parameter iv_keyfigure | <p class="shorttext synchronized" lang="en">Keyfigure</p>
    "! @parameter rv_value     | <p class="shorttext synchronized" lang="en">Return Datatype of Keyfigure</p>
    "! @raising zcx_dqf        | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
    METHODS _get_datatype_keyfigure
      IMPORTING
        !iv_keyfigure   TYPE rskyfnm
      RETURNING
        VALUE(rv_value) TYPE datatype_d
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Get Datatype for Characteristic</p>
    "!
    "! @parameter iv_infoobject | <p class="shorttext synchronized" lang="en">Infoobject</p>
    "! @parameter rv_value      | <p class="shorttext synchronized" lang="en">Return Datatype of Characteristic</p>
    "! @raising zcx_dqf        | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
    METHODS _get_datatype_characteristic
      IMPORTING
        !iv_infoobject  TYPE rsiobjnm
      RETURNING
        VALUE(rv_value) TYPE datatype_d
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Check if Table exists</p>
    "!
    "! @parameter iv_table | <p class="shorttext synchronized" lang="en">Table</p>
    "! @raising zcx_dqf   | <p class="shorttext synchronized" lang="en">Raise Exception if table not exists</p>
    METHODS _check_if_table_exists
      IMPORTING
        !iv_table TYPE string
      RAISING
        zcx_dqf.

    "! <p class="shorttext synchronized" lang="en">Get Hierarchy Dataelement</p>
    "!
    "! @parameter iv_infoobject | <p class="shorttext synchronized" lang="en">InfoObject</p>
    "! @parameter rv_value      | <p class="shorttext synchronized" lang="en">Return hierarchy data element</p>
    "! @raising zcx_dqf        | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
    METHODS _get_dataelement_hierarchy
      IMPORTING
        !iv_infoobject  TYPE rsiobjnm
      RETURNING
        VALUE(rv_value) TYPE rschabasnm
      RAISING
        zcx_dqf .

    "! <p class="shorttext synchronized" lang="en">Load DQF Testcases</p>
    "!
    "! @parameter ir_workpackage | <p class="shorttext synchronized" lang="en">Workpackage</p>
    "! @parameter ir_case_number | <p class="shorttext synchronized" lang="en">DQF test case</p>
    "! @parameter rt_cases       | <p class="shorttext synchronized" lang="en">Table of DQF test cases</p>
    METHODS _load_dqf_testcases
      IMPORTING
        !ir_workpackage TYPE ty_r_workpackages
        !ir_case_number TYPE ty_r_cases
      RETURNING
        VALUE(rt_cases) TYPE ty_t_dqf.


ENDCLASS.



CLASS ZCL_DQF IMPLEMENTATION.


  METHOD analyze_results.
* +--------------------------------------------------------------------------------------+
* | Analyze previous runs of your test cases
* +--------------------------------------------------------------------------------------+
* | [--->] it_cases                       TYPE        ty_t_analyze_result
* +--------------------------------------------------------------------------------------+

    DATA: lt_fieldcat TYPE slis_t_fieldcat_alv.
    DATA: ls_fieldcat TYPE slis_fieldcat_alv.
    DATA: lv_layout   TYPE slis_layout_alv.

    DATA(lt_case) = it_cases.

    "Optimize ALV Grid Output
    lv_layout-colwidth_optimize  = 'X'.

    "Create field catalog
    ls_fieldcat-fieldname = 'DATE'.
    ls_fieldcat-seltext_m = 'Date'.
    APPEND ls_fieldcat TO lt_fieldcat.
    CLEAR: ls_fieldcat.

    ls_fieldcat-fieldname = 'TIME'.
    ls_fieldcat-seltext_m = 'Time'.
    APPEND ls_fieldcat TO lt_fieldcat.
    CLEAR: ls_fieldcat.

    ls_fieldcat-fieldname = 'STATUS'.
    ls_fieldcat-seltext_m = 'Status'.
    APPEND ls_fieldcat TO lt_fieldcat.
    CLEAR: ls_fieldcat.

    ls_fieldcat-fieldname = 'WORKPACKAGE'.
    ls_fieldcat-seltext_m = 'Workpackage'.
    APPEND ls_fieldcat TO lt_fieldcat.
    CLEAR: ls_fieldcat.

    ls_fieldcat-fieldname = 'TESTCASE'.
    ls_fieldcat-seltext_m = 'Testcase'.
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


  METHOD build_test_case.

    DATA: ls_parameter TYPE zcl_dqf_read_table=>ty_parameter.

    IF line_exists( me->gt_cases[ num = gv_case wp = gv_workpackage type = iv_type ] ).
      set_type( iv_type ).
      IF iv_type(1) = 'S'.
        gs_parameters_s = get_parameters( iv_type ).
        ls_parameter = gs_parameters_s.
      ELSE.
        gs_parameters_t = get_parameters( iv_type ).
        ls_parameter = gs_parameters_t.
      ENDIF.
      TRY.
          IF ls_parameter-query = ''. "Normal Testcase
            r_value = get_data( create_wherecondition( ) ).
          ELSEIF ls_parameter-query <> ''. "Query Testcase
            create_wherecondition( ). "TODO [2020-08-26, MEYER]:
            r_value = go_dqf_query->get_data( gt_query_parameter  ).
          ENDIF.
        CATCH zcx_dqf INTO DATA(cx_dqf).
          IF me->gv_skip_failed_statements = rs_c_true.
            RETURN. "Skip this record
          ENDIF.
          MESSAGE cx_dqf->get_text( ) TYPE 'E'.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD check_iobj.
* +--------------------------------------------------------------------------------------+
* | Check if InfoObject exists and return its field name
* +--------------------------------------------------------------------------------------+
* | [--->] iv_infoobject                  TYPE        rsiobjnm
* | [<---] rv_fieldname                   TYPE        rsdiobjfieldnm
* +--------------------------------------------------------------------------------------+

    DATA: lv_infoobject        TYPE rsiobjnm.
    DATA: lv_display_attribute TYPE rsiobjnm.

    "Check for navigation attribute
    IF iv_infoobject CS '__'.
      TRY.
          DATA(lt_navigation_infoobjects) = _check_if_navigation_attribute( iv_infoobject ).
          TRY.
              lv_infoobject = lt_navigation_infoobjects[ atrnavnm = iv_infoobject ]-chanm.
            CATCH cx_sy_itab_line_not_found INTO DATA(lcx_table).
              MESSAGE lcx_table->get_text( ) TYPE 'E'.
          ENDTRY.
        CATCH zcx_dqf.
          lv_infoobject = iv_infoobject.
          DATA(lv_infoobject_length) = sy-fdpos.

          CALL FUNCTION 'STRING_SPLIT_AT_POSITION'
            EXPORTING
              string  = lv_infoobject
              "Offset for __
              pos     = lv_infoobject_length + 2
            IMPORTING
              string1 = lv_infoobject
              string2 = lv_display_attribute.

          lv_infoobject = lv_infoobject(lv_infoobject_length).

          TRY.
              DATA(lt_display_infoobjects) = _check_if_display_attribute( lv_display_attribute ).
            CATCH zcx_dqf INTO DATA(lcx_infoobject).
              MESSAGE lcx_infoobject->get_text( ) TYPE 'E'.
          ENDTRY.
      ENDTRY.
    ELSE.
      lv_infoobject = iv_infoobject.
    ENDIF.

    TRY.
        DATA(lt_infoobjects) = _get_fieldname_of_infoobject( to_upper( lv_infoobject ) ).
        TRY.
            rv_fieldname = lt_infoobjects[ iobjnm = lv_infoobject ]-fieldnm.
          CATCH cx_sy_itab_line_not_found INTO DATA(lcx_fieldnm).
            MESSAGE lcx_fieldnm->get_text( ) TYPE 'E'.
        ENDTRY.
      CATCH zcx_dqf INTO DATA(lcx_infoobjects).
        MESSAGE lcx_infoobjects->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD constructor.
* +--------------------------------------------------------------------------------------+
* | Constructor of the class
* +--------------------------------------------------------------------------------------+
* | [--->] ir_workpackage                 TYPE        ty_r_workpackages
* | [--->] ir_case                        TYPE        ty_r_cases
* +--------------------------------------------------------------------------------------+

    me->gt_cases = me->_load_dqf_testcases( EXPORTING ir_workpackage = ir_workpackage
                                                      ir_case_number = ir_case ).

    IF me->gt_cases[] IS INITIAL.
      RAISE EXCEPTION TYPE cx_no_data_found.
    ENDIF.

  ENDMETHOD.


  METHOD create_wherecondition.

    DATA: lt_wherecondition TYPE ty_t_wherecondition,
          ls_hierarchy      TYPE ty_hierarchy,
          ls_condition      TYPE ty_conditions,
          wa_testcase       TYPE ztm_dqf_cases,
          ls_parameter      TYPE zcl_dqf_read_table=>ty_parameter.

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
                  gv_multiple_hierarchies = determine_multiple_entries( iv_option = gc_hierarchy
                                                                        is_row    = <ls_test_case> ).
                ENDIF.

                "Get time information to determine the next valid hierarchy in case of time dependency.
                ls_hierarchy-validfrom       = <ls_test_case>-validfrom.
                ls_hierarchy-validto         = <ls_test_case>-validto.
                ls_hierarchy-hierarchy       = <ls_test_case>-low.
                ls_hierarchy-hierarchy_node  = get_conversion( iv_infoobject = <ls_test_case>-iobjnm
                                                               iv_value      = <ls_test_case>-high ).
                ls_hierarchy-infoobject      = <ls_test_case>-iobjnm.

                DATA(hierarchy_elements) = get_hierarchy_elements( ls_hierarchy  ).
              CATCH cx_rsr_hier_not_found INTO DATA(gex_hierarchy).
                MESSAGE gex_hierarchy->get_text( ) TYPE 'E'.
            ENDTRY.
          ELSE.
            CLEAR: hierarchy_elements.
          ENDIF.

          "Need for Conversion Routine
          determine_values( EXPORTING is_case = <ls_test_case>
                            IMPORTING es_case = wa_testcase ).

          gv_number_of_hierarchies = me->determine_multiple_entries( iv_option = gc_hierarchy
                                                                     is_row    = wa_testcase ).

          ls_condition-infoobject   = check_iobj( wa_testcase-iobjnm ).
          ls_condition-lines        = determine_multiple_entries( is_row = wa_testcase ).
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
                                             is_condition = ls_condition ) TO lt_wherecondition.
          CLEAR: wa_testcase.

        ELSE.
          go_dqf_query = NEW zcl_dqf_query( ).
          determine_values( EXPORTING is_case = <ls_test_case>
                            IMPORTING es_case = wa_testcase ).

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
    IF iv_option NE gc_hierarchy.
      rv_number_of_values = REDUCE i( INIT x = 0 FOR wa IN me->gt_cases WHERE ( num = is_row-num AND iobjnm = is_row-iobjnm AND wp = is_row-wp AND opt <> 'HI' ) NEXT x = x + 1 ).
    ELSE.
      rv_number_of_values = REDUCE i( INIT x = 0 FOR wa IN me->gt_cases WHERE ( num = is_row-num AND iobjnm = is_row-iobjnm AND wp = is_row-wp AND opt = 'HI' ) NEXT x = x + 1 ).
    ENDIF.
  ENDMETHOD.


  METHOD determine_values.
* +--------------------------------------------------------------------------------------+
* | Determine the vales of one line, if there are any variables or just values
* +--------------------------------------------------------------------------------------+
* | [--->] is_case                        TYPE        ztm_dqf_cases
* | [<---] es_case                        TYPE        ztm_dqf_cases
* +--------------------------------------------------------------------------------------+

    es_case = is_case.

    IF is_case-low(1) = '$'.
      es_case-low = determine_variables( is_case = is_case
                                         iv_type = 'low' ).
    ELSE.
      es_case-low = get_conversion( EXPORTING iv_infoobject = is_case-iobjnm
                                              iv_value      = is_case-low ).
    ENDIF.

    IF is_case-high(1) = '$'.
      es_case-high = determine_variables( is_case = is_case
                                          iv_type = 'high' ).
    ELSE.
      es_case-high = get_conversion( EXPORTING iv_infoobject = is_case-iobjnm
                                               iv_value      = is_case-high ).
    ENDIF.

  ENDMETHOD.


  METHOD determine_variables.
* +--------------------------------------------------------------------------------------+
* |
* +--------------------------------------------------------------------------------------+
* | [--->] iv_type                        TYPE        string
* | [--->] is_case                        TYPE        ztm_dqf_cases
* | [<---] r_value                        TYPE        string
* +--------------------------------------------------------------------------------------+

    DATA lv_calmonth  TYPE /bi0/oicalmonth.
    DATA lv_calyear   TYPE /bi0/oicalyear.
    DATA lv_calmonth2 TYPE /bi0/oicalmonth2.
    DATA lv_fiscper   TYPE /bi0/oifiscper.
    DATA lv_fiscper3  TYPE /bi0/oifiscper3.
    DATA lv_fiscyear  TYPE /bi0/oifiscyear.

    ASSIGN COMPONENT iv_type OF STRUCTURE is_case TO FIELD-SYMBOL(<lv_variable_value>).

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

    DATA: lv_wherecondition TYPE string.

    IF me->gs_breakpoints-condition = rs_c_true.
      BREAK-POINT.
    ENDIF.

    "More than one entry and table is empty
    IF is_condition-lines > 1 AND is_condition-wherecondition = rs_c_false.
      lv_wherecondition = `( ` && is_condition-infoobject.
      gv_bracket = rs_c_true.
      gv_count = gv_count + 1.
      "It exists entries for the same InfoObjet besides a hierarchy
    ELSEIF is_condition-lines > 1 AND is_condition-wherecondition = rs_c_true AND gv_bracket = rs_c_true AND gv_entry_beside_hierarchy = rs_c_true.
      lv_wherecondition = ` OR ` && is_condition-infoobject.
      gv_count = gv_count + 1.
      "When it starts with a single entry and a hierarchy also exists
    ELSEIF is_condition-lines = 1 AND is_condition-wherecondition = rs_c_true AND gv_entry_beside_hierarchy = rs_c_true AND gv_bracket = rs_c_false.
      lv_wherecondition = `AND ( ` && is_condition-infoobject.
      gv_bracket = rs_c_true.
      gv_count = gv_count + 1.
      gv_entry_beside_hierarchy = rs_c_false.
      "More than one entry but table is not empty
    ELSEIF is_condition-lines > 1 AND is_condition-wherecondition = rs_c_true AND gv_bracket = rs_c_false.
      lv_wherecondition = `AND ( ` && is_condition-infoobject.
      gv_bracket = rs_c_true.
      gv_count = gv_count + 1.
    ELSEIF is_condition-lines > 1 AND is_condition-wherecondition = rs_c_true AND gv_bracket = rs_c_true AND is_condition-range-sign = 'E'.
      lv_wherecondition = ` AND ` && is_condition-infoobject.
      gv_count = gv_count + 1.
      "More than one entry and table is not empty and not all conditions are added
    ELSEIF is_condition-lines > 1 AND is_condition-wherecondition = rs_c_true AND gv_bracket = rs_c_true.
      lv_wherecondition = ` OR ` && is_condition-infoobject.
      gv_count = gv_count + 1.
    ELSEIF is_condition-wherecondition = rs_c_false.
      lv_wherecondition = is_condition-infoobject
      .
    ELSE.
      lv_wherecondition = ` AND ` && is_condition-infoobject.
    ENDIF.

    "Conditions
    IF is_condition-range-low CS '%' OR is_condition-range-high CS '%'.
      IF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_eq ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_ne ).
        lv_wherecondition = lv_wherecondition && ` like ` && '''' && is_condition-range-low && ''''.
      ELSEIF ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_eq ) OR ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_ne ).
        lv_wherecondition = lv_wherecondition && ` not like ` && '''' && is_condition-range-low && ''''.
      ENDIF.
    ELSE.
      IF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_eq ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_ne ).
        lv_wherecondition = lv_wherecondition && ` = ` && '''' && is_condition-range-low && ''''.
      ELSEIF ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_eq ) OR ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_ne ).
        lv_wherecondition = lv_wherecondition && ` <> ` && '''' && is_condition-range-low && ''''.
      ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_bt ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_nb ).
        lv_wherecondition = lv_wherecondition && ` BETWEEN ` && '''' && is_condition-range-low && '''' &&  ` AND ` && '''' && is_condition-range-high && ''''.
      ELSEIF ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_bt ) OR ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_nb ).
        lv_wherecondition = lv_wherecondition && ` NOT BETWEEN ` && '''' && is_condition-range-low && '''' &&  ` AND ` && '''' && is_condition-range-high && ''''.
      ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_gt ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_le ).
        lv_wherecondition = lv_wherecondition && ` GT ` && '''' && is_condition-range-low && ''''.
      ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_le ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_gt ) .
        lv_wherecondition = lv_wherecondition && ` LE ` && '''' && is_condition-range-low && ''''.
      ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_ge ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_lt ) .
        lv_wherecondition = lv_wherecondition && ` GE ` && '''' && is_condition-range-low && ''''.
      ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_lt ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_ge ) .
        lv_wherecondition = lv_wherecondition && ` LT ` && '''' && is_condition-range-low && ''''.
      ELSE.
        RAISE EXCEPTION TYPE zcx_dqf
          EXPORTING
            textid = zcx_dqf=>sign_option_not_exists
            sign   = is_condition-range-sign
            option = is_condition-range-option.
      ENDIF.
    ENDIF.

    IF is_condition-lines = 1.
      r_wherecondition = lv_wherecondition.
      gv_count = 0.
    ELSEIF is_condition-lines = gv_count AND gv_bracket = rs_c_true AND gv_multiple_hierarchies > 1.
      r_wherecondition = lv_wherecondition.
      gv_count = 0.
      gv_multiple_hierarchies = gv_multiple_hierarchies - 1.
    ELSEIF is_condition-lines = gv_count AND gv_bracket = rs_c_true AND gv_entry_beside_hierarchy = rs_c_true.
      r_wherecondition = lv_wherecondition.
      gv_count = 0.
      gv_multiple_hierarchies = 0.
      gv_entry_beside_hierarchy = rs_c_false.
    ELSEIF is_condition-lines = gv_count AND gv_bracket = rs_c_true.
      r_wherecondition = lv_wherecondition && ` )`.
      gv_bracket = rs_c_false.
      gv_count = 0.
      gv_multiple_hierarchies = 0.
    ELSE.
      r_wherecondition = lv_wherecondition.
    ENDIF.

  ENDMETHOD.


  METHOD get_conversion.
* +--------------------------------------------------------------------------------------+
* | Convert the input value to the corresponding conversion routine of the InfoObject
* +--------------------------------------------------------------------------------------+
* | [--->] iv_infoobject                  TYPE        rsiobjnm
* | [--->] iv_value                       TYPE        c
* | [<---] rv_converted_value             TYPE        string
* +--------------------------------------------------------------------------------------+

    DATA: lv_value         TYPE string.
    DATA: lv_numeric_value TYPE string.
    DATA: lv_datatype      TYPE datatype_d.

    TRY.
        DATA(ls_convexit) = _get_conversion_base_char( iv_infoobject ).
      CATCH zcx_dqf.
        TRY.
            DATA(lv_rsdcha) = _get_conversion_characteristic( iv_infoobject ).
            ls_convexit     = _get_conversion_base_char( lv_rsdcha ).
          CATCH zcx_dqf INTO DATA(lcx_infoobject_not_exists).
            MESSAGE lcx_infoobject_not_exists->get_text( ) TYPE 'E'.
        ENDTRY.
    ENDTRY.

    IF ls_convexit-convexit = 'ALPHA'.

      CALL FUNCTION 'NUMERIC_CHECK'
        EXPORTING
          string_in  = iv_value
        IMPORTING
          string_out = lv_numeric_value
          htype      = lv_datatype.

      IF lv_datatype <> 'CHAR'.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = iv_value
          IMPORTING
            output = lv_value.
        DATA(lv_offset) = strlen( lv_value ) - ls_convexit-outputlen.
        rv_converted_value = lv_value+lv_offset(ls_convexit-outputlen).
      ELSE.
        rv_converted_value = iv_value.
      ENDIF.
    ELSEIF ls_convexit-convexit = 'PERI6'.
      IF strlen( iv_value ) > 6.
        CALL FUNCTION 'CONVERSION_EXIT_PERI6_INPUT'
          EXPORTING
            input  = iv_value
          IMPORTING
            output = lv_value.
        rv_converted_value = lv_value.
      ELSE.
        rv_converted_value = iv_value.
      ENDIF.
    ELSE.
      rv_converted_value = iv_value.
    ENDIF.
  ENDMETHOD.


  METHOD get_data.
* +--------------------------------------------------------------------------------------+
* | Get the data from the database
* +--------------------------------------------------------------------------------------+
* | [--->] it_wherecondition              TYPE        ty_t_wherecondition
* | [<---] rs_result                      TYPE        string
* +--------------------------------------------------------------------------------------+
    TYPES: ty_wherecond TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    DATA: lr_result_adso           TYPE REF TO data.
    DATA: lv_column_name           TYPE string.
    DATA: lv_datarows              TYPE p DECIMALS 0.
    DATA: lv_multiple_keyfigure    TYPE i VALUE 0.
    DATA: lt_fieldcat              TYPE lvc_t_fcat.
    DATA: ls_fieldcat              TYPE lvc_s_fcat.
    DATA: lv_kyf_sum               TYPE ty_result_value.
    DATA: lr_structure_description TYPE REF TO cl_abap_structdescr.
    DATA: lt_comp                  TYPE cl_abap_structdescr=>component_table.
    DATA: ls_parameter             TYPE zcl_dqf_read_table=>ty_parameter.

    FIELD-SYMBOLS: <lv_result_adso> TYPE any.
    FIELD-SYMBOLS: <lv_dyn_field>   TYPE any.
    FIELD-SYMBOLS: <lt_result_adso> TYPE ANY TABLE.

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
            CATCH zcx_dqf INTO DATA(lcx_datatype).
              MESSAGE lcx_datatype->get_text( ) TYPE 'E'.
          ENDTRY.
      ENDTRY.
      ls_fieldcat-fieldname = <ls_keyfigure>.
      APPEND ls_fieldcat TO lt_fieldcat.
      CONCATENATE lv_column_name ` SUM( ` lv_fieldname ' )' INTO lv_column_name.
    ENDLOOP.

    IF lv_multiple_keyfigure = 0.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_dqf
          EXPORTING
            textid = zcx_dqf=>infoobjects_not_exists
            iobjnm = ''.
      ENDIF.
    ELSEIF lv_multiple_keyfigure = 1.
      CREATE DATA lr_result_adso TYPE (lv_type_keyfigure).
      ASSIGN lr_result_adso->* TO <lv_result_adso>.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

      IF ls_parameter-rowcount = 'COUNT(*)'.
        lv_column_name = ls_parameter-rowcount.
      ELSE.
        CONCATENATE `SUM( ` lv_fieldname ' )' INTO lv_column_name.
      ENDIF.

    ELSE.

      cl_alv_table_create=>create_dynamic_table( EXPORTING it_fieldcatalog = lt_fieldcat
                                                 IMPORTING ep_table = lr_result_adso ).
      ASSIGN lr_result_adso->* TO <lt_result_adso>.

    ENDIF.

    TRY.
        _check_if_table_exists( ls_parameter-table ).
      CATCH zcx_dqf INTO DATA(lcx_table).
        MESSAGE lcx_table->get_text( ) TYPE 'E'.
    ENDTRY.
    DATA(lt_wherecondition) = VALUE ty_wherecond( FOR <ls_wherecond> IN it_whereconditions ( <ls_wherecond> ) ).

    TRY.

        IF me->gs_breakpoints-wherecondition = rs_c_true.
          BREAK-POINT.
        ENDIF.

        IF lv_multiple_keyfigure = 1.

          "Select data
          SELECT (lv_column_name)
            FROM (ls_parameter-table)
            INTO <lv_result_adso>
            WHERE (lt_wherecondition).               "#EC CI_SEL_NESTED
          ENDSELECT.

        ELSE.

          SELECT (lv_column_name)
            FROM (ls_parameter-table)
            INTO TABLE <lt_result_adso>
            WHERE (lt_wherecondition).

          LOOP AT <lt_result_adso> ASSIGNING FIELD-SYMBOL(<ls_result_adso_line>).
            lr_structure_description ?= cl_abap_structdescr=>describe_by_data( <ls_result_adso_line> ). " Get the description of the data
            lt_comp = lr_structure_description->get_components( ). "Get the fields of the structure
            LOOP AT lt_comp ASSIGNING FIELD-SYMBOL(<ls_comp>).
              ASSIGN COMPONENT <ls_comp>-name OF STRUCTURE <ls_result_adso_line> TO <lv_dyn_field>.
              lv_kyf_sum = lv_kyf_sum + <lv_dyn_field>.
            ENDLOOP.
          ENDLOOP.

        ENDIF.

        "Count data
        SELECT COUNT(*)
          FROM (ls_parameter-table)
          INTO lv_datarows
          WHERE (lt_wherecondition).                 "#EC CI_SEL_NESTED

        IF lv_multiple_keyfigure = 1.
          rs_result-result  = <lv_result_adso>.
        ELSE.
          rs_result-result = lv_kyf_sum.
        ENDIF.
        rs_result-datarows = lv_datarows.

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

    DATA: lt_hierarchies         TYPE rssh_t_hiedir.
    DATA: ls_hierarchy           TYPE rshiedir.
    DATA: ls_subtree             TYPE rssh_s_nodebyname.
    DATA: lr_hierarchy_structure TYPE REF TO data.
    DATA: lv_infoobject          TYPE rsiobjnm.
    DATA: ls_hierarchy_selection TYPE rssh_s_hiesel.

    FIELD-SYMBOLS: <lv_node>              TYPE any.
    FIELD-SYMBOLS: <lt_hierarchy_as_list> TYPE ANY TABLE.

    IF me->gs_breakpoints-hierarchy = rs_c_true.
      BREAK-POINT.
    ENDIF.

    TRY.
        DATA(lv_dataelement) = _get_dataelement_hierarchy( check_iobj( is_hierarchy-infoobject ) ).
      CATCH zcx_dqf INTO DATA(cx_infoobject).
        MESSAGE cx_infoobject->get_text( ) TYPE 'E'.
    ENDTRY.

    lv_infoobject = lv_dataelement+7.

    CREATE DATA lr_hierarchy_structure TYPE (lv_dataelement).
    ASSIGN lr_hierarchy_structure->* TO <lt_hierarchy_as_list>.
    CHECK <lt_hierarchy_as_list> IS ASSIGNED.

    CALL FUNCTION 'RSSH_HIER_OF_IOBJ_GET'
      EXPORTING
        i_objvers    = rs_c_objvers-active
        i_iobjnm     = lv_infoobject
        i_langu      = sy-langu
      IMPORTING
        e_t_rshiedir = lt_hierarchies.

    IF is_hierarchy-validfrom IS INITIAL AND is_hierarchy-validto IS INITIAL.

      TRY.
          ls_hierarchy = lt_hierarchies[ hienm   = is_hierarchy-hierarchy
                                         objvers = rs_c_objvers-active ].
        CATCH cx_sy_itab_line_not_found.
          "Hierarchy was not found
          RAISE EXCEPTION TYPE cx_rsr_hier_not_found.
      ENDTRY.

    ELSE.

      DATA(lt_time_dependent_hierarchy) = VALUE ty_time_dep_hierarchy( FOR <ls_hierarchy> IN lt_hierarchies WHERE ( hienm     = is_hierarchy-hierarchy AND
                                                                                                                    objvers   = rs_c_objvers-active AND
                                                                                                                    dateto   >= is_hierarchy-validto AND
                                                                                                                    datefrom <= is_hierarchy-validfrom ) ( <ls_hierarchy> ) ).

      TRY.
          ls_hierarchy = lt_time_dependent_hierarchy[ hienm = is_hierarchy-hierarchy ].
        CATCH cx_sy_itab_line_not_found.
          RAISE EXCEPTION TYPE cx_rsr_hier_not_found.
      ENDTRY.
      ls_hierarchy_selection-iobjnm = is_hierarchy-infoobject.
      ls_hierarchy_selection-hienm  = is_hierarchy-hierarchy.
      ls_hierarchy_selection-dateto = is_hierarchy-validto.

    ENDIF.

    "Subtree to node/leave
    CLEAR: ls_subtree.
    ls_subtree-iobjnm   = lv_infoobject.
    ls_subtree-nodename = is_hierarchy-hierarchy_node.

    cl_rssh_hierarchy_func=>get( EXPORTING i_objvers       = rs_c_objvers-active
                                           i_hieid         = ls_hierarchy-hieid
                                           i_s_subtreesel  = ls_subtree
                                           i_s_hiesel      = ls_hierarchy_selection
                                 IMPORTING e_t_hiestrucall = <lt_hierarchy_as_list> ).

    LOOP AT <lt_hierarchy_as_list> ASSIGNING FIELD-SYMBOL(<ls_hiestrucall>).
      ASSIGN COMPONENT 'NODENAME' OF STRUCTURE <ls_hiestrucall> TO <lv_node>.
      APPEND <lv_node> TO rt_flatlist.
    ENDLOOP.

    CLEAR: ls_hierarchy_selection, ls_hierarchy.

  ENDMETHOD.


  METHOD get_navigation_attribute.
* +--------------------------------------------------------------------------------------+
* | Get list of navigation attributes
* +--------------------------------------------------------------------------------------+
* | [--->] is_dqf_case                   TYPE        ztm_dqf_cases
* | [<---] rt_navigation_attribute        TYPE        ty_t_string
* +--------------------------------------------------------------------------------------+

    DATA: lv_navigation_attribute  TYPE c LENGTH 20.
    DATA: lv_infoobject            TYPE c LENGTH 30.
    DATA: lv_master_data_table     TYPE string.
    DATA: lv_infoobject_navigation TYPE rsdiobjnm.
    DATA: lr_infoobject_ref        TYPE REF TO data.
    DATA: ls_condition             TYPE ty_conditions.

    FIELD-SYMBOLS: <lt_infoobject> TYPE ANY TABLE.

    DATA(lv_fieldname) = check_iobj( is_dqf_case-iobjnm ).
    TRY.
        lv_master_data_table  = _get_dataelement_masterdata( lv_fieldname ).
      CATCH zcx_dqf INTO DATA(lcx_md_infoobject).
        MESSAGE lcx_md_infoobject->get_text( ) TYPE 'E'.
    ENDTRY.

    IF is_dqf_case-iobjnm CA '_'.

      lv_infoobject = is_dqf_case-iobjnm.
      DATA(lv_position) = sy-fdpos.

      CALL FUNCTION 'STRING_SPLIT_AT_POSITION'
        EXPORTING
          string  = lv_infoobject
          "Offset for __
          pos     = lv_position + 2
        IMPORTING
          string1 = lv_infoobject
          string2 = lv_navigation_attribute.

    ENDIF.

    "Get InfoObject
    lv_infoobject_navigation = lv_navigation_attribute.

    TRY.
        DATA(lv_dataelement) = _get_dataelement( lv_fieldname ).
      CATCH zcx_dqf INTO DATA(lcx_infoobject).
        MESSAGE lcx_infoobject->get_text( ) TYPE 'E'.
    ENDTRY.
    CREATE DATA lr_infoobject_ref TYPE TABLE OF (lv_dataelement).
    ASSIGN lr_infoobject_ref->* TO <lt_infoobject>.

    IF sy-subrc EQ 0.
      TRY.
          ls_condition-range-sign   = is_dqf_case-sign.
          ls_condition-range-option = is_dqf_case-opt.
          ls_condition-range-low    = is_dqf_case-low.
          ls_condition-range-high   = is_dqf_case-high.
          ls_condition-infoobject   = check_iobj( lv_infoobject_navigation ).
          DATA(whereconditions) = get_condition( ls_condition ).
        CATCH zcx_dqf INTO DATA(lcx_sign_option).
          MESSAGE lcx_sign_option->get_text( ) TYPE 'E'.
      ENDTRY.

      TRY.
          SELECT (lv_fieldname)
            FROM (lv_master_data_table)
            INTO TABLE <lt_infoobject>
            WHERE (whereconditions).                 "#EC CI_SEL_NESTED
          rt_navigation_attribute = <lt_infoobject>.
        CATCH cx_sy_dynamic_osql_syntax.
          MESSAGE | The Where Condition in Testcase { gv_case } of AP { gv_workpackage } is incorrect. | TYPE 'E'.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD get_output.

    DATA: lt_fieldcat TYPE slis_t_fieldcat_alv.
    DATA: ls_fieldcat TYPE slis_fieldcat_alv.
    DATA: lv_layout   TYPE slis_layout_alv.

    DATA(lt_case) = it_cases.

    "Optimize ALV Grid Output
    lv_layout-colwidth_optimize  = 'X'.

    "Create field catalog
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
* +--------------------------------------------------------------------------------------+
* | Get parameter for one test case
* +--------------------------------------------------------------------------------------+
* | [--->] iv_type                        TYPE        char2
* | [<---] rs_parameter                   TYPE        zcl_dqf_read_table=>ty_parameter
* +--------------------------------------------------------------------------------------+
    DATA(ls_parameters) = NEW zcl_dqf_read_table( ).
    ls_parameters->set_case( gv_case ).
    ls_parameters->set_workpackage( gv_workpackage ).
    ls_parameters->set_type( iv_type ).
    rs_parameter = ls_parameters->get_parameter( ).
  ENDMETHOD.


  METHOD get_result.
* +--------------------------------------------------------------------------------------+
* | Get result for the test case
* +--------------------------------------------------------------------------------------+
* | [--->] is_result                      TYPE        ty_result
* | [<---] rs_cases                       TYPE        ty_t_alv_grid
* +--------------------------------------------------------------------------------------+

    DATA: lv_s_result_value TYPE ty_result_value.
    DATA: lv_t_result_value TYPE ty_result_value.
    DATA: lv_flag           TYPE rs_bool.
    DATA: lt_case           TYPE ty_t_alv_grid.
    DATA: ls_case           TYPE ty_alv_grid.

    IF me->gs_breakpoints-result = rs_c_true.
      BREAK-POINT.
    ENDIF.

    "If there is a Source / Target Case
    IF gs_parameters_s-keyfigure IS NOT INITIAL.

      IF gs_parameters_s-factor <> ''.
        lv_s_result_value = cl_java_script=>create( )->evaluate( 'eval( ' && is_result-source_result && gs_parameters_s-factor && ' );' ).
      ELSE.
        lv_s_result_value = is_result-source_result.
      ENDIF.

      IF gs_parameters_t-factor <> ''.
        lv_t_result_value = cl_java_script=>create( )->evaluate( 'eval( ' && is_result-target_result && gs_parameters_t-factor && ' );' ).
      ELSE.
        lv_t_result_value = is_result-target_result.
      ENDIF.

      IF lv_s_result_value = lv_t_result_value.
        lv_flag = rs_c_true.
      ELSE.
        lv_flag = rs_c_false.
      ENDIF.

    ELSE.

      "Replace , with a .
      DATA(lv_number_as_string) =  gs_parameters_t-result_expected.
      REPLACE ',' IN lv_number_as_string WITH '.'.

      lv_s_result_value = lv_number_as_string.
      lv_t_result_value = is_result-target_result.

      IF gs_parameters_t-factor <> ''.
        lv_t_result_value = cl_java_script=>create( )->evaluate( 'eval( ' && is_result-target_result && gs_parameters_t-factor && ' );' ).
      ENDIF.

      "Check option of zz_result
      IF gs_parameters_t-result_opt = gc_eq.
        IF lv_s_result_value = lv_t_result_value.
          lv_flag = rs_c_true.
        ELSE.
          lv_flag = rs_c_false.
        ENDIF.
      ELSEIF gs_parameters_t-result_opt = gc_ne.
        IF lv_s_result_value = lv_t_result_value AND is_result-target_datarows > 0. "Zero Values
          lv_flag = rs_c_false.
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

      ls_case-status     = '@08@'.
      ls_case-wp         = gv_workpackage.
      ls_case-testcase   = gv_case.
      ls_case-expected   = lv_s_result_value.
      ls_case-result     = lv_t_result_value.
      ls_case-s_comment  = gs_parameters_s-comment .
      ls_case-t_comment  = gs_parameters_t-comment.
      ls_case-s_datarows = is_result-source_datarows .
      ls_case-t_datarows = is_result-target_datarows.
      TRY.
          ls_case-quote      = lv_t_result_value /  lv_s_result_value.
        CATCH cx_sy_zerodivide.
          ls_case-quote     = 0.
      ENDTRY.

      APPEND ls_case TO lt_case.

    ELSE.

      ls_case-status     = '@0A@'.
      ls_case-wp         = gv_workpackage.
      ls_case-testcase   = gv_case.
      ls_case-s_comment  = gs_parameters_s-comment.
      ls_case-t_comment  = gs_parameters_t-comment.
      ls_case-expected   = lv_s_result_value.
      ls_case-result     = lv_t_result_value.
      ls_case-s_datarows = is_result-source_datarows .
      ls_case-t_datarows = is_result-target_datarows.
      TRY.
          ls_case-quote      = lv_t_result_value /  lv_s_result_value.
        CATCH cx_sy_zerodivide.
          ls_case-quote     = 0.
      ENDTRY.
      APPEND ls_case TO lt_case.

    ENDIF.
    rt_cases = lt_case.
  ENDMETHOD.


  METHOD get_singleentries.
* +--------------------------------------------------------------------------------------+
* | Get single entries for a table with condition
* +--------------------------------------------------------------------------------------+
* | [--->] it_valus                       TYPE        ty_t_string
* | [--->] is_condition                   TYPE        ty_conditions
* | [<---] rt_wherecondition              TYPE        ty_t_wherecondition
* +--------------------------------------------------------------------------------------+

    DATA: ls_condition TYPE ty_conditions.

    IF me->gs_breakpoints-entries = rs_c_true.
      BREAK-POINT.
    ENDIF.

    IF it_values[] IS NOT INITIAL.
      DESCRIBE TABLE it_values LINES gv_multiple_entries.
      LOOP AT it_values ASSIGNING FIELD-SYMBOL(<ls_value>).
        TRY.
            ls_condition-lines                = gv_multiple_entries.
            ls_condition-infoobject           = is_condition-infoobject.
            ls_condition-range-sign           = is_condition-range-sign.
            ls_condition-range-option         = gc_eq.
            ls_condition-range-low            = CONV rslow( <ls_value> ).
            ls_condition-range-high           = ''.
            ls_condition-wherecondition       = is_condition-wherecondition.
            APPEND get_condition( ls_condition ) TO rt_wherecondition.
          CATCH zcx_dqf INTO DATA(lcx_sign_option).
            MESSAGE lcx_sign_option->get_text( ) TYPE 'E'.
        ENDTRY.
      ENDLOOP.
    ELSE.
      TRY.
          APPEND get_condition( is_condition ) TO rt_wherecondition.
        CATCH zcx_dqf INTO DATA(lcx_option_sign).
          MESSAGE lcx_option_sign->get_text( ) TYPE 'E'.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD get_testcases.
* +--------------------------------------------------------------------------------------+
* | Get test cases
* +--------------------------------------------------------------------------------------+
* | [<---] rt_case                        TYPE        ty_t_alv_grid
* +--------------------------------------------------------------------------------------+

    TYPES:
      BEGIN OF ty_workpackage_with_case,
        wp   TYPE ty_workpackage,
        case TYPE int2,
      END OF ty_workpackage_with_case.

    TYPES: ty_single_cases TYPE STANDARD TABLE OF ty_workpackage_with_case WITH EMPTY KEY.
    TYPES: ty_type TYPE STANDARD TABLE OF char2 WITH DEFAULT KEY.

    DATA: lt_case_final      TYPE ty_t_alv_grid.
    DATA: ls_result          TYPE ty_result.
    DATA: ls_source_value    TYPE ty_data.
    DATA: lv_case_type       TYPE char2.
    DATA: lv_flag_no_entries TYPE rs_bool VALUE rs_c_true. "Check flag for no entries

    IF me->gs_breakpoints-get_case = rs_c_true.
      BREAK-POINT.
    ENDIF.

    DATA(lt_s_dqf) = get_type( 'S' ).
    DATA(lt_t_dqf) = get_type( 'T' ).
    IF lt_t_dqf[] IS INITIAL.
      lt_t_dqf     = get_type( 'C' ).
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
      IF lt_s_dqf[] IS NOT INITIAL.

        DATA(lt_source_case_type) = VALUE ty_type( FOR <type> IN lt_s_dqf ( <type>-type ) ).
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

      IF lt_t_dqf[] IS NOT INITIAL.
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
* +--------------------------------------------------------------------------------------+
* | Get test cases with a certain type
* +--------------------------------------------------------------------------------------+
* | [--->] iv_type                        TYPE        char2
* | [<---] rt_cases                       TYPE        ty_t_dqf
* +--------------------------------------------------------------------------------------+
    rt_cases = VALUE ty_t_dqf( FOR <ls_case> IN gt_cases WHERE ( type(1) = iv_type ) ( <ls_case> ) ).
  ENDMETHOD.


  METHOD run.
**********************************************************************
* Author: T.Meyer, extern, Windhoff Software Services, 03.04.2019
**********************************************************************
*
* Automated Testing of specific testcases which are stored in
* table zvb0t_testing. Documentation can be get by the author.
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
* 12.08.20 TM Add Documentation and Save Option
**********************************************************************
*&---------------------------------------------------------------------*
    "Guten Morgen ... Oh, und falls wir uns nicht mehr sehen, guten Tag, guten Abend und gute Nacht!
    TYPES: ty_recipient TYPE STANDARD TABLE OF ty_mailaddress WITH EMPTY KEY.

    SORT me->gt_cases ASCENDING BY num iobjnm type.

    DATA(lt_testcases) = me->get_testcases( ).

    IF gv_save_result = rs_c_true.
      me->save_results( lt_testcases ).
    ENDIF.

    IF iv_mail = rs_c_true.
      DATA(lt_recipient) = VALUE ty_recipient( FOR <ls_mail> IN ir_mailaddresses ( <ls_mail>-low ) ).
      send_mail( EXPORTING it_cases     = lt_testcases
                           it_recipient = lt_recipient ).
    ELSE.
      get_output( lt_testcases ).
    ENDIF.

  ENDMETHOD.


  METHOD save_results.
* +--------------------------------------------------------------------------------------+
* | Save results to the database table ZTM_DQF_RESULT for further analysis
* +--------------------------------------------------------------------------------------+
* | [--->] it_cases                    TYPE        ty_t_alv_grid
* +--------------------------------------------------------------------------------------+

    DATA: ls_result_save TYPE ztm_dqf_result.
    DATA: lt_result_save TYPE STANDARD TABLE OF ztm_dqf_result.

    LOOP AT it_cases REFERENCE INTO DATA(ls_cases).
      ls_result_save-mandt = '001'.
      ls_result_save-timestamp = sy-datum && sy-uzeit.
      IF ls_cases->status = '@08@'. "Green Status
        ls_result_save-status = 'G'.
      ELSE.
        ls_result_save-status = 'R'.
      ENDIF.
      ls_result_save-workpackage = ls_cases->wp.
      ls_result_save-num         = ls_cases->testcase.
      ls_result_save-t_comment   = ls_cases->t_comment.
      ls_result_save-expected    = ls_cases->expected.
      ls_result_save-db_result   = ls_cases->result.
      ls_result_save-s_datarows  = ls_cases->s_datarows.
      ls_result_save-t_datarows  = ls_cases->t_datarows.
      ls_result_save-s_comment   = ls_cases->s_comment.
      ls_result_save-quote       = ls_cases->quote.

      APPEND ls_result_save TO lt_result_save.
    ENDLOOP.

    INSERT ztm_dqf_result FROM TABLE lt_result_save.

  ENDMETHOD.


  METHOD send_mail.

    CONSTANTS: gc_subject TYPE so_obj_des VALUE 'Status Testcases',
               gc_raw     TYPE char03 VALUE 'RAW'.

    DATA: lv_sent_to_all   TYPE os_boolean.
    DATA: lv_text          TYPE bcsy_text.
    DATA: lr_send_request  TYPE REF TO cl_bcs.
    DATA: lr_bcs_exception TYPE REF TO cx_bcs.
    DATA: lr_document      TYPE REF TO cl_document_bcs.
    DATA: lv_mail          TYPE string.

    TRY.
        "Create send request
        lr_send_request = cl_bcs=>create_persistent( ).
        "Add sender to send request
        lr_send_request->set_sender( cl_sapuser_bcs=>create( sy-uname ) ).

        "Email TO...
        LOOP AT it_recipient ASSIGNING FIELD-SYMBOL(<ls_recipient>).
          "Add recipient to send request
          lr_send_request->add_recipient( i_recipient = cl_cam_address_bcs=>create_internet_address( CONV adr6-smtp_addr( <ls_recipient> ) )
                                          i_express = 'X' ).
        ENDLOOP.

        "Email BODY
        APPEND 'Hello,'  TO lv_text.
        APPEND 'the following test cases are not correct:' TO lv_text.
        APPEND ' ' TO lv_text.
        APPEND `Testcase ` && `Expected Result ` && `Result ` && TEXT-007 TO lv_text.
        LOOP AT it_cases ASSIGNING FIELD-SYMBOL(<ls_case>).
          IF <ls_case>-status = '@0A@'.
            lv_mail = <ls_case>-testcase && ` ` && <ls_case>-expected && ` ` && <ls_case>-result && ` ` && <ls_case>-s_comment && ` ` && <ls_case>-t_comment.
            APPEND lv_mail TO lv_text.
          ENDIF.
        ENDLOOP.

        lr_document = cl_document_bcs=>create_document( i_type    = gc_raw
                                                        i_text    = lv_text
                                                        i_length  = '12'
                                                        i_subject = gc_subject ).
        "Add document to send request
        lr_send_request->set_document( lr_document ).

        "Send email
        lv_sent_to_all = lr_send_request->send( i_with_error_screen = 'X' ).
        IF lv_sent_to_all = 'X'.
          WRITE 'Email sent!'.
        ENDIF.

        "Commit to send email
        COMMIT WORK.

        "Exception handling
      CATCH cx_bcs INTO lr_bcs_exception.
        WRITE:
          'Error!',
          'Error type:',
          lr_bcs_exception->error_type.
    ENDTRY.

  ENDMETHOD.


  METHOD set_breakpoints.
    me->gs_breakpoints = is_breakpoints.
  ENDMETHOD.


  METHOD set_case_number.
    me->gv_case = iv_case.
  ENDMETHOD.


  METHOD set_green_cases.
    me->gv_skip_green_statements = iv_green_cases.
  ENDMETHOD.


  METHOD set_red_cases.
    me->gv_skip_failed_statements = iv_red_cases.
  ENDMETHOD.


  METHOD set_save_result.
    me->gv_save_result = iv_save_result.
  ENDMETHOD.


  METHOD set_type.
    me->gv_type = iv_type.
  ENDMETHOD.


  METHOD set_workpackages.
    me->gv_workpackage = iv_workpackage.
  ENDMETHOD.


  METHOD _check_if_display_attribute.
* +--------------------------------------------------------------------------------------+
* | Check if InfoObject is a display attribute
* +--------------------------------------------------------------------------------------+
* | [--->] iv_infoobject                  TYPE        rsiobjnm
* | [<---] rt_display_attributes          TYPE        ty_t_display_attributes
* +--------------------------------------------------------------------------------------+

    SELECT chabasnm,
           attrinm,
           attritp
      FROM rsdbchatr
      INTO TABLE @rt_display_attributes
      WHERE objvers = @rs_c_objvers-active AND
            attritp = 'DIS' AND
            attrinm = @iv_infoobject.                "#EC CI_SEL_NESTED

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_infoobject.
    ENDIF.
  ENDMETHOD.


  METHOD _check_if_navigation_attribute.
* +--------------------------------------------------------------------------------------+
* | Check if InfoObject is a navigation attribute
* +--------------------------------------------------------------------------------------+
* | [--->] iv_infoobject                  TYPE        rsiobjnm
* | [<---] rt_navigation_attributes       TYPE        ty_t_navigation_attributes
* +--------------------------------------------------------------------------------------+

    SELECT chanm,
           atrnavnm
      FROM rsdatrnav
      INTO TABLE @rt_navigation_attributes
      WHERE atrnavnm = @iv_infoobject AND
            objvers  = @rs_c_objvers-active.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_infoobject.
    ENDIF.
  ENDMETHOD.


  METHOD _check_if_table_exists.
* +--------------------------------------------------------------------------------------+
* | Check if database table exists
* +--------------------------------------------------------------------------------------+
* | [--->] iv_table                       TYPE        string
* +--------------------------------------------------------------------------------------+

    SELECT SINGLE @abap_true
      FROM dd02l
      INTO @DATA(exists)
     WHERE tabname = @iv_table.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>table_not_found
          table  = iv_table.
    ENDIF.
  ENDMETHOD.


  METHOD _get_conversion_base_char.
    SELECT SINGLE convexit,
                  outputlen
      FROM rsdchabas
      INTO @rv_value
      WHERE objvers  = @rs_c_objvers-active
      AND   chabasnm = @iv_infoobject.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_infoobject.
    ENDIF.
  ENDMETHOD.


  METHOD _get_conversion_characteristic.
    SELECT SINGLE chabasnm
       FROM rsdcha
       INTO @rv_value
       WHERE objvers = @rs_c_objvers-active
       AND   chanm   = @iv_infoobject.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_infoobject.
    ENDIF.
  ENDMETHOD.


  METHOD _get_dataelement.
    SELECT SINGLE rollname
      FROM dd04l
      INTO @rv_value
      WHERE shlpfield = @iv_infoobject.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_infoobject.
    ENDIF.
  ENDMETHOD.


  METHOD _get_dataelement_hierarchy.
    DATA(tabname) = '%WH%' && iv_infoobject && '%'.
    SELECT SINGLE typename
      FROM dd40l
      INTO @rv_value
      WHERE typename  LIKE @tabname.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_infoobject.
    ENDIF.
  ENDMETHOD.


  METHOD _get_dataelement_keyfigure.
    DATA ls_properties TYPE rsd_s_cob_pro.

    CALL FUNCTION 'RSD_IOBJ_GET'
      EXPORTING
        i_iobjnm         = iv_infoobject
        i_objvers        = rs_c_objvers-active
      IMPORTING
        e_s_cob_pro      = ls_properties
      EXCEPTIONS
        iobj_not_found   = 1
        illegal_input    = 2
        bct_comp_invalid = 3
        OTHERS           = 4.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_infoobject.
    ELSE.
      rv_value = ls_properties-dtelnm.
    ENDIF.
  ENDMETHOD.


  METHOD _get_dataelement_masterdata.
    DATA(lv_tabname) = '%P%' && iv_infoobject && '%'.
    SELECT SINGLE tabname
      FROM dd02l
      INTO @rv_value
      WHERE tabclass = 'TRANSP'
        AND tabname LIKE @lv_tabname.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_infoobject.
    ENDIF.
  ENDMETHOD.


  METHOD _get_datatype_characteristic.
    SELECT SINGLE datatp
      FROM rsdchabas
      INTO @rv_value
      WHERE objvers  = @rs_c_objvers-active
        AND chabasnm = @iv_infoobject.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_infoobject.
    ENDIF.
  ENDMETHOD.


  METHOD _get_datatype_keyfigure.


    SELECT SINGLE datatp
      FROM rsdkyf
      INTO @rv_value
      WHERE objvers = @rs_c_objvers-active
        AND kyfnm   = @iv_keyfigure.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_keyfigure.
    ENDIF.
  ENDMETHOD.


  METHOD _get_fieldname_of_infoobject.
* +--------------------------------------------------------------------------------------+
* | Get fieldname of InfoObject
* +--------------------------------------------------------------------------------------+
* | [--->] iv_infoobject                  TYPE        rsiobjnm
* | [<---] rt_infoobject_with_fieldname   TYPE        ty_t_infoobject_with_field
* +--------------------------------------------------------------------------------------+

    SELECT iobjnm,
           fieldnm
      FROM rsdiobj
      INTO TABLE @rt_infoobject_with_fieldname
      WHERE iobjnm  = @iv_infoobject AND
            objvers = @rs_c_objvers-active.

    IF sy-subrc NE 0.
      RAISE EXCEPTION TYPE zcx_dqf
        EXPORTING
          textid = zcx_dqf=>infoobjects_not_exists
          iobjnm = iv_infoobject.
    ENDIF.
  ENDMETHOD.


  METHOD _load_dqf_testcases.
* +--------------------------------------------------------------------------------------+
* | Load DQF test cases from database
* +--------------------------------------------------------------------------------------+
* | [--->] ir_workpackage                 TYPE        ty_r_workpackage
* | [--->] ir_case_number                 TYPE        ty_r_cases
* | [<---] rt_cases                       TYPE        ty_t_dqf
* +--------------------------------------------------------------------------------------+

    SELECT *
      FROM ztm_dqf_cases
      INTO TABLE @rt_cases
      WHERE wp  IN @ir_workpackage AND
            num IN @ir_case_number.

  ENDMETHOD.
ENDCLASS.
