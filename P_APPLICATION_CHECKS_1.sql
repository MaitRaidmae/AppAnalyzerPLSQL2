--------------------------------------------------------
--  DDL for Package Body P_APPLICATION_CHECKS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_APPLICATION_CHECKS" IS
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(PAR_FIELD_NAME IN VARCHAR2, PAR_KEY IN NUMBER,
PAR_RESULTS OUT SYS_REFCURSOR)
IS

LC_SELECT VARCHAR2(2000);

BEGIN
LC_SELECT := ' SELECT * FROM V_APPLICATION_CHECKS WHERE '||par_field_name||' = :KEY';
OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------
PROCEDURE GET_RESULTS_PAGE(PAR_PAGE_NR IN NUMBER, PAR_RESULTS_PER_PAGE IN  NUMBER,
  RESULT_SET OUT SYS_REFCURSOR, PAR_FIND_BY_FIELD VARCHAR2 DEFAULT NULL, 
  par_find_by_value number default null)
  
IS

ln_first_row    pls_integer;
LN_LAST_ROW     PLS_INTEGER;
lc_sql          varchar2(2000);

BEGIN

ln_first_row := par_page_nr * par_results_per_page - (par_results_per_page - 1);
LN_LAST_ROW := PAR_PAGE_NR * PAR_RESULTS_PER_PAGE;

if (par_find_by_field is null) then
LC_SQL :='select *
  FROM ( SELECT /*+ FIRST_ROWS(n) */ 
  apps.*, ROWNUM rnum 
      from ( select * from v_application_checks ) apps
      where ROWNUM <= 
      '||ln_last_row||' ) 
      WHERE RNUM  >= '||LN_FIRST_ROW;
ELSE
lc_sql := 'select *
  FROM ( SELECT /*+ FIRST_ROWS(n) */ 
  apps.*, ROWNUM rnum 
      from ( select * from v_application_checks where '||par_find_by_field||'='||par_find_by_value||') apps
      where ROWNUM <= 
      '||ln_last_row||' ) 
      WHERE RNUM  >= '||LN_FIRST_ROW;
end if;

OPEN RESULT_SET FOR LC_SQL;

END GET_RESULTS_PAGE;
END P_APPLICATION_CHECKS;

/
