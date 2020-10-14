"#autoformat
*&---------------------------------------------------------------------*
*& Report z_dqf_result
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

**********************************************************************
* Author: T.Meyer, https://www.reyemsaibot.com, 17.08.2020
**********************************************************************
*
* Analyze Data Quality Framework Results
*
**********************************************************************
* Change log
**********************************************************************
* 17.08.20 TM initial version
**********************************************************************

REPORT z_dqf_result.

DATA: lv_wp          TYPE ztm_dqf_cases-wp.
DATA: lv_num         TYPE int2.
DATA: lv_timestamp   TYPE timestamp.
DATA: lo_excel       TYPE REF TO zcl_excel.
DATA: lt_dqf_results TYPE zcl_dqf=>ty_t_analyze_result.
DATA: ls_dqf_result  TYPE zcl_dqf=>ty_analyze_result.

SELECTION-SCREEN BEGIN OF BLOCK b1k2 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS:  s_wp   FOR lv_wp,
                 s_num  FOR lv_num,
                 s_time FOR lv_timestamp.

SELECTION-SCREEN END OF BLOCK b1k2.

SELECTION-SCREEN BEGIN OF BLOCK b1k1 WITH FRAME TITLE TEXT-002.

PARAMETERS: p_excel  AS CHECKBOX DEFAULT ''.

SELECTION-SCREEN END OF BLOCK b1k1.

SELECT timestamp,
       status,
       workpackage,
       num,
       expected,
       db_result,
       s_comment,
       s_datarows,
       t_comment,
       t_datarows,
       quote
  FROM ztm_dqf_result
  INTO TABLE @DATA(lt_results)
  WHERE num         IN @s_num
  AND   workpackage IN @s_wp
  AND   timestamp   IN @s_time.

LOOP AT lt_results REFERENCE INTO DATA(ls_result).
  z_utils=>convert_timestamp( EXPORTING i_timestampl = CONV timstmp( ls_result->timestamp )
                              IMPORTING e_date  = ls_dqf_result-date
                                        e_time  = ls_dqf_result-time ).
  ls_dqf_result-status      = ls_result->status.
  ls_dqf_result-workpackage = ls_result->workpackage.
  ls_dqf_result-testcase    = ls_result->num.
  ls_dqf_result-expected    = ls_result->expected.
  ls_dqf_result-result      = ls_result->db_result.
  ls_dqf_result-s_comment   = ls_result->s_comment.
  ls_dqf_result-s_datarows  = ls_result->s_datarows.
  ls_dqf_result-t_comment   = ls_result->t_comment.
  ls_dqf_result-t_datarows  = ls_result->t_datarows.
  ls_dqf_result-quote       = ls_result->quote.
  APPEND ls_dqf_result TO lt_dqf_results.
ENDLOOP.

IF p_excel = rs_c_true.

  lo_excel = NEW #( ).

  lo_excel->output_to_excel( EXPORTING it_table           = lt_dqf_results
                                       iv_sheet_name      = 'Results' ).

ELSE.

  zcl_dqf=>analyze_results( lt_dqf_results ).

ENDIF.
