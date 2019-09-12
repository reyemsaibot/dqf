CLASS z_dqf DEFINITION

  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.

  TYPES ty_wp TYPE ztm_dqf_cases-wp.
  TYPES:
    tyt_wp TYPE RANGE OF ty_wp .
  TYPES:
    ty_mailaddress TYPE c LENGTH 90 .
  TYPES:
    tyt_mailaddress TYPE RANGE OF ty_mailaddress .
  TYPES:
    tyt_ztm_dqf_cases TYPE STANDARD TABLE OF ztm_dqf_cases .
  TYPES:
    ty_dec_value TYPE p LENGTH 16 DECIMALS 2 .
  TYPES:
    ty_dec0 TYPE p LENGTH 16 DECIMALS 2 .
  TYPES:
    BEGIN OF ty_grid,
          status     TYPE c LENGTH 4,
          wp         TYPE ty_wp,
          testcase   TYPE int2,
          expected   TYPE string,
          result     TYPE string,
          s_comment  TYPE c LENGTH 60,
          s_datarows TYPE p LENGTH 16 DECIMALS 0,
          t_comment  TYPE c LENGTH 60,
          t_datarows TYPE p LENGTH 16 DECIMALS 0,
         END OF ty_grid .
  TYPES:
    tyt_grid TYPE STANDARD TABLE OF ty_grid WITH DEFAULT KEY.
  TYPES:
    tyt_string TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
  TYPES:
    tyt_num TYPE RANGE OF int2 .
  TYPES:
    BEGIN OF ty_nums,
          wp  TYPE ty_wp,
          num TYPE int2,
         END OF ty_nums .
  TYPES:
    tyt_nums TYPE STANDARD TABLE OF ty_nums .
  TYPES:
    BEGIN OF ty_wherecond,
          wc TYPE string,
         END OF ty_wherecond .
  TYPES:
    tyt_wherecond TYPE STANDARD TABLE OF ty_wherecond WITH DEFAULT KEY .
  TYPES:
    BEGIN OF ty_parameter,
      query           TYPE rszcompid,
      hcpr            TYPE rsinfoprov,
      keyfigure       TYPE rsdiobjnm,
      table           TYPE string,
      comment         TYPE string,
      result_expected TYPE string,
      result_opt      TYPE c LENGTH 2,
      factor          TYPE string,
    END OF ty_parameter.

  CLASS-METHODS run
    IMPORTING
      !i_ap TYPE tyt_wp
      !i_num TYPE tyt_num
      !i_mail TYPE boolean
      !i_mailaddress TYPE tyt_mailaddress .
PROTECTED SECTION.
PRIVATE SECTION.

  TYPES:
    BEGIN OF ty_dataelement,
          iobjnm TYPE rsdiobjnm,
          value  TYPE c LENGTH 1,
         END OF ty_dataelement .
  TYPES:
    BEGIN OF ty_hierarchy,
     hierarchy_node TYPE rshigh,
     hierarchy      TYPE rshienm,
     iobjnm         TYPE rsiobjnm,
    END OF ty_hierarchy .
  TYPES:
    BEGIN OF ty_conditions,
      lines  TYPE int2,
      iobjnm TYPE rsiobjnm,
      range  TYPE rsrange,
    END OF ty_conditions .
  TYPES:
    BEGIN OF ty_table_result,
      option  TYPE c LENGTH 2,
      comment TYPE c LENGTH 60,
      value   TYPE string,
    END OF ty_table_result .
  TYPES:
    BEGIN OF ty_query_filter,
      counter   TYPE int2,
      keyfigure TYPE rschanm,
      structure TYPE rschavl_maxlen,
      testcase  TYPE ztm_dqf_cases,
    END OF ty_query_filter .
  TYPES:
    BEGIN OF ty_query_keyfigure,
      parameter TYPE ty_parameter,
      counter   TYPE int2,
    END OF ty_query_keyfigure .
  TYPES:
    BEGIN OF ty_result,
      s_table       TYPE ty_dec_value,
      s_datarows  TYPE p LENGTH 16 DECIMALS 0,
      nums        TYPE ty_nums,
      t_table       TYPE ty_dec_value,
      t_datarows  TYPE p LENGTH 16 DECIMALS 0,
      s_parameter   TYPE ty_parameter,
      t_parameter   TYPE ty_parameter ,
    END OF ty_result .

  CONSTANTS:
    gc_ne TYPE c LENGTH 2 VALUE 'NE' ##NO_TEXT.
  CONSTANTS:
    gc_eq TYPE c LENGTH 2 VALUE 'EQ' ##NO_TEXT.
  CONSTANTS:
    gc_hi TYPE c  LENGTH 2 VALUE 'HI' ##NO_TEXT.
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
  CLASS-DATA gv_bracket TYPE boolean .
  CLASS-DATA gv_count TYPE int2 .
  CLASS-DATA gv_message TYPE string .
  CLASS-DATA gex_adso TYPE REF TO zcx_dqf_adso .
  CLASS-DATA gex_syntax TYPE REF TO cx_sy_dynamic_osql_syntax .
  CLASS-DATA gex_iobjnm TYPE REF TO cx_rsd_iobj_not_exist .
  CLASS-DATA gex_sign TYPE REF TO zcx_dqf_sign .
  CLASS-DATA gex_hierarchy TYPE REF TO cx_rsr_hier_not_found .
  CLASS-DATA gex_semantics TYPE REF TO cx_sy_dynamic_osql_semantics .
  CLASS-DATA gex_table TYPE REF TO cx_sy_itab_line_not_found .

  CLASS-METHODS prepare_data_query
    IMPORTING
      !i_query TYPE ty_query_keyfigure
      !it_parameter_final TYPE rrxw3tquery
    RETURNING
      VALUE(e_value) TYPE ty_dec_value .
  CLASS-METHODS prepare_data
    IMPORTING
      !i_parameter TYPE ty_parameter
      !it_wherecon TYPE tyt_wherecond
      !i_nums TYPE ty_nums
    EXPORTING
      !e_datarows TYPE ty_dec0
    RETURNING
      VALUE(e_value) TYPE ty_dec_value .
  CLASS-METHODS check_iobj
    IMPORTING
      !i_iobjnm TYPE rsdiobjnm
    RETURNING
      VALUE(e_fieldnm) TYPE rsdiobjfieldnm
    RAISING
      cx_rsd_iobj_not_exist .
  CLASS-METHODS get_data
    IMPORTING
      !i_parameter TYPE ty_parameter
      !it_wherecon TYPE tyt_wherecond
    EXPORTING
      !e_value TYPE ty_dec_value
      !e_datarows TYPE ty_dec0
    RAISING
      cx_sy_dynamic_osql_syntax
      zcx_dqf_adso .
  CLASS-METHODS get_type
    IMPORTING
      !it_ztm_dqf_cases TYPE tyt_ztm_dqf_cases
    EXPORTING
      VALUE(et_t_ztm_dqf_cases) TYPE tyt_ztm_dqf_cases
      VALUE(et_s_ztm_dqf_cases) TYPE tyt_ztm_dqf_cases .
  CLASS-METHODS get_navigation_attribute
    IMPORTING
      !i_ztm_dqf_cases TYPE ztm_dqf_cases
    RETURNING
      VALUE(et_values) TYPE tyt_string .
  CLASS-METHODS get_psa_table
    IMPORTING
      !i_table TYPE string
    RETURNING
      VALUE(e_table) TYPE rsodstech .
  CLASS-METHODS create_wherecondition
    IMPORTING
      !it_ztm_dqf_cases TYPE tyt_ztm_dqf_cases
      !it_wherecond TYPE tyt_wherecond
      !i_nums TYPE ty_nums
      !i_parameter TYPE ty_parameter
    EXPORTING
      !et_parameter TYPE rrxw3tquery
      !et_wherecond TYPE tyt_wherecond
      !e_counter TYPE int2 .
  CLASS-METHODS get_testcases
    IMPORTING
      !it_nums TYPE tyt_nums
      !it_ztm_dqf_cases TYPE tyt_ztm_dqf_cases
    RETURNING
      VALUE(et_case) TYPE tyt_grid .
  CLASS-METHODS get_parameters
    IMPORTING
      !it_ztm_dqf_cases TYPE tyt_ztm_dqf_cases
      !i_nums TYPE ty_nums
    RETURNING
      VALUE(e_parameter) TYPE ty_parameter .
  CLASS-METHODS read_table
    IMPORTING
      !i_nums TYPE ty_nums
      !i_iobjnm TYPE rsdiobjnm
      !it_ztm_dqf_cases TYPE tyt_ztm_dqf_cases
    RETURNING
      VALUE(e_value) TYPE ty_table_result .
  CLASS-METHODS get_query_filter
    IMPORTING
      !it_variable TYPE rsr_t_variable_definition OPTIONAL
      !i_query_filter TYPE ty_query_filter
    RETURNING
      VALUE(et_parameter) TYPE rrxw3tquery .
  CLASS-METHODS get_query_keyfigure
    IMPORTING
      !i_query_keyfigure TYPE ty_query_keyfigure
    RETURNING
      VALUE(et_parameter) TYPE rrxw3tquery .
  CLASS-METHODS get_query_result
    IMPORTING
      !i_parameter TYPE ty_parameter
      !it_parameter TYPE rrxw3tquery
    RETURNING
      VALUE(e_cases) TYPE ty_dec_value .
  CLASS-METHODS get_result
    IMPORTING
      !i_result TYPE ty_result
    RETURNING
      VALUE(et_cases) TYPE tyt_grid .
  CLASS-METHODS get_singleentries
    IMPORTING
      !it_wherecond TYPE tyt_wherecond
      !it_hierachy TYPE tyt_string OPTIONAL
      !i_table TYPE tyt_ztm_dqf_cases OPTIONAL
      !i_ztm_dqf_cases TYPE ztm_dqf_cases
    RETURNING
      VALUE(et_wherecond) TYPE tyt_wherecond .
  CLASS-METHODS read_query_definition
    IMPORTING
      !i_query TYPE ty_query_keyfigure
      !i_ztm_dqf_cases TYPE ztm_dqf_cases
    RETURNING
      VALUE(et_parameter) TYPE rrxw3tquery .
  CLASS-METHODS get_dataelement
    IMPORTING
      !i_dataelement TYPE ty_dataelement
    RETURNING
      VALUE(e_dataelement) TYPE string .
  CLASS-METHODS send_mail
    IMPORTING
      !i_cases TYPE tyt_grid
      !i_recipient TYPE STANDARD TABLE .
  CLASS-METHODS get_condition
    IMPORTING
      !it_wherecond TYPE tyt_wherecond OPTIONAL
      !is_condition TYPE ty_conditions
    RETURNING
      VALUE(e_wherecond) TYPE string
    RAISING
      zcx_dqf_sign .
  CLASS-METHODS get_hierarchy_elements
    IMPORTING
      !i_hierarchy_node TYPE ty_hierarchy
    RETURNING
      VALUE(e_flatlist) TYPE tyt_string
    RAISING
      cx_rsr_hier_not_found .
  CLASS-METHODS get_output
    IMPORTING
      !i_cases TYPE tyt_grid .
ENDCLASS.



CLASS z_dqf IMPLEMENTATION.


METHOD check_iobj.

DATA: lv_iobjnm  TYPE rsiobjnm,
      lv_disattr TYPE rsiobjnm.

"Check for navigation attribute
IF i_iobjnm CS '__'.
  SELECT chanm,
         atrnavnm
    FROM rsdatrnav
    INTO TABLE @DATA(lt_iobjnm_nav)
    WHERE atrnavnm = @i_iobjnm AND
          objvers  = @rs_c_objvers-active. "#EC CI_SEL_NESTED "#EC CI_GENBUFF

  IF sy-subrc <> 0.

    lv_iobjnm = i_iobjnm.
    DATA(lv_pos) = sy-fdpos.

    CALL FUNCTION 'STRING_SPLIT_AT_POSITION'
      EXPORTING
        string  = lv_iobjnm
        pos     = lv_pos + 2 "Offset for __
      IMPORTING
       string1  = lv_iobjnm
       string2  = lv_disattr.

    lv_iobjnm = lv_iobjnm(lv_pos).

    SELECT chabasnm,
           attrinm,
           attritp
      FROM rsdbchatr
      INTO TABLE @DATA(lt_iobjnm_dis)
      WHERE objvers = @rs_c_objvers-active AND
            attritp = 'DIS' AND
            attrinm = @lv_disattr. "#EC CI_SEL_NESTED "#EC CI_GENBUFF

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_rsd_iobj_not_exist EXPORTING iobjnm = i_iobjnm.
    ENDIF.
    DATA(lv_display_nav_only) = rs_c_true.

  ENDIF.

  IF lv_display_nav_only = rs_c_false.
    TRY.
      lv_iobjnm = lt_iobjnm_nav[ atrnavnm = i_iobjnm ].
    CATCH cx_sy_itab_line_not_found INTO gex_table.
      gv_message = gex_table->get_text( ).
      MESSAGE gv_message TYPE 'E'.
    ENDTRY.
  ENDIF.
ELSE.
  lv_iobjnm = i_iobjnm.
ENDIF.

"Check if infoobject exists
SELECT iobjnm,
       fieldnm
  FROM rsdiobj
  INTO TABLE @DATA(lt_iobjnm)
  WHERE iobjnm = @lv_iobjnm AND
        objvers = @rs_c_objvers-active. "#EC CI_SEL_NESTED

IF sy-subrc <> 0.
  RAISE EXCEPTION TYPE cx_rsd_iobj_not_exist EXPORTING iobjnm = lv_iobjnm.
ENDIF.

ASSIGN lt_iobjnm[ 1 ] TO FIELD-SYMBOL(<ls_iobjnm>).
IF sy-subrc EQ 0.
  TRY.
    <ls_iobjnm> = lt_iobjnm[ iobjnm = lv_iobjnm ].
    e_fieldnm = <ls_iobjnm>-fieldnm.
  CATCH cx_sy_itab_line_not_found INTO gex_table.
    gv_message = gex_table->get_text( ).
    MESSAGE gv_message TYPE 'E'.
  ENDTRY.
ENDIF.
ENDMETHOD.


METHOD create_wherecondition.

DATA: lt_wherecond       TYPE tyt_wherecond,
      lv_counter         TYPE int2 VALUE 0,
      lt_parameter_final TYPE rrxw3tquery,
      ls_hierarchy       type ty_hierarchy,
      ls_query           type ty_query_keyfigure.

"Create the dynamic where condition
LOOP AT it_ztm_dqf_cases ASSIGNING FIELD-SYMBOL(<ls_testing>) WHERE wp  = i_nums-wp AND
                                                                    num = i_nums-num.
  IF <ls_testing>-iobjnm+0(2) = 'ZZ' OR <ls_testing>-num NE i_nums-num.
    "Skip this record, as we do not use this in this case
  ELSE.
    "Check if it is a query or adso we need to check
    IF i_parameter-query = ''.

      "Check if it is a hierarchy
      IF <ls_testing>-opt = gc_hi.
        TRY.
           ls_hierarchy-hierarchy      = <ls_testing>-low.
           ls_hierarchy-hierarchy_node = <ls_testing>-high.
           ls_hierarchy-iobjnm         = <ls_testing>-iobjnm.

           DATA(lt_hierarchy) = get_hierarchy_elements( ls_hierarchy ).
        CATCH cx_rsr_hier_not_found INTO gex_hierarchy.
          gv_message = gex_hierarchy->get_text( ).
          MESSAGE gv_message TYPE 'E'.
        ENDTRY.
      ENDIF.

      et_wherecond = get_singleentries( EXPORTING i_table         = it_ztm_dqf_cases
                                                  it_wherecond    = lt_wherecond
                                                  it_hierachy     = lt_hierarchy
                                                  i_ztm_dqf_cases = <ls_testing> ).

    ELSE.

      lv_counter = lv_counter + 1.
      ls_query-counter   = lv_counter.
      ls_query-parameter = i_parameter.
      DATA(lt_parameter) = read_query_definition( EXPORTING i_query         = ls_query
                                                            i_ztm_dqf_cases = <ls_testing> ).

      APPEND LINES OF lt_parameter TO lt_parameter_final.
      CLEAR lt_parameter.

      e_counter    = lv_counter.
      et_parameter = lt_parameter_final.

    ENDIF.
  ENDIF.
ENDLOOP.

ENDMETHOD.


METHOD GET_CONDITION.

DATA: lv_wherecond TYPE ty_wherecond.

"More than one entry and table is empty
IF is_condition-lines > 1 AND it_wherecond[] IS INITIAL.
  lv_wherecond-wc = `( ` && is_condition-iobjnm.
  gv_bracket = rs_c_true.
  gv_count = gv_count + 1.
"More than one entry but table is not empty
ELSEIF is_condition-lines > 1 AND it_wherecond[] IS NOT INITIAL and gv_bracket = rs_c_false.
  lv_wherecond-wc = `AND ( ` && is_condition-iobjnm.
  "Bracket open
  gv_bracket = rs_c_true.
  gv_count = gv_count + 1.
"More than one entry and table is not empty and not all conditions are added
ELSEIF is_condition-lines > 1 AND it_wherecond[] IS NOT INITIAL AND gv_bracket = rs_c_true.
  lv_wherecond-wc = ` OR ` && is_condition-iobjnm.
  gv_count = gv_count + 1.
ELSEIF it_wherecond[] IS INITIAL.
  lv_wherecond-wc = is_condition-iobjnm.
ELSE.
  lv_wherecond-wc = ` AND ` && is_condition-iobjnm.
ENDIF.

"Conditions
IF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_eq ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_ne ).
  lv_wherecond-wc = lv_wherecond-wc && ` = ` && '''' && is_condition-range-low && ''''.
ELSEIF ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_eq ) OR ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_ne ).
  lv_wherecond-wc = lv_wherecond-wc && ` <> ` && '''' && is_condition-range-low && ''''.
ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_bt ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_nb ).
  lv_wherecond-wc = lv_wherecond-wc && ` BETWEEN ` && '''' && is_condition-range-low && '''' &&  ` AND ` && '''' && is_condition-range-high && ''''.
ELSEIF ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_bt ) OR ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_nb ).
  lv_wherecond-wc = lv_wherecond-wc && ` NOT BETWEEN ` && '''' && is_condition-range-low && '''' &&  ` AND ` && '''' && is_condition-range-high && ''''.
ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_gt ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_le ).
  lv_wherecond-wc = lv_wherecond-wc && ` GT ` && '''' && is_condition-range-low && ''''.
ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_le ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_gt ) .
  lv_wherecond-wc = lv_wherecond-wc && ` LE ` && '''' && is_condition-range-low && ''''.
ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_ge ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_lt ) .
  lv_wherecond-wc = lv_wherecond-wc && ` GE ` && '''' && is_condition-range-low && ''''.
ELSEIF ( is_condition-range-sign = 'I' AND is_condition-range-option = gc_lt ) OR ( is_condition-range-sign = 'E' AND is_condition-range-option = gc_ge ) .
  lv_wherecond-wc = lv_wherecond-wc && ` LT ` && '''' && is_condition-range-low && ''''.
ELSE.
  "Option and Sign not found
  RAISE EXCEPTION TYPE zcx_dqf_sign.
ENDIF.

IF is_condition-lines = 1.
  e_wherecond = lv_wherecond-wc.
elseif is_condition-lines = gv_count and gv_bracket = rs_c_true.
  e_wherecond = lv_wherecond-wc && ` )`.
  gv_bracket = rs_c_false.
  gv_count = 0.
ELSE.
  e_wherecond = lv_wherecond-wc.
ENDIF.

ENDMETHOD.


METHOD get_data.

TYPES: ty_wherecond TYPE STANDARD TABLE OF string WITH EMPTY KEY.

DATA: lv_result_adso     TYPE REF TO data,
      lv_column_name     TYPE string,
      lv_datarows        TYPE p DECIMALS 0,
      ls_dataelement     TYPE ty_dataelement.

FIELD-SYMBOLS: <fs_result_adso> TYPE any.

TRY.
  DATA(lv_fieldnm) = check_iobj( i_parameter-keyfigure ).
CATCH cx_rsd_iobj_not_exist INTO gex_iobjnm.
  gv_message = gex_iobjnm->get_text( ).
  MESSAGE gv_message TYPE 'E'.
ENDTRY.

ls_dataelement-iobjnm = lv_fieldnm.
DATA(lv_type_keyfigure) = get_dataelement( ls_dataelement ).

CREATE DATA lv_result_adso TYPE (lv_type_keyfigure).
ASSIGN lv_result_adso->* TO <fs_result_adso>.
IF sy-subrc NE 0.
  RETURN.
ENDIF.

CONCATENATE `SUM( ` lv_fieldnm ' )' INTO lv_column_name.

"Check if table exists
SELECT tabname
  FROM dd02l
  INTO TABLE @DATA(lt_adso)
  WHERE tabname = @i_parameter-table. "#EC CI_SEL_NESTED

IF sy-subrc <> 0.
  RAISE EXCEPTION TYPE zcx_dqf_adso EXPORTING msgv1 = `` && i_parameter-table && ``.
ENDIF.
DATA(lt_wherecond) = VALUE ty_wherecond( FOR <ls_wherecon> IN it_wherecon ( <ls_wherecon>-wc ) ).

TRY.

  "Select data
  SELECT (lv_column_name)
    FROM (i_parameter-table)
    INTO <fs_result_adso>
    WHERE (lt_wherecond). "#EC CI_SEL_NESTED
  ENDSELECT.

  "Count data
  SELECT COUNT(*)
    FROM (i_parameter-table)
    INTO lv_datarows
    WHERE (lt_wherecond). "#EC CI_SEL_NESTED

  e_value    = <fs_result_adso>.
  e_datarows = lv_datarows.

CATCH cx_sy_dynamic_osql_syntax.
  RAISE EXCEPTION TYPE cx_sy_dynamic_osql_syntax EXPORTING sqlcode = cx_sy_dynamic_osql_syntax=>where_clause.
CATCH cx_sy_dynamic_osql_semantics INTO gex_semantics.
  gv_message = gex_semantics->get_text( ) && ` in table: ` && i_parameter-table .
  MESSAGE gv_message TYPE 'E'.
ENDTRY.
ENDMETHOD.


METHOD get_dataelement.

DATA: lv_infoobject TYPE c LENGTH 20.

lv_infoobject = i_dataelement-iobjnm.

IF i_dataelement-value = 'H'.
  IF to_upper( lv_infoobject(5) ) = '/BIC/'.
    e_dataelement = '/BIC/WH' && lv_infoobject+5.
  ELSE.
    e_dataelement = '/BI0/WH' && lv_infoobject.
  ENDIF.
ELSEIF i_dataelement-value = 'M'.
  IF to_upper( lv_infoobject(5) ) = '/BIC/'.
    e_dataelement = '/BIC/P' && lv_infoobject+5.
  ELSE.
    e_dataelement = '/BI0/P' && lv_infoobject.
  ENDIF.
ELSE.
  IF to_upper( lv_infoobject(5) ) = '/BIC/'.
    e_dataelement = '/BIC/OI' && lv_infoobject+5(10).
  ELSE. "Standard SAP Objects
    e_dataelement = '/BI0/OI' && lv_infoobject.
  ENDIF.
ENDIF.
ENDMETHOD.


METHOD get_hierarchy_elements.

DATA: ls_rssh_hiedir TYPE rshiedir,
      lt_rssh_hiedir TYPE rssh_t_hiedir,
      ls_subtreesel  TYPE rssh_s_nodebyname,
      lt_hiestrucall TYPE REF TO data,
      lv_iobjnm      TYPE rsiobjnm,
      ls_dataelement type ty_dataelement.

FIELD-SYMBOLS: <fs_node>        TYPE any,
               <ft_hiestrucall> TYPE ANY TABLE.

ls_dataelement-iobjnm =  i_hierarchy_node-iobjnm.
ls_dataelement-value  = 'H'. "Hierarchy
DATA(lv_infoobject) = get_dataelement( ls_dataelement ).

lv_iobjnm = lv_infoobject+7.
DATA(lv_fieldnm) = check_iobj( i_hierarchy_node-iobjnm ).

CREATE DATA lt_hiestrucall TYPE (lv_fieldnm).
ASSIGN lt_hiestrucall->* TO <ft_hiestrucall>.
CHECK <ft_hiestrucall> IS ASSIGNED.

CALL FUNCTION 'RSSH_HIER_OF_IOBJ_GET'
 EXPORTING
   i_objvers      = rs_c_objvers-active
   i_iobjnm       = lv_iobjnm
   i_langu        = sy-langu
 IMPORTING
   e_t_rshiedir  = lt_rssh_hiedir.

* hierarchy-ID of hierachy
CLEAR ls_rssh_hiedir.

TRY.
  ls_rssh_hiedir = lt_rssh_hiedir[ hienm   = i_hierarchy_node-hierarchy
                                   objvers = rs_c_objvers-active ].
CATCH cx_sy_itab_line_not_found.
  "Hierarchy was not found
  RAISE EXCEPTION TYPE cx_rsr_hier_not_found.
ENDTRY.

* Read sub node to leaf/node
CLEAR: ls_subtreesel.
ls_subtreesel-iobjnm   = lv_iobjnm.
ls_subtreesel-nodename = i_hierarchy_node-hierarchy_node.

* No time dependency for hierarchy
cl_rssh_hierarchy_func=>get( EXPORTING i_objvers       = rs_c_objvers-active
                                       i_hieid         = ls_rssh_hiedir-hieid
                                       i_s_subtreesel  = ls_subtreesel
                             IMPORTING e_t_hiestrucall = <ft_hiestrucall> ).

LOOP AT <ft_hiestrucall> ASSIGNING FIELD-SYMBOL(<fs_hiestrucall>).
  ASSIGN COMPONENT 'NODENAME' OF STRUCTURE <fs_hiestrucall> TO <fs_node>.
  APPEND <fs_node> TO e_flatlist.
ENDLOOP.

ENDMETHOD.


METHOD get_navigation_attribute.

DATA: lv_navattr           TYPE c LENGTH 20,
      lv_iobjnm            TYPE c LENGTH 30,
      lv_master_data_table TYPE string,
      lv_iobjnm_nav        TYPE rsdiobjnm,
      lv_infoobject        TYPE REF TO data,
      ls_condition         type ty_conditions,
      ls_dataelement       type ty_dataelement.

FIELD-SYMBOLS: <fs_infoobject> TYPE ANY TABLE.

TRY.
  DATA(lv_fieldnm) = check_iobj( i_ztm_dqf_cases-iobjnm ).
CATCH cx_rsd_iobj_not_exist INTO gex_iobjnm.
  gv_message = gex_iobjnm->get_text( ).
  MESSAGE gv_message TYPE 'E'.
ENDTRY.

IF i_ztm_dqf_cases-iobjnm CA '_'.

  lv_iobjnm = i_ztm_dqf_cases-iobjnm.
  DATA(lv_pos) = sy-fdpos.

  CALL FUNCTION 'STRING_SPLIT_AT_POSITION'
    EXPORTING
      string  = lv_iobjnm
      pos     = lv_pos + 2 "Offset for __
    IMPORTING
     string1  = lv_iobjnm
     string2  = lv_navattr.

ENDIF.

"Get InfoObject
lv_iobjnm_nav = lv_navattr.

"Get Fieldname for Navigation Attribute
TRY.
  lv_iobjnm_nav = check_iobj( lv_iobjnm_nav ).
CATCH cx_rsd_iobj_not_exist INTO gex_iobjnm.
  gv_message = gex_iobjnm->get_text( ).
  MESSAGE gv_message TYPE 'E'.
ENDTRY.

"Get Master Data Table
ls_dataelement-iobjnm = lv_fieldnm.
ls_dataelement-value  = 'M'. "Masterdata
lv_master_data_table = get_dataelement( ls_dataelement ).

ls_dataelement-value = ''.
DATA(lv_dataelement) = get_dataelement( ls_dataelement ).
CREATE DATA lv_infoobject TYPE TABLE OF (lv_dataelement).
ASSIGN lv_infoobject->* TO <fs_infoobject>.

IF sy-subrc EQ 0.
  TRY.
    ls_condition-range-sign   = i_ztm_dqf_cases-sign.
    ls_condition-range-option = i_ztm_dqf_cases-opt.
    ls_condition-range-low    = i_ztm_dqf_cases-low.
    ls_condition-range-high   = i_ztm_dqf_cases-high.
    ls_condition-iobjnm       = lv_iobjnm_nav.

    DATA(lv_wherecond) = get_condition( ls_condition ).
  CATCH zcx_dqf_sign INTO gex_sign.
    gv_message = gex_sign->get_text( ).
    MESSAGE gv_message TYPE 'E'.
  ENDTRY.

  TRY.
    SELECT (lv_fieldnm)
      FROM (lv_master_data_table)
      INTO TABLE <fs_infoobject>
      WHERE (lv_wherecond). "#EC CI_SEL_NESTED
    et_values = <fs_infoobject>.
  CATCH cx_sy_dynamic_osql_syntax.
    gv_message = `The Where Condition in Testcase ` && i_ztm_dqf_cases-num && ` of wp ` && i_ztm_dqf_cases-wp && ` is incorrect.`.
    MESSAGE gv_message TYPE 'E'.
  ENDTRY.
ENDIF.
ENDMETHOD.


METHOD get_output.

DATA: lt_fieldcat        TYPE slis_t_fieldcat_alv,
      ls_fieldcat        TYPE slis_fieldcat_alv,
      lv_layout          TYPE slis_layout_alv.

DATA(lt_case) = i_cases.

"Optimize ALV Grid Output
lv_layout-colwidth_optimize  = 'X'.

*Create field catalog
ls_fieldcat-fieldname = 'STATUS'.
ls_fieldcat-seltext_m = text-001.
APPEND ls_fieldcat TO lt_fieldcat.

ls_fieldcat-fieldname = 'wp'.
ls_fieldcat-seltext_m = text-003.
APPEND ls_fieldcat TO lt_fieldcat.

ls_fieldcat-fieldname = 'TESTCASE'.
ls_fieldcat-seltext_m = text-004.
APPEND ls_fieldcat TO lt_fieldcat.

ls_fieldcat-fieldname = 'EXPECTED'.
ls_fieldcat-seltext_m = text-005.
APPEND ls_fieldcat TO lt_fieldcat.

ls_fieldcat-fieldname = 'RESULT'.
ls_fieldcat-seltext_m = text-006.
APPEND ls_fieldcat TO lt_fieldcat.

ls_fieldcat-fieldname = 'S_COMMENT'.
ls_fieldcat-seltext_m = text-007.
APPEND ls_fieldcat TO lt_fieldcat.

ls_fieldcat-fieldname = 'S_DATAROWS'.
ls_fieldcat-seltext_m = text-008.
APPEND ls_fieldcat TO lt_fieldcat.

ls_fieldcat-fieldname = 'T_COMMENT'.
ls_fieldcat-seltext_m = text-009.
APPEND ls_fieldcat TO lt_fieldcat.

ls_fieldcat-fieldname = 'T_DATAROWS'.
ls_fieldcat-seltext_m = text-010.
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

DATA: ls_table_result TYPE ty_table_result.

"Check if Query or ADSO Result
ls_table_result = read_table( EXPORTING i_nums           = i_nums
                                        i_iobjnm         = 'ZZ_QUERY'
                                        it_ztm_dqf_cases = it_ztm_dqf_cases ).

e_parameter-query = ls_table_result-value.

ls_table_result = read_table( EXPORTING i_nums           = i_nums
                                        i_iobjnm         = 'ZZ_KEYFIGURE'
                                        it_ztm_dqf_cases = it_ztm_dqf_cases ).

e_parameter-keyfigure = ls_table_result-value.

IF e_parameter-query = ''.

  ls_table_result = read_table( EXPORTING i_nums           = i_nums
                                          i_iobjnm         = 'ZZ_ADSO'
                                          it_ztm_dqf_cases = it_ztm_dqf_cases ).

  e_parameter-comment = ls_table_result-comment.

  IF ls_table_result-option = 'A'. "Active Table
    e_parameter-table = '/BIC/A' && ls_table_result-value && '2'.
  ELSEIF ls_table_result-option = 'I'. "Inbound Table
    e_parameter-table = '/BIC/A' && ls_table_result-value && '1'.
  ELSEIF ls_table_result-option = 'P'. "PSA Table
    e_parameter-table = get_psa_table( ls_table_result-value ).
  ENDIF.

ELSE.

  ls_table_result = read_table( EXPORTING i_nums           = i_nums
                                          i_iobjnm         = 'ZZ_HCPR'
                                          it_ztm_dqf_cases = it_ztm_dqf_cases ).

  e_parameter-hcpr = ls_table_result-value.
  e_parameter-comment = ls_table_result-comment.

ENDIF.

ls_table_result = read_table( EXPORTING i_nums           = i_nums
                                        i_iobjnm         = 'ZZ_RESULT' && '_' && sy-sysid
                                        it_ztm_dqf_cases = it_ztm_dqf_cases ).

e_parameter-result_expected = ls_table_result-value.
e_parameter-result_opt      = ls_table_result-option.

ls_table_result = read_table( EXPORTING i_nums           = i_nums
                                        i_iobjnm         = 'ZZ_FACTOR'
                                        it_ztm_dqf_cases = it_ztm_dqf_cases ).

e_parameter-factor = ls_table_result-value.

ENDMETHOD.


METHOD get_psa_table.

TYPES: ty_psa TYPE STANDARD TABLE OF RSODSTECH WITH EMPTY KEY.

SELECT odsname_tech,
       userobj
  FROM rstsods
  INTO TABLE @data(lt_rstsods). "#EC CI_SEL_NESTED "#EC CI_GENBUFF

IF sy-subrc = 0.
 data(lt_psa) = VALUE ty_psa( FOR <ls_rstsods> IN lt_rstsods  WHERE ( userobj CS i_table ) ( <ls_rstsods>-odsname_tech ) ).
 e_table = lt_psa[ 1 ].
ENDIF.
ENDMETHOD.


METHOD get_query_filter.

TYPES: ty_variable TYPE rsr_t_variable_definition.

DATA: ls_parameter TYPE w3query,
      lt_parameter TYPE rrxw3tquery.

"Check if there is a variable for the infoobject
"Skip hierarchy variables
DATA(lt_variable) = VALUE ty_variable( FOR <ls_variable> IN it_variable WHERE ( vartyp <> '5' ) ( <ls_variable> ) ).

IF line_exists( lt_variable[ iobjnm = i_query_filter-testcase-iobjnm ] ).

  DATA(ls_variable) = lt_variable[ iobjnm = i_query_filter-testcase-iobjnm ].

  ls_parameter-name  = 'VAR_SIGN_' && i_query_filter-counter.
  ls_parameter-value = i_query_filter-testcase-sign.

  APPEND ls_parameter TO lt_parameter.

  ls_parameter-name  = 'VAR_OPERATOR_' && i_query_filter-counter.
  ls_parameter-value = i_query_filter-testcase-opt.

  APPEND ls_parameter TO lt_parameter.

  IF i_query_filter-testcase-opt = gc_eq.

    "Hierarchy Node
    IF ls_variable-vartyp = '2'.
      ls_parameter-name  = 'VAR_VALUE_EXT_' && i_query_filter-counter.
    ELSE.
      ls_parameter-name  = 'VAR_VALUE_LOW_EXT_' && i_query_filter-counter.
    ENDIF.
    ls_parameter-value = i_query_filter-testcase-low.
    APPEND ls_parameter TO lt_parameter.

  ELSEIF i_query_filter-testcase-opt = 'BT'.

    ls_parameter-name  = 'VAR_VALUE_LOW_EXT_' && i_query_filter-counter.
    ls_parameter-value = i_query_filter-testcase-low.
    APPEND ls_parameter TO lt_parameter.
    ls_parameter-name  = 'VAR_VALUE_HIGH_EXT_' && i_query_filter-counter.
    ls_parameter-value = i_query_filter-testcase-high.
    APPEND ls_parameter TO lt_parameter.

  ENDIF.

  ls_parameter-name  = 'VAR_NAME_' && i_query_filter-counter.
  ls_parameter-value = ls_variable-vnam.
  APPEND ls_parameter TO lt_parameter.

ELSE.

  "Create filter if there is no variable
  "Filter values can only be single values with Include
  ls_parameter-name  = 'FILTER_IOBJNM_' && i_query_filter-counter.

  IF i_query_filter-testcase IS INITIAL.
    ls_parameter-value = i_query_filter-structure.
  ELSE.
    ls_parameter-value = i_query_filter-testcase-iobjnm.
  ENDIF.

  APPEND ls_parameter TO lt_parameter.
  ls_parameter-name  = 'FILTER_VALUE_' && i_query_filter-counter.

  IF i_query_filter-testcase IS INITIAL.
    ls_parameter-value = i_query_filter-keyfigure.
  ELSE.
    ls_parameter-value = i_query_filter-testcase-low.
  ENDIF.
  APPEND ls_parameter TO lt_parameter.

ENDIF.

et_parameter = lt_parameter.

ENDMETHOD.


METHOD get_query_keyfigure.

DATA: lt_columns      TYPE TABLE OF rrx_x_axis_data,
      lv_keyfigure    TYPE c LENGTH 20,
      ls_query_filter TYPE ty_query_filter.

CALL FUNCTION 'RS_VC_GET_QUERY_VIEW_DATA_FLAT'
  EXPORTING
    i_infoprovider                = i_query_keyfigure-parameter-hcpr
    i_query                       = i_query_keyfigure-parameter-query
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

IF sy-subrc <> 0.
  RETURN.
ENDIF.

ASSIGN lt_columns[ 1 ] TO FIELD-SYMBOL(<ls_columns>).
IF sy-subrc EQ 0.
  TRY.
    <ls_columns> = lt_columns[ caption = to_mixed( i_query_keyfigure-parameter-keyfigure ) ].
    ls_query_filter-counter   = i_query_keyfigure-counter.
    ls_query_filter-structure = <ls_columns>-chavl.
    ls_query_filter-keyfigure = <ls_columns>-chanm.
    et_parameter = get_query_filter( ls_query_filter ).
  CATCH cx_sy_itab_line_not_found INTO gex_table.
    gv_message = gex_table->get_text( ).
    MESSAGE gv_message TYPE 'E'.
  ENDTRY.
ENDIF.
ENDMETHOD.


METHOD get_query_result.

TYPES: ty_table TYPE STANDARD TABLE OF rrxfloat WITH EMPTY KEY.

DATA: lt_result  TYPE rrws_t_cell.

CALL FUNCTION 'RS_VC_GET_QUERY_VIEW_DATA'
 EXPORTING
   i_infoprovider                = i_parameter-hcpr
   i_query                       = i_parameter-query
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
   OTHERS                        = 7
            .
IF sy-subrc <> 0.
  RETURN.
ENDIF.

IF lt_result[] IS NOT INITIAL.
  DATA(lt_value) = VALUE ty_table( FOR <ls_result> IN lt_result ( <ls_result>-value ) ).
  e_cases = lt_value[ 1 ].
ENDIF.
ENDMETHOD.


METHOD get_result.

DATA: lv_s_result_value TYPE ty_dec_value,
      lv_t_result_value TYPE ty_dec_value,

      lv_flag           TYPE boolean,
      lt_case           TYPE tyt_grid,
      lv_case           TYPE ty_grid.

"If there is a Source / Target Case
IF i_result-s_table IS NOT INITIAL.

  IF i_result-s_parameter-factor NE ''.
    lv_s_result_value = cl_java_script=>create( )->evaluate( 'eval( ' && i_result-s_table && i_result-s_parameter-factor && ' );' ).
  ENDIF.

  IF i_result-t_parameter-factor NE ''.
    lv_t_result_value = cl_java_script=>create( )->evaluate( 'eval( ' && i_result-t_table && i_result-t_parameter-factor && ' );' ).
  ENDIF.

  IF lv_s_result_value = lv_t_result_value.
    lv_flag = rs_c_true.
  ELSE.
    lv_flag = rs_c_false.
  ENDIF.

ELSE.

  lv_s_result_value = i_result-t_parameter-result_expected.
  lv_t_result_value = i_result-t_table.

  IF i_result-t_parameter-factor NE ''.
    lv_t_result_value = cl_java_script=>create( )->evaluate( 'eval( ' && i_result-t_table && i_result-t_parameter-factor && ' );' ).
  ENDIF.

  "Check option of zz_result
  IF i_result-t_parameter-result_opt = gc_eq.
    IF lv_s_result_value = lv_t_result_value.
      lv_flag = rs_c_true.
    ELSE.
      lv_flag = rs_c_false.
    ENDIF.
  ELSEIF i_result-t_parameter-result_opt = gc_ne.
    IF lv_s_result_value <> lv_t_result_value.
      lv_flag = rs_c_true.
    ELSE.
      lv_flag = rs_c_false.
    ENDIF.
  ENDIF.

ENDIF.

IF lv_flag = rs_c_true.

   lv_case-status     = '@08@'.
   lv_case-wp         = i_result-nums-wp.
   lv_case-testcase   = i_result-nums-num.
   lv_case-s_comment  = i_result-s_parameter-comment .
   lv_case-t_comment  = i_result-t_parameter-comment.
   lv_case-s_datarows = i_result-s_datarows .
   lv_case-t_datarows = i_result-t_datarows.

   APPEND lv_case TO lt_case.

 ELSE.

   lv_case-status     = '@0A@'.
   lv_case-wp         = i_result-nums-wp.
   lv_case-testcase   = i_result-nums-num.
   lv_case-s_comment  = i_result-s_parameter-comment.
   lv_case-t_comment  = i_result-t_parameter-comment.
   lv_case-expected   = lv_s_result_value.
   lv_case-result     = lv_t_result_value.
   lv_case-s_datarows = i_result-s_datarows .
   lv_case-t_datarows = i_result-t_datarows.
   APPEND lv_case TO lt_case.

ENDIF.

et_cases = lt_case.

ENDMETHOD.


METHOD get_singleentries.

DATA: lv_lines        TYPE int2,
      lv_where_lines  TYPE int2,
      lv_low          TYPE rslow,
      lv_wherecond    TYPE ty_wherecond,
      ls_condition    type ty_conditions.

DATA(lt_wherecond) = it_wherecond.

"Loop for multiple entries for one InfoObject
lv_lines = REDUCE i( INIT x = 0 FOR wa IN i_table WHERE ( num = i_ztm_dqf_cases-num AND
                     iobjnm = i_ztm_dqf_cases-iobjnm ) NEXT x = x + 1 ).

TRY.
  DATA(lv_fieldnm) = check_iobj( i_ztm_dqf_cases-iobjnm ).
CATCH cx_rsd_iobj_not_exist INTO gex_iobjnm.
  gv_message = gex_iobjnm->get_text( ).
  MESSAGE gv_message TYPE 'E'.
ENDTRY.

"Get Entries for Navigation Attributes
IF i_ztm_dqf_cases-iobjnm CS '__'.
  DATA(lt_values) = get_navigation_attribute( i_ztm_dqf_cases ).
ENDIF.

"Check if a hierarchy exists
IF it_hierachy[] IS NOT INITIAL.
  lt_values = it_hierachy.
ENDIF.

IF lt_values[] IS NOT INITIAL.

  DESCRIBE TABLE lt_values LINES lv_lines.

  LOOP AT lt_values ASSIGNING FIELD-SYMBOL(<ls_values>).

    DESCRIBE TABLE lt_wherecond LINES lv_where_lines.
    lv_low = <ls_values>.
    TRY.

      ls_condition-lines                = lv_lines.
      ls_condition-iobjnm               = lv_fieldnm.
      ls_condition-range-sign           = i_ztm_dqf_cases-sign.
      ls_condition-range-option         = gc_eq.
      ls_condition-range-low            = lv_low.
      ls_condition-range-high           = ''.

      lv_wherecond-wc = get_condition( EXPORTING is_condition  = ls_condition
                                                 it_wherecond  = lt_wherecond ).
    CATCH zcx_dqf_sign INTO gex_sign.
      gv_message = gex_sign->get_text( ).
      MESSAGE gv_message TYPE 'E'.
    ENDTRY.

    APPEND lv_wherecond TO lt_wherecond.

  ENDLOOP.

ELSE.
  TRY.
    ls_condition-lines                = lv_lines.
    ls_condition-iobjnm               = lv_fieldnm.
    ls_condition-range-sign           = i_ztm_dqf_cases-sign.
    ls_condition-range-option         = i_ztm_dqf_cases-opt.
    ls_condition-range-low            = i_ztm_dqf_cases-low.
    ls_condition-range-high           = i_ztm_dqf_cases-high.

    lv_wherecond-wc = get_condition( EXPORTING is_condition  = ls_condition
                                               it_wherecond  = it_wherecond ).
  CATCH zcx_dqf_sign INTO gex_sign.
    gv_message = gex_sign->get_text( ).
    MESSAGE gv_message TYPE 'E'.
  ENDTRY.

  APPEND lv_wherecond TO lt_wherecond.

ENDIF.
et_wherecond = lt_wherecond.
ENDMETHOD.


METHOD get_testcases.

DATA: lv_s_result_opt    TYPE c LENGTH 2,
      lt_s_wherecond     TYPE tyt_wherecond,
      lt_s_value         TYPE ty_dec_value,
      lv_s_datarows      TYPE ty_dec0,

      lv_t_result_opt    TYPE c LENGTH 2,
      lt_t_wherecond     TYPE tyt_wherecond,
      lt_t_value         TYPE ty_dec_value,
      lv_t_datarows      TYPE ty_dec0,

      lt_case_final      TYPE tyt_grid,
      ls_result          TYPE ty_result,

      ls_s_query         TYPE ty_query_keyfigure,
      ls_t_query         TYPE ty_query_keyfigure.

"Check flag for no entries
DATA(lv_flag) = rs_c_true.

get_type( EXPORTING it_ztm_dqf_cases   = it_ztm_dqf_cases
          IMPORTING et_s_ztm_dqf_cases = DATA(lt_s_ztm_dqf_cases)
                    et_t_ztm_dqf_cases = DATA(lt_t_ztm_dqf_cases) ).

LOOP AT it_nums ASSIGNING FIELD-SYMBOL(<fs_num>).

  "There is a Source / Target to check
  IF lt_s_ztm_dqf_cases[] IS NOT INITIAL.
    "Check if testcase is a source / target case and not only a check case.
    TRY.
      DATA(testcase_is_s_t) = lt_s_ztm_dqf_cases[ num = <fs_num>-num type = 'S' ].
      DATA(ls_s_parameter) = get_parameters( EXPORTING it_ztm_dqf_cases  = lt_s_ztm_dqf_cases
                                                       i_nums            = <fs_num> ).
      create_wherecondition( EXPORTING it_ztm_dqf_cases = lt_s_ztm_dqf_cases
                                       i_parameter      = ls_s_parameter
                                       i_nums           = <fs_num>
                                       it_wherecond     = lt_s_wherecond
                             IMPORTING et_parameter     = DATA(lt_s_parameter_final)
                                       e_counter        = DATA(lv_s_counter)
                                       et_wherecond     = lt_s_wherecond ).
      lv_flag = rs_c_false.
    CATCH cx_sy_itab_line_not_found.
      "This testcase has no source / target case.
    ENDTRY.
  ENDIF.

  IF lt_t_ztm_dqf_cases[] IS NOT INITIAL.
    DATA(ls_t_parameter) = get_parameters( EXPORTING it_ztm_dqf_cases  = lt_t_ztm_dqf_cases
                                                     i_nums            = <fs_num> ).
    create_wherecondition( EXPORTING it_ztm_dqf_cases = lt_t_ztm_dqf_cases
                                     i_parameter      = ls_t_parameter
                                     i_nums           = <fs_num>
                                     it_wherecond     = lt_t_wherecond
                           IMPORTING et_parameter     = DATA(lt_t_parameter_final)
                                     e_counter        = DATA(lv_t_counter)
                                     et_wherecond     = lt_t_wherecond ).
    lv_flag = rs_c_false.
  ENDIF.

  IF lv_flag = rs_c_true.
    RETURN.
  ENDIF.

  "Check for Source Options
  IF lt_s_ztm_dqf_cases[] IS NOT INITIAL.
     TRY.
      testcase_is_s_t = lt_s_ztm_dqf_cases[ num = <fs_num>-num type = 'S' ].
      IF ls_s_parameter-query = ''.
        lt_s_value = prepare_data( EXPORTING i_parameter = ls_s_parameter
                                             it_wherecon = lt_s_wherecond
                                             i_nums      = <fs_num>
                                   IMPORTING e_datarows  = lv_s_datarows ).
      ELSE.
        ls_s_query-counter  = lv_s_counter.
        ls_s_query-parameter = ls_s_parameter.
        lt_s_value = prepare_data_query( EXPORTING i_query            = ls_s_query
                                                   it_parameter_final = lt_s_parameter_final ).
      ENDIF.
    CATCH cx_sy_itab_line_not_found.
      "This testcase has no source / target case.
    ENDTRY.
  ENDIF.

  "Check for Target Options
  IF ls_t_parameter-query = ''.
    lt_t_value = prepare_data( EXPORTING i_parameter = ls_t_parameter
                                         it_wherecon = lt_t_wherecond
                                         i_nums      = <fs_num>
                               IMPORTING e_datarows  = lv_t_datarows ).
  ELSE.
    ls_t_query-counter   = lv_t_counter.
    ls_t_query-parameter = ls_t_parameter.
    lt_t_value = prepare_data_query( EXPORTING i_query            = ls_t_query
                                               it_parameter_final = lt_t_parameter_final ).
  ENDIF.
  ls_result-s_table     = lt_s_value.
  ls_result-s_datarows  = lv_s_datarows.
  ls_result-s_parameter = ls_s_parameter.
  ls_result-nums        = <fs_num>.
  ls_result-t_table     = lt_t_value.
  ls_result-t_datarows  = lv_t_datarows.
  ls_result-t_parameter = ls_t_parameter.
  DATA(lt_case) = get_result( ls_result ).

  APPEND LINES OF lt_case TO lt_case_final.
  "Delete Variable for other Testcases
  CLEAR: lt_s_wherecond, lt_t_wherecond, ls_s_parameter, ls_t_parameter.

ENDLOOP.
et_case = lt_case_final.
ENDMETHOD.


METHOD get_type.

TYPES: tyt_s_ztm_dqf_cases TYPE STANDARD TABLE OF ztm_dqf_cases WITH EMPTY KEY,
       tyt_t_ztm_dqf_cases TYPE STANDARD TABLE OF ztm_dqf_cases WITH EMPTY KEY.

et_s_ztm_dqf_cases = VALUE tyt_s_ztm_dqf_cases( FOR <ls_ztm_dqf_cases> IN it_ztm_dqf_cases
                                                WHERE ( type = 'S' ) ( <ls_ztm_dqf_cases> ) ).

et_t_ztm_dqf_cases = VALUE tyt_t_ztm_dqf_cases( FOR <ls_ztm_dqf_cases> IN it_ztm_dqf_cases
                                                WHERE ( type = 'T' or type = 'C' ) ( <ls_ztm_dqf_cases> ) ).
ENDMETHOD.


METHOD prepare_data.
TRY.
  get_data( EXPORTING i_parameter = i_parameter
                      it_wherecon = it_wherecon
            IMPORTING e_value     = e_value
                      e_datarows  = e_datarows ).
CATCH zcx_dqf_adso INTO gex_adso.
   gv_message = gex_adso->get_text( ).
   MESSAGE gv_message TYPE 'E'.
CATCH cx_sy_dynamic_osql_syntax INTO gex_syntax.
   gv_message = `The Where Condition in Testcase ` && i_nums-num && ` of wp ` && i_nums-wp && ` is incorrect.`.
   MESSAGE gv_message TYPE 'E'.
ENDTRY.
ENDMETHOD.


METHOD PREPARE_DATA_QUERY.

DATA: lv_counter         TYPE int2,
      lt_parameter_final TYPE rrxw3tquery,
      ls_query_keyfigure type ty_query_keyfigure.

lv_counter = i_query-counter + 1.
ls_query_keyfigure-parameter = i_query-parameter.
ls_query_keyfigure-counter   = lv_counter.
DATA(lt_parameter) = get_query_keyfigure( ls_query_keyfigure ).
APPEND LINES OF it_parameter_final TO lt_parameter_final.
APPEND LINES OF lt_parameter TO lt_parameter_final.
e_value = get_query_result( EXPORTING i_parameter  = i_query-parameter
                                      it_parameter = lt_parameter_final ).
ENDMETHOD.


METHOD read_query_definition.

DATA: lt_variable     TYPE rsr_t_variable_definition,
      ls_query_filter TYPE ty_query_filter.

CALL FUNCTION 'RS_VC_GET_QUERY_VIEW_DEF'
  EXPORTING
    i_infoprovider                = i_query-parameter-hcpr
    i_query                       = i_query-parameter-query
  IMPORTING
    e_t_variable_definition       = lt_variable
  EXCEPTIONS
    no_applicable_data            = 1
    invalid_variable_values       = 2
    no_authority                  = 3
    abort                         = 4
    invalid_input                 = 5
    invalid_view                  = 6
    OTHERS                        = 7.

IF sy-subrc EQ 0.
  ls_query_filter-testcase = i_ztm_dqf_cases.
  ls_query_filter-counter  = i_query-counter.
  et_parameter = get_query_filter( EXPORTING it_variable     = lt_variable
                                             i_query_filter  = ls_query_filter ).
ENDIF.

ENDMETHOD.


METHOD read_table.

DATA: wa_testing TYPE ztm_dqf_cases.

TRY.
  wa_testing = it_ztm_dqf_cases[ iobjnm = i_iobjnm
                                 num    = i_nums-num
                                 wp     = i_nums-wp ].

  e_value-value = wa_testing-low.

  IF i_iobjnm = 'ZZ_ADSO' OR i_iobjnm = 'HCPR'.
    e_value-comment = wa_testing-comments.
  ENDIF.

  IF i_iobjnm = 'ZZ_RESULT_' && sy-sysid OR i_iobjnm = 'ZZ_ADSO'.
    e_value-option = wa_testing-opt.
  ENDIF.

CATCH cx_sy_itab_line_not_found.
  e_value-option  = ''.
  e_value-comment = ''.
  e_value-value   = ''.
ENDTRY.

ENDMETHOD.


METHOD run.
**********************************************************************
* Author: T.Meyer, extern, Windhoff Software Services, 03.04.2019
**********************************************************************
*
* Automated Testing of specific testcases which are stored in
* table ztm_dqf_cases. Dokumentation can be get by the author.
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
* 12.09.19 TM Change for multiple testcases with mix of Type Check and
*             Source/Target
**********************************************************************
*&---------------------------------------------------------------------*
"Guten Morgen ... Oh, und falls wir uns nicht mehr sehen, guten Tag, guten Abend und gute Nacht!
TYPES: ty_recipient TYPE STANDARD TABLE OF ty_mailaddress WITH EMPTY KEY.

SELECT *
  FROM ztm_dqf_cases
  INTO TABLE @DATA(lt_testing)
  WHERE wp  IN @i_ap AND
        num IN @i_num.

IF lt_testing[] IS INITIAL.
  WRITE: text-002.
  RETURN.
ENDIF.
SORT lt_testing ASCENDING BY num iobjnm type.

"Get Unique Testcase
SELECT DISTINCT wp,
       num
  FROM ztm_dqf_cases
  INTO TABLE @DATA(lt_nums)
  BYPASSING BUFFER
  WHERE wp  IN @i_ap AND
        num IN @i_num.

SORT lt_nums ASCENDING BY wp num.
DATA(lt_case) = get_testcases( EXPORTING it_nums          = lt_nums
                                         it_ztm_dqf_cases = lt_testing ).

IF i_mail = rs_c_true.
  DATA(lt_recipient) = VALUE ty_recipient( FOR <ls_mail> IN i_mailaddress ( <ls_mail>-low ) ).
  send_mail( EXPORTING i_cases     = lt_case
                       i_recipient = lt_recipient ).
ELSE.
  get_output( lt_case ).
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
  APPEND `Testcase ` && `Expected Result ` && `Result ` && text-007 TO gv_text.
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
ENDCLASS.
