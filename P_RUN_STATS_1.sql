--------------------------------------------------------
--  DDL for Package Body P_RUN_STATS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_RUN_STATS" 
IS
  -----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
    PAR_RST_CODE            NUMBER,
    PAR_RST_SRN_CODE        NUMBER,
    PAR_RST_TOTAL_APPLS     NUMBER,
    PAR_RST_TOTAL_AMOUNT    NUMBER,
    PAR_RST_ACCEPTED_APPLS  NUMBER,
    PAR_RST_ACCEPTED_AMOUNT NUMBER)
IS

BEGIN
  UPDATE b_run_stats
  SET RST_SRN_CODE = PAR_RST_SRN_CODE, RST_TOTAL_APPLS = PAR_RST_TOTAL_APPLS,
    RST_TOTAL_AMOUNT = PAR_RST_TOTAL_AMOUNT, RST_ACCEPTED_APPLS = PAR_RST_ACCEPTED_APPLS,
    RST_ACCEPTED_AMOUNT = PAR_RST_ACCEPTED_AMOUNT
  WHERE RST_CODE = PAR_RST_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(
    PAR_FIELD_NAME IN VARCHAR2,
    PAR_KEY IN NUMBER,
    PAR_RESULTS OUT SYS_REFCURSOR)
IS

  LC_SELECT VARCHAR2(2000) ;

BEGIN
  LC_SELECT := ' SELECT * FROM b_run_stats WHERE '||par_field_name||' = :KEY';
  OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(
    par_code   NUMBER,
    par_column VARCHAR2,
    par_value  NUMBER)
IS
BEGIN
  EXECUTE IMMEDIATE 'UPDATE b_run_stats
set '||PAR_COLUMN||' = :value
where RST_code = :code' USING par_value,
  par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(
    par_code   NUMBER,
    par_column VARCHAR2,
    par_value  VARCHAR2)
IS
BEGIN
  EXECUTE IMMEDIATE 'UPDATE b_run_stats
set '||PAR_COLUMN||' = :value
where RST_code = :code' USING par_value,
  par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE GET_RESULTS_PAGE(
    par_page_nr IN NUMBER,
    par_results_per_page IN NUMBER,
    result_set OUT SYS_REFCURSOR,
    par_find_by_field VARCHAR2 DEFAULT NULL,
    par_find_by_value NUMBER DEFAULT NULL)
IS
  ln_first_row PLS_INTEGER;
  ln_last_row PLS_INTEGER;
  lc_sql VARCHAR2(2000) ;
BEGIN
  ln_first_row := par_page_nr * par_results_per_page -(par_results_per_page - 1) ;
  ln_last_row := par_page_nr * par_results_per_page;
  IF(par_find_by_field IS NULL) THEN
    lc_sql :=
    'select rst_code,rst_srn_code,rst_total_appls,rst_total_amount,rst_accepted_appls,rst_accepted_amount
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from b_run_stats ) tbl
where ROWNUM <=
'
    ||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
  ELSE
    lc_sql :=
    'select rst_code,rst_srn_code,rst_total_appls,rst_total_amount,rst_accepted_appls,rst_accepted_amount
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from b_run_stats where '
    ||par_find_by_field||'='||par_find_by_value||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
  END IF;
  OPEN RESULT_SET FOR lc_sql;
END GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
    par_rst_srn_code        NUMBER,
    par_rst_total_appls     NUMBER,
    par_rst_total_amount    NUMBER,
    par_rst_accepted_appls  NUMBER,
    par_rst_accepted_amount NUMBER)
IS
BEGIN
  INSERT
  INTO b_run_stats
    (
      rst_srn_code, rst_total_appls,
      rst_total_amount, rst_accepted_appls,
      rst_accepted_amount
    )
    VALUES
    (
      par_rst_srn_code, par_rst_total_appls,
      par_rst_total_amount, par_rst_accepted_appls,
      par_rst_accepted_amount
    ) ;
END INSERT_ROW;
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW
  (
    par_code NUMBER
  )
IS
BEGIN
  DELETE FROM B_RUN_STATS WHERE rst_code = par_code;
END DELETE_ROW;
-----------------------------------------------------------------------------
END P_RUN_STATS;

/
