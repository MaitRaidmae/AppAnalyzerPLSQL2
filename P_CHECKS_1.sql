--------------------------------------------------------
--  DDL for Package Body P_CHECKS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_CHECKS" 
IS
  -----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
    PAR_CHK_CODE     NUMBER,
    PAR_CHK_MNEMO    VARCHAR2,
    PAR_CHK_TYPE     VARCHAR2,
    PAR_CHK_COMMENT  VARCHAR2,
    PAR_CHK_ACTIVE   NUMBER,
    PAR_CHK_CHS_CODE NUMBER)
IS

BEGIN
  UPDATE B_CHECKS
  SET CHK_MNEMO = PAR_CHK_MNEMO, CHK_TYPE = PAR_CHK_TYPE,
    CHK_COMMENT = PAR_CHK_COMMENT, CHK_ACTIVE = PAR_CHK_ACTIVE,
    CHK_CHS_CODE = PAR_CHK_CHS_CODE
  WHERE CHK_CODE = PAR_CHK_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(
    PAR_FIELD_NAME IN VARCHAR2,
    PAR_KEY IN NUMBER,
    PAR_RESULTS OUT SYS_REFCURSOR)
IS

  LC_SELECT VARCHAR2(2000);

BEGIN
  LC_SELECT := ' SELECT * FROM B_CHECKS WHERE '||par_field_name||' = :KEY';
  OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(
    par_code   NUMBER,
    par_column VARCHAR2,
    par_value  NUMBER)
IS
BEGIN
  EXECUTE IMMEDIATE 'UPDATE B_CHECKS
set '||PAR_COLUMN||' = :value
where CHK_code = :code' USING par_value,
  par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_CVALUE(
    par_code   NUMBER,
    par_column VARCHAR2,
    par_value  VARCHAR2)
IS
BEGIN
  EXECUTE IMMEDIATE 'UPDATE B_CHECKS
set '||PAR_COLUMN||' = :value
where CHK_code = :code' USING par_value,
  par_code;
END UPDATE_ROW_CVALUE;
-----------------------------------------------------------------------------

PROCEDURE GET_RESULTS_PAGE(
    par_page_nr IN NUMBER,
    par_results_per_page IN NUMBER,
    par_result_set OUT SYS_REFCURSOR,
    par_where_json CLOB DEFAULT NULL)
IS
  ln_first_row PLS_INTEGER;
  ln_last_row PLS_INTEGER;
  lc_sql          VARCHAR2(2000);
  lc_where_clause VARCHAR2(2000);
BEGIN
  ln_first_row := par_page_nr * par_results_per_page - (par_results_per_page - 1);
  ln_last_row := par_page_nr * par_results_per_page;
  IF (par_where_json IS NULL) THEN
    lc_sql :=
    'select chk_code,chk_mnemo,chk_type,chk_comment,chk_active,chk_chs_code
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_CHECKS ) tbl
where ROWNUM <=
'
    ||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
  ELSE
    lc_where_clause := JSON_THINGIES.BUILD_WHERE_CLAUSE(par_where_json);
    lc_sql :=
    'select chk_code,chk_mnemo,chk_type,chk_comment,chk_active,chk_chs_code
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_CHECKS '
    ||lc_where_clause||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
  END IF;
  OPEN par_result_set FOR lc_sql;
END GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
    par_chk_mnemo    VARCHAR2,
    par_chk_type     VARCHAR2,
    par_chk_comment  VARCHAR2,
    par_chk_active   NUMBER,
    par_chk_chs_code NUMBER )
IS
BEGIN
  INSERT
  INTO B_CHECKS
    (
      chk_mnemo, chk_type,
      chk_comment, chk_active,
      chk_chs_code
    )
    VALUES
    (
      par_chk_mnemo, par_chk_type,
      par_chk_comment, par_chk_active,
      par_chk_chs_code
    );
END INSERT_ROW;
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW
  (
    par_code NUMBER
  )
IS
BEGIN
  DELETE FROM B_CHECKS WHERE chk_code = par_code;
END DELETE_ROW;
-----------------------------------------------------------------------------
END P_CHECKS;

/
