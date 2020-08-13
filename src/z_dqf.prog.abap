"#autoformat
*&---------------------------------------------------------------------*
*& Report Z_DQF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_dqf.

DATA: lv_ap          TYPE ztm_dqf_cases-wp,
      lv_num         TYPE int2,
      lv_mail        TYPE c LENGTH 90,
      ls_breakpoints TYPE zcl_dqf=>ty_breakpoints.

SELECTION-SCREEN BEGIN OF BLOCK b1k2 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS:  s_ap   FOR lv_ap,
                 s_num  FOR lv_num,
                 s_mail FOR lv_mail.

SELECTION-SCREEN END OF BLOCK b1k2.

SELECTION-SCREEN BEGIN OF BLOCK b1k1 WITH FRAME TITLE TEXT-002.

PARAMETERS: p_mail  AS CHECKBOX DEFAULT '',
            p_rskip AS CHECKBOX DEFAULT '',
            p_ghide AS CHECKBOX DEFAULT '',
            p_save  AS CHECKBOX DEFAULT ''.

SELECTION-SCREEN END OF BLOCK b1k1.

SELECTION-SCREEN BEGIN OF BLOCK b1k3 WITH FRAME TITLE TEXT-003.

PARAMETERS: p_wc AS CHECKBOX DEFAULT '',
            p_re AS CHECKBOX DEFAULT '',
            p_hi AS CHECKBOX DEFAULT '',
            p_gc AS CHECKBOX DEFAULT '',
            p_en AS CHECKBOX DEFAULT '',
            p_co AS CHECKBOX DEFAULT ''.

SELECTION-SCREEN END OF BLOCK b1k3.

IF p_wc EQ 'X'.
  ls_breakpoints-wherecondition = rs_c_true.
ENDIF.
IF p_re EQ 'X'.
  ls_breakpoints-result = rs_c_true.
ENDIF.
IF p_hi EQ 'X'.
  ls_breakpoints-hierarchy = rs_c_true.
ENDIF.
IF p_gc EQ 'X'.
  ls_breakpoints-get_case = rs_c_true.
ENDIF.
IF p_en EQ 'X'.
  ls_breakpoints-entries = rs_c_true.
ENDIF.
IF p_co EQ 'X'.
  ls_breakpoints-condition = rs_c_true.
ENDIF.

TRY.
    DATA(dqf) = NEW zcl_dqf( ir_workpackage = s_ap[]
                             ir_case        = s_num[] ).
    dqf->set_breakpoints( ls_breakpoints ).
    dqf->set_green_cases( p_ghide ).
    dqf->set_red_cases( p_rskip ).
    dqf->set_save_result( p_save ).
    dqf->run( EXPORTING iv_mail         = p_mail
                        ir_mailaddresses  = s_mail[] ).


  CATCH cx_no_data_found.
    MESSAGE 'No data found for selection' TYPE 'I'.
ENDTRY.
