--------------------------------------------------------
--  DDL for Package Body UT_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."UT_UTIL" AS
  PROCEDURE COPY_TEST(OLD_UT_ID IN VARCHAR2, NEW_NAME VARCHAR2) AS
    TYPE mapTyp IS TABLE OF VARCHAR2(40) INDEX BY VARCHAR2(40);
    arg_map mapTyp;
    ut_map mapTyp;
    impl_map mapTyp;
  BEGIN
    for c in (select ut_id from ut_test where ut_id = old_ut_id) loop
      select sys_guid() into ut_map(c.ut_id) from dual;
    end loop;
    for c in (select arg_id from ut_test_arguments where ut_id = old_ut_id) loop
      select sys_guid() into arg_map(c.arg_id) from dual;
    end loop;
    for c in (select uti_id from ut_test_impl where ut_id = old_ut_id) loop
      select sys_guid() into impl_map(c.uti_id) from dual;
    end loop;
    insert into ut_test (SELECT ut_map(old_ut_id),  new_NAME,  OBJECT_NAME,  OBJECT_TYPE,  OBJECT_OWNER,  OBJECT_CALL,  CONNECTION_NAME, COVERAGE, null,  null,null,null FROM UT_TEST where ut_id = old_ut_id);
    for c in (SELECT ARG_ID,  ut_map(old_ut_id) ut_id,  OWNER,  OBJECT_NAME,  PACKAGE_NAME,  OBJECT_ID,  OVERLOAD,  ARGUMENT_NAME,  POSITION,  SEQUENCE,  DATA_LEVEL,  DATA_TYPE,
                                   DEFAULT_LENGTH,  IN_OUT,  DATA_LENGTH,  DATA_PRECISION,  DATA_SCALE,  RADIX,  CHARACTER_SET_NAME,  TYPE_OWNER,  TYPE_NAME,  TYPE_SUBNAME,  TYPE_LINK,
                                   PLS_TYPE,  CHAR_LENGTH,  CHAR_USED FROM UT_TEST_ARGUMENTS where ut_id = OLD_UT_ID) loop
             insert into ut_test_arguments values (arg_map(c.ARG_ID),  c.ut_id,  c.OWNER,  c.OBJECT_NAME,  c.PACKAGE_NAME,  c.OBJECT_ID,  c.OVERLOAD,  c.ARGUMENT_NAME,  c.POSITION,  c.SEQUENCE,  c.DATA_LEVEL,  c.DATA_TYPE,
             c.DEFAULT_LENGTH,  c.IN_OUT,  c.DATA_LENGTH,  c.DATA_PRECISION,  c.DATA_SCALE,  c.RADIX,  c.CHARACTER_SET_NAME,  c.TYPE_OWNER,  c.TYPE_NAME,  c.TYPE_SUBNAME,  c.TYPE_LINK,
             c.PLS_TYPE,  c.CHAR_LENGTH,  c.CHAR_USED,null,null,null,null);
    end loop;
    for s in (SELECT index_no, startup, lib_startup_id FROM ut_startups WHERE ut_id = old_ut_id) loop
        insert into ut_startups (ut_id, index_no, startup, lib_startup_id) values (ut_map(old_ut_id), s.index_no, s.startup, s.lib_startup_id);
    end loop;
    for t in (SELECT index_no, teardown, lib_teardown_id FROM ut_teardowns WHERE ut_id = old_ut_id) loop
        insert into ut_teardowns (ut_id, index_no, teardown, lib_teardown_id) values (ut_map(old_ut_id), t.index_no, t.teardown, t.lib_teardown_id);
    end loop;
    for c in (SELECT UTI_ID,  ut_map(old_ut_id) ut_id,  NAME,  EXPECTED_RETURN,  EXPECTED_RETURN_ERROR,  DYNAMIC_VALUE_QUERY, LIB_DYN_QUERY_ID, null CREATED_ON,  null CREATED_BY FROM UT_TEST_IMPL where ut_id = OLD_UT_ID) loop
      insert into UT_TEST_IMPL values (impl_map(c.UTI_ID), c.ut_id,  c.NAME,  c.EXPECTED_RETURN,  c.EXPECTED_RETURN_ERROR,  c.DYNAMIC_VALUE_QUERY, c.LIB_DYN_QUERY_ID, null,null,null,null);
      for x in (select UTI_ID, ARG_ID, INPUT_VALUE, OUTPUT_VALUE, TEST_OUTVAL FROM UT_TEST_IMPL_ARGUMENTS where uti_id = c.uti_id) loop
        insert into ut_test_impl_arguments (UTI_ID, ARG_ID, INPUT_VALUE, OUTPUT_VALUE, TEST_OUTVAL) values (impl_map(x.UTI_ID), arg_map(x.ARG_ID), x.INPUT_VALUE, x.OUTPUT_VALUE, x.TEST_OUTVAL);
      end loop;
      for x in (select UTI_ID, INDEX_NO, VALIDATION, LIB_VALIDATION_ID, APPLY_VALIDATION FROM UT_VALIDATIONS where uti_id = c.uti_id) loop
        insert into ut_validations (UTI_ID, INDEX_NO, VALIDATION, LIB_VALIDATION_ID, APPLY_VALIDATION) values (impl_map(x.UTI_ID), x.INDEX_NO, x.VALIDATION, x.LIB_VALIDATION_ID, x.APPLY_VALIDATION);
      end loop;
    end loop;
  END COPY_TEST;
END "UT_UTIL";

/
