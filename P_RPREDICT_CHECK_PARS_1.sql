--------------------------------------------------------
--  DDL for Package Body P_RPREDICT_CHECK_PARS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_RPREDICT_CHECK_PARS" 
IS
  -----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
    PAR_RCP_CODE      NUMBER,
    PAR_RCP_TYPE      VARCHAR2,
    PAR_RCP_THRESHOLD NUMBER,
    PAR_RCP_CHK_CODE  NUMBER,
    PAR_RCP_MODEL     VARCHAR2)
IS

BEGIN
  UPDATE B_RPREDICT_CHECK_PARS
  SET RCP_TYPE   = PAR_RCP_TYPE, RCP_THRESHOLD = PAR_RCP_THRESHOLD, RCP_CHK_CODE = PAR_RCP_CHK_CODE, RCP_MODEL = PAR_RCP_MODEL
  WHERE RCP_CODE = PAR_RCP_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(
    PAR_FIELD_NAME IN VARCHAR2,
    PAR_KEY        IN NUMBER,
    PAR_RESULTS OUT SYS_REFCURSOR)
IS

  LC_SELECT VARCHAR2(2000);

BEGIN
  LC_SELECT := ' SELECT * FROM B_RPREDICT_CHECK_PARS WHERE '||par_field_name||' = :KEY';
  OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(
    par_code   NUMBER,
    par_column VARCHAR2,
    par_value  NUMBER)
IS
BEGIN
  EXECUTE IMMEDIATE 'UPDATE B_RPREDICT_CHECK_PARS
set '||PAR_COLUMN||' = :value
where RCP_code = :code' USING par_value,
  par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(
    par_code   NUMBER,
    par_column VARCHAR2,
    par_value  VARCHAR2)
IS
BEGIN
  EXECUTE IMMEDIATE 'UPDATE B_RPREDICT_CHECK_PARS
set '||PAR_COLUMN||' = :value
where RCP_code = :code' USING par_value,
  par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE GET_RESULTS_PAGE(
    par_page_nr          IN NUMBER,
    par_results_per_page IN NUMBER,
    result_set OUT SYS_REFCURSOR,
    par_find_by_field VARCHAR2 DEFAULT NULL,
    par_find_by_value NUMBER DEFAULT NULL)
IS
  ln_first_row PLS_INTEGER;
  ln_last_row PLS_INTEGER;
  lc_sql VARCHAR2(2000);
BEGIN
  ln_first_row          := par_page_nr * par_results_per_page - (par_results_per_page - 1);
  ln_last_row           := par_page_nr * par_results_per_page;
  IF (par_find_by_field IS NULL) THEN
    lc_sql              :='select rcp_code,rcp_type,rcp_threshold,rcp_chk_code,rcp_model
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_RPREDICT_CHECK_PARS ) tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
  ELSE
    lc_sql := 'select rcp_code,rcp_type,rcp_threshold,rcp_chk_code,rcp_model
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_RPREDICT_CHECK_PARS where '||par_find_by_field||'='||par_find_by_value||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
  END IF;
  OPEN RESULT_SET FOR lc_sql;
END GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
    par_rcp_type      VARCHAR2,
    par_rcp_threshold NUMBER,
    par_rcp_chk_code  NUMBER,
    par_rcp_model     VARCHAR2 )
IS
BEGIN
  INSERT
  INTO B_RPREDICT_CHECK_PARS
    (
      rcp_type, rcp_threshold, rcp_chk_code, rcp_model
    )
    VALUES
    (
      par_rcp_type, par_rcp_threshold, par_rcp_chk_code, par_rcp_model
    );
END INSERT_ROW;
-----------------------------------------------------------------------------
END P_RPREDICT_CHECK_PARS;

/
