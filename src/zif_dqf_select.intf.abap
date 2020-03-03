interface ZIF_DQF_SELECT
  PUBLIC .

  TYPES: "! <p class="shorttext synchronized" lang="en">Structure of Display Attribute</p>
    BEGIN OF ty_display_attribute,
      chabasnm TYPE rschabasnm,
      attrinm  TYPE rsattrinm,
      attritp  TYPE rsattritp,
    END OF ty_display_attribute .

  TYPES: "! <p class="shorttext synchronized" lang="en">Table of Display Attributes</p>
    tyt_display_attributes TYPE STANDARD TABLE OF ty_display_attribute WITH EMPTY KEY .

  TYPES: "! <p class="shorttext synchronized" lang="en">Structure of Navigation Attribute</p>
    BEGIN OF ty_nav_attribute,
      chanm    TYPE rschanm,
      atrnavnm TYPE rsatrnavnm,
    END OF ty_nav_attribute.

  TYPES: "! <p class="shorttext synchronized" lang="en">Table of Navigation Attributes</p>
    tyt_navigation_attributes TYPE STANDARD TABLE OF ty_nav_attribute WITH EMPTY KEY.

  TYPES: "! <p class="shorttext synchronized" lang="en">Strucutre of InfoObject</p>
    BEGIN OF ty_infoobject,
      iobjnm  TYPE rsdiobjnm,
      fieldnm TYPE rsdiobjnm,
    END OF ty_infoobject .
  TYPES: "! <p class="shorttext synchronized" lang="en">Table of InfoObjects</p>
    tyt_infoobjects TYPE  STANDARD TABLE OF ty_infoobject WITH EMPTY KEY .

  TYPES: "! <p class="shorttext synchronized" lang="en">Conversion Exit with output length</p>
    BEGIN OF ty_conv_char,
      convexit  TYPE convexit,
      outputlen TYPE outputlen,
    END OF ty_conv_char .


  "! <p class="shorttext synchronized" lang="en">Get Navigation Attributes for an InfoObject</p>
  "!
  "! @parameter I_INFOOBJECT | <p class="shorttext synchronized" lang="en">InfoObject</p>
  "! @parameter RT_VALUE     | <p class="shorttext synchronized" lang="en">Return table of navigation attributes</p>
  "! @raising zcx_dqf        | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
  METHODS get_navigation_attributes
    IMPORTING
      !i_infoobject TYPE rsdiobjnm
    RETURNING
      VALUE(rt_value) TYPE tyt_navigation_attributes
    RAISING
      zcx_dqf.

  "! <p class="shorttext synchronized" lang="en"></p>
  "!
  "! @parameter I_DISPLAY_ATTRIBUTE | <p class="shorttext synchronized" lang="en">Display Attribute</p>
  "! @parameter RT_Value            | <p class="shorttext synchronized" lang="en">Return table of display attributes</p>
  "! @raising ZCX_DQF               | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
  METHODS get_display_attributes
    IMPORTING
      !i_display_attribute TYPE rsiobjnm
    RETURNING
      VALUE(rt_value) TYPE tyt_display_attributes
    RAISING
      zcx_dqf .

  "! <p class="shorttext synchronized" lang="en">Get Fieldname for an InfoObject</p>
  "!
  "! @parameter I_INFOOBJECT | <p class="shorttext synchronized" lang="en">Infoobject</p>
  "! @parameter RT_VALUE     | <p class="shorttext synchronized" lang="en">Return table of Infoobjects and Fieldnames</p>
  "! @raising ZCX_DQF        | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
  METHODS get_infoobjects
    IMPORTING
      !i_infoobject TYPE rsiobjnm
    RETURNING
      VALUE(rt_value) TYPE tyt_infoobjects
    RAISING
      zcx_dqf .

  METHODS get_conversion_base_char
    IMPORTING
      !i_infoobject TYPE rsiobjnm
    RETURNING
      VALUE(r_value) TYPE ty_conv_char
    RAISING
      zcx_dqf .

  METHODS get_conversion_characteristic
    IMPORTING
      !i_infoobject TYPE rsiobjnm
    RETURNING
      VALUE(r_value) TYPE rschabasnm
    RAISING
      zcx_dqf .

  METHODS get_dataelement_masterdata
    IMPORTING
      !i_infoobject TYPE rsiobjnm
    RETURNING
      VALUE(r_value) TYPE rschabasnm
    RAISING
      zcx_dqf .

  "! <p class="shorttext synchronized" lang="en">Get Dataelement for Infoobject</p>
  "!
  "! @parameter I_INFOOBJECT | <p class="shorttext synchronized" lang="en">InfoObject</p>
  "! @parameter R_value      | <p class="shorttext synchronized" lang="en">Return Dataelement of InfoObject</p>
  "! @raising ZCX_DQF        | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
  METHODS get_dataelement
    IMPORTING
      !i_infoobject TYPE rsiobjnm
    RETURNING
      VALUE(r_value) TYPE rschabasnm
    RAISING
      zcx_dqf .

  "! <p class="shorttext synchronized" lang="en">Get Dataelement for Keyfigure</p>
  "!
  "! @parameter i_infoobject | <p class="shorttext synchronized" lang="en">InfoOBject</p>
  "! @parameter r_value      | <p class="shorttext synchronized" lang="en">Return Dataelement of KEyfigure</p>
  "! @raising zcx_dqf        | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
  METHODS get_dataelement_keyfigure
    IMPORTING
      !i_infoobject TYPE rsiobjnm
    RETURNING
      VALUE(r_value) TYPE rschabasnm
    RAISING
      zcx_dqf .

  "! <p class="shorttext synchronized" lang="en">Get Datatype for Keyfigure</p>
  "!
  "! @parameter i_keyfigure | <p class="shorttext synchronized" lang="en">Keyfigure</p>
  "! @parameter r_value     | <p class="shorttext synchronized" lang="en">Return Datatype of Keyfigure</p>
  "! @raising zcx_dqf       | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
  METHODS get_datatype_keyfigure
    IMPORTING
      !i_keyfigure TYPE rskyfnm
    RETURNING
      VALUE(r_value) TYPE datatype_d
    RAISING
      zcx_dqf .

  "! <p class="shorttext synchronized" lang="en">Get Datatype for Characteristic</p>
  "!
  "! @parameter i_infoobject | <p class="shorttext synchronized" lang="en">Infoobject</p>
  "! @parameter r_value      | <p class="shorttext synchronized" lang="en">Return Datatype of Characteristic</p>
  "! @raising zcx_dqf        | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
  METHODS get_datatype_characteristic
    IMPORTING
      !i_infoobject TYPE RSIOBJNM
    RETURNING
      VALUE(r_value) TYPE datatype_d
    RAISING
      zcx_dqf .

  "! <p class="shorttext synchronized" lang="en">Check if Table exists</p>
  "!
  "! @parameter i_table | <p class="shorttext synchronized" lang="en">Table</p>
  "! @raising zcx_dqf   | <p class="shorttext synchronized" lang="en">Raise Exception if table not exists</p>
  METHODS check_if_table_exists
    IMPORTING
      !i_table TYPE string
    RAISING
      zcx_dqf .

  "! <p class="shorttext synchronized" lang="en">Get Hierarchy Dataelement</p>
  "!
  "! @parameter i_infoobject | <p class="shorttext synchronized" lang="en">InfoObject</p>
  "! @parameter r_value      | <p class="shorttext synchronized" lang="en">Return hierarchy dataelement</p>
  "! @raising zcx_dqf        | <p class="shorttext synchronized" lang="en">Raise Exception if InfoObject is not found</p>
  METHODS get_dataelement_hierarchy
    IMPORTING
      !i_infoobject TYPE rsiobjnm
    RETURNING
      VALUE(r_value) TYPE rschabasnm
    RAISING
      zcx_dqf .

ENDINTERFACE.
