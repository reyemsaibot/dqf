*"* use this source file for your ABAP unit test classes

class ltcl_Read_Table definition deferred.
class zcl_Dqf_Read_Table definition local friends ltcl_Read_Table.

class ltcl_Read_Table definition for testing
  duration short
  risk level harmless.

  private section.
    data:
      f_Cut type ref to zcl_Dqf_Read_Table.  "class under test

    methods: setup.
    methods: teardown.
    methods: get_Parameter_active_table for testing.
    methods: get_Parameter_inbound_table for testing.
    methods: get_parameter_psa_table for testing.
    methods: get_parameter_no_entry for testing.
endclass.       "ztest_Read_Table


class ltcl_Read_Table implementation.

  method setup.
    create object f_Cut.
    f_cut->set_case( '1' ).
    f_cut->set_type( 'C' ).
    f_cut->set_workpackage( 'Z_TEST').
  endmethod.

  method teardown.

  endmethod.


  method get_Parameter_active_table.
    Data: lt_dqf_cases type STANDARD TABLE OF ztm_dqf_cases.

    lt_dqf_cases = VALUE #( ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_ADSO'       low = 'ZTM_05'  type = 'C' opt = 'A' comments = 'TEST Comment')
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_KEYFIGURE'  low = 'ZAMOUNT' type = 'C' )
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_RESULT_W7H' low = '100'     type = 'C' opt = 'EQ')
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_FACTOR'     low = '/-1'     type = 'C' )
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_HCPR'       low = 'ZCP_02'  type = 'C' )
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_QUERY'      low = 'ZQY_01'  type = 'C' )
                          ).

    INSERT ztm_dqf_cases FROM TABLE lt_dqf_cases.

    Data: exp_parameter type zcl_Dqf_Read_Table=>ty_Parameter.
    data rs_Parameter type zcl_Dqf_Read_Table=>ty_Parameter.
    Data ls_keyfigure type rsdiobjnm.


    exp_parameter-table = '/BIC/AZTM_052'.
    Append 'ZAMOUNT' to exp_parameter-keyfigure.

    exp_parameter-result_expected = '100'.
    exp_parameter-result_opt = 'EQ'.
    exp_parameter-factor = '/-1'.
    exp_parameter-hcpr = 'ZCP_02'.
    exp_parameter-query = 'ZQY_01'.
    exp_parameter-comment = 'TEST Comment'.

    rs_Parameter = f_Cut->get_Parameter(  ).

    cl_Abap_Unit_Assert=>assert_Equals( act = rs_Parameter
                                        exp = exp_parameter ).


    delete from ztm_dqf_cases where wp = 'Z_TEST'.

  endmethod.

  method get_Parameter_inbound_table.
    Data: lt_dqf_cases type STANDARD TABLE OF ztm_dqf_cases.

    lt_dqf_cases = VALUE #( ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_ADSO'       low = 'ZTM_05'  type = 'C' opt = 'I' comments = 'TEST Comment')
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_KEYFIGURE'  low = 'ZAMOUNT' type = 'C' )
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_RESULT_W7H' low = '100'     type = 'C' opt = 'EQ')
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_FACTOR'     low = '/-1'     type = 'C' )
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_HCPR'       low = 'ZCP_02'  type = 'C' )
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_QUERY'      low = 'ZQY_01'  type = 'C' )
                          ).

    INSERT ztm_dqf_cases FROM TABLE lt_dqf_cases.

    Data: exp_parameter type zcl_Dqf_Read_Table=>ty_Parameter.
    data rs_Parameter type zcl_Dqf_Read_Table=>ty_Parameter.
    Data ls_keyfigure type rsdiobjnm.


    exp_parameter-table = '/BIC/AZTM_051'.
    Append 'ZAMOUNT' to exp_parameter-keyfigure.

    exp_parameter-result_expected = '100'.
    exp_parameter-result_opt = 'EQ'.
    exp_parameter-factor = '/-1'.
    exp_parameter-hcpr = 'ZCP_02'.
    exp_parameter-query = 'ZQY_01'.
    exp_parameter-comment = 'TEST Comment'.

    Try.
      rs_Parameter = f_Cut->get_Parameter(  ).

      cl_Abap_Unit_Assert=>assert_Equals( act = rs_Parameter
                                          exp = exp_parameter ).
    CATCH cx_rsd_iobj_not_exist.
      cl_abap_unit_assert=>fail( EXPORTING msg = 'FAIL' ).
    Endtry.

    delete from ztm_dqf_cases where wp = 'Z_TEST'.

  endmethod.

  method get_Parameter_psa_table.
    Data: lt_dqf_cases type STANDARD TABLE OF ztm_dqf_cases.

    lt_dqf_cases = VALUE #( ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_ADSO'       low = 'ZTM03'  type = 'C' opt = 'P' comments = 'TEST Comment')
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_KEYFIGURE'  low = 'ZAMOUNT' type = 'C' )
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_RESULT_W7H' low = '100'     type = 'C' opt = 'EQ')
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_FACTOR'     low = '/-1'     type = 'C' )
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_HCPR'       low = 'ZCP_02'  type = 'C' )
                            ( mandt = '001' wp = 'Z_TEST' num = '1' iobjnm = 'ZZ_QUERY'      low = 'ZQY_01'  type = 'C' )
                          ).

    INSERT ztm_dqf_cases FROM TABLE lt_dqf_cases.

    Data: exp_parameter type zcl_Dqf_Read_Table=>ty_Parameter.
    data rs_Parameter type zcl_Dqf_Read_Table=>ty_Parameter.
    Data ls_keyfigure type rsdiobjnm.


    exp_parameter-table = '/BIC/B0000218000'.
    Append 'ZAMOUNT' to exp_parameter-keyfigure.

    exp_parameter-result_expected = '100'.
    exp_parameter-result_opt = 'EQ'.
    exp_parameter-factor = '/-1'.
    exp_parameter-hcpr = 'ZCP_02'.
    exp_parameter-query = 'ZQY_01'.
    exp_parameter-comment = 'TEST Comment'.

    Try.
      rs_Parameter = f_Cut->get_Parameter(  ).

      cl_Abap_Unit_Assert=>assert_Equals( act = rs_Parameter
                                          exp = exp_parameter ).
    CATCH cx_rsd_iobj_not_exist.
      cl_abap_unit_assert=>fail( EXPORTING msg = 'FAIL' ).
    Endtry.

    delete from ztm_dqf_cases where wp = 'Z_TEST'.

  endmethod.

  method get_Parameter_no_entry.
    Data: exp_parameter type zcl_Dqf_Read_Table=>ty_Parameter.
    data rs_Parameter type zcl_Dqf_Read_Table=>ty_Parameter.
    Data ls_keyfigure type rsdiobjnm.


    exp_parameter-table = '/BIC/B0000218000'.
    Append 'ZAMOUNT' to exp_parameter-keyfigure.

    exp_parameter-result_expected = '100'.
    exp_parameter-result_opt = 'EQ'.
    exp_parameter-factor = '/-1'.
    exp_parameter-hcpr = 'ZCP_02'.
    exp_parameter-query = 'ZQY_01'.
    exp_parameter-comment = 'TEST Comment'.

    Try.
      rs_Parameter = f_Cut->get_Parameter(  ).

      cl_Abap_Unit_Assert=>assert_Equals( act = rs_Parameter
                                          exp = exp_parameter ).
    CATCH cx_rsd_iobj_not_exist.
      cl_abap_unit_assert=>fail( EXPORTING msg = 'FAIL' ).
    Endtry.

  endmethod.

endclass.
