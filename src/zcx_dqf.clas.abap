CLASS zcx_dqf DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.

  INTERFACES if_t100_dyn_msg .
  INTERFACES if_t100_message .

  DATA table TYPE string.
  DATA num TYPE int2.
  data wp type ztm_dqf_cases-wp.
  data sign type rssign.
  data option type rsoption.
  data iobjnm type rsiobjnm.

  CONSTANTS:
   BEGIN OF zcx_dqf,
    msgid TYPE symsgid VALUE 'ZVB0MC_DQF',
    msgno TYPE symsgno VALUE '001',
    attr1 TYPE scx_attrname VALUE '',
    attr2 TYPE scx_attrname VALUE '',
    attr3 TYPE scx_attrname VALUE '',
    attr4 TYPE scx_attrname VALUE '',
  END OF zcx_dqf.

  CONSTANTS:
   BEGIN OF table_not_found,
    msgid TYPE symsgid VALUE 'ZVB0MC_DQF',
    msgno TYPE symsgno VALUE '002',
    attr1 TYPE scx_attrname VALUE 'TABLE',
    attr2 TYPE scx_attrname VALUE '',
    attr3 TYPE scx_attrname VALUE '',
    attr4 TYPE scx_attrname VALUE '',
  END OF table_not_found.

  CONSTANTS:
   BEGIN OF no_data_found,
    msgid TYPE symsgid VALUE 'ZVB0MC_DQF',
    msgno TYPE symsgno VALUE '003',
    attr1 TYPE scx_attrname VALUE 'NUM',
    attr2 TYPE scx_attrname VALUE 'WP',
    attr3 TYPE scx_attrname VALUE '',
    attr4 TYPE scx_attrname VALUE '',
  END OF no_data_found.

  CONSTANTS:
   BEGIN OF infoobjects_not_exists,
    msgid TYPE symsgid VALUE 'ZVB0MC_DQF',
    msgno TYPE symsgno VALUE '005',
    attr1 TYPE scx_attrname VALUE 'IOBJNM',
    attr2 TYPE scx_attrname VALUE '',
    attr3 TYPE scx_attrname VALUE '',
    attr4 TYPE scx_attrname VALUE '',
  END OF infoobjects_not_exists.

  CONSTANTS:
   BEGIN OF sign_option_not_exists,
    msgid TYPE symsgid VALUE 'ZVB0MC_DQF',
    msgno TYPE symsgno VALUE '006',
    attr1 TYPE scx_attrname VALUE 'SIGN',
    attr2 TYPE scx_attrname VALUE 'OPTION',
    attr3 TYPE scx_attrname VALUE '',
    attr4 TYPE scx_attrname VALUE '',
  END OF sign_option_not_exists.

  METHODS constructor
    IMPORTING
      !textid LIKE if_t100_message=>t100key OPTIONAL
      !previous LIKE previous OPTIONAL
      !table TYPE string OPTIONAL
      !num TYPE int2 OPTIONAL
      !wp type ztm_dqf_cases-wp optional
      !iobjnm type rsiobjnm optional
      !sign type rssign optional
      !option type rsoption OPTIONAL.
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.



CLASS zcx_dqf IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
  CALL METHOD super->constructor
    EXPORTING
      previous = previous.
  CLEAR me->textid.
  IF textid IS INITIAL.
    if_t100_message~t100key = if_t100_message=>default_textid.
  ELSE.
    if_t100_message~t100key = textid.
  ENDIF.
  me->table  = table.
  me->num    = num.
  me->wp     = wp.
  me->iobjnm = iobjnm.
  me->option = option.
  me->sign   = sign.
  ENDMETHOD.
ENDCLASS.
