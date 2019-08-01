*&---------------------------------------------------------------------*
*& Report Z_DQF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_DQF.

DATA: lv_wp              TYPE ztm_dqf_cases-wp,
      lv_num             TYPE int2,
      lv_mail            TYPE c LENGTH 90.

SELECTION-SCREEN BEGIN OF BLOCK b1k2 WITH FRAME TITLE text-001.

SELECT-OPTIONS:  s_wp   FOR lv_wp,
                 s_num  FOR lv_num,
                 s_mail FOR lv_mail.

PARAMETERS:      p_mail AS CHECKBOX DEFAULT ''.

SELECTION-SCREEN END OF BLOCK b1k2.

CALL METHOD z_dqf=>run
  EXPORTING
    i_wp          = s_wp[]
    i_num         = s_num[]
    i_mail        = p_mail
    i_mailaddress = s_mail[].
