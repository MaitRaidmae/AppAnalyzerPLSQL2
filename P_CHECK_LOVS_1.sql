--------------------------------------------------------
--  DDL for Package Body P_CHECK_LOVS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_CHECK_LOVS" IS
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_CLV_CODE NUMBER,
PAR_CLV_VALUE VARCHAR2,
PAR_CLV_LCP_CODE NUMBER)
IS

BEGIN
UPDATE B_CHECK_LOVS
SET 
CLV_VALUE = PAR_CLV_VALUE,
CLV_LCP_CODE = PAR_CLV_LCP_CODE
WHERE CLV_CODE = PAR_CLV_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(PAR_FIELD_NAME IN VARCHAR2, PAR_KEY IN NUMBER,
PAR_RESULTS OUT SYS_REFCURSOR)
IS

LC_SELECT VARCHAR2(2000);

BEGIN
LC_SELECT := ' SELECT * FROM B_CHECK_LOVS WHERE '||par_field_name||' = :KEY';
OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value NUMBER)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE B_CHECK_LOVS
set '||PAR_COLUMN||' = :value
where CLV_code = :code' using par_value, par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value VARCHAR2)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE B_CHECK_LOVS
set '||PAR_COLUMN||' = :value
where CLV_code = :code' using par_value, par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE GET_RESULTS_PAGE(par_page_nr IN NUMBER, par_results_per_page IN NUMBER,
result_set OUT SYS_REFCURSOR, par_find_by_field VARCHAR2 DEFAULT NULL,
par_find_by_value NUMBER DEFAULT NULL)
IS
ln_first_row    PLS_INTEGER;
ln_last_row     PLS_INTEGER;
lc_sql          VARCHAR2(2000);
BEGIN
ln_first_row := par_page_nr * par_results_per_page - (par_results_per_page - 1);
ln_last_row := par_page_nr * par_results_per_page;
if (par_find_by_field is null) then
lc_sql :='select clv_code,clv_value,clv_lcp_code
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_CHECK_LOVS ) tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
ELSE
lc_sql := 'select clv_code,clv_value,clv_lcp_code
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_CHECK_LOVS where '||par_find_by_field||'='||par_find_by_value||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
end if;
OPEN RESULT_SET FOR lc_sql;
end GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
par_clv_value VARCHAR2,
par_clv_lcp_code NUMBER
)
IS
BEGIN
INSERT
INTO B_CHECK_LOVS
(
clv_value,clv_lcp_code
)
VALUES
(
par_clv_value, par_clv_lcp_code
);
END INSERT_ROW;
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW(par_code NUMBER)
IS
BEGIN
DELETE FROM B_CHECK_LOVS WHERE clv_code = par_code;
END DELETE_ROW;
-----------------------------------------------------------------------------
END P_CHECK_LOVS;

/
