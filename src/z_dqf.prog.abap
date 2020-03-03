*&---------------------------------------------------------------------*
*& Report Z_DQF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DQF.

DATA: lv_ap              TYPE ztm_dqf_cases-wp,
      lv_num             TYPE int2,
      lv_mail            TYPE c LENGTH 90,
      ls_breakpoints     type zcl_dqf=>ty_breakpoints.

SELECTION-SCREEN BEGIN OF BLOCK b1k2 WITH FRAME TITLE text-001.

SELECT-OPTIONS:  s_ap   FOR lv_ap,
                 s_num  FOR lv_num,
                 s_mail FOR lv_mail.

SELECTION-SCREEN END OF BLOCK b1k2.

SELECTION-SCREEN BEGIN OF BLOCK b1k1 WITH FRAME TITLE text-002.

PARAMETERS:      p_mail AS CHECKBOX DEFAULT '',
                 p_rskip as checkbox default '',
                 p_ghide as checkbox default ''.

SELECTION-SCREEN END OF BLOCK b1k1.

SELECTION-SCREEN BEGIN OF BLOCK b1k3 WITH FRAME TITLE text-003.

PARAMETERS:      p_wc as checkbox default '',
                 p_re as checkbox default '',
                 p_hi as checkbox default '',
                 p_gc as checkbox default '',
                 p_en as checkbox default '',
                 p_co as CHECKBOX default ''.

SELECTION-SCREEN END OF BLOCK b1k3.

if p_wc EQ 'X'.
    ls_breakpoints-wherecondition = rs_c_true.
endif.
if p_re EQ 'X'.
    ls_breakpoints-result = rs_c_true.
endif.
if p_hi EQ 'X'.
    ls_breakpoints-hierarchy = rs_c_true.
endif.
if p_gc EQ 'X'.
    ls_breakpoints-get_case = rs_c_true.
endif.
if p_en EQ 'X'.
    ls_breakpoints-entries = rs_c_true.
endif.
if p_co EQ 'X'.
    ls_breakpoints-condition = rs_c_true.
endif.

Try.
  data(dqf) = new zcl_dqf( i_workpackage = s_ap[]
                           i_case        = s_num[]
  ).
  dqf->set_breakpoints( ls_breakpoints ).
  dqf->set_green_cases( p_ghide ).
  dqf->set_red_cases( p_rskip ).
  dqf->run( EXPORTING i_mail         = p_mail
                      i_mailaddresses  = s_mail[]
          ).
Catch cx_no_data_found.
  Message 'No data found for selection' TYPE 'I'.
ENDTRY.
