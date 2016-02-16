--------------------------------------------------------
--  DDL for Package Body P_SUITE_SCENARIOS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_SUITE_SCENARIOS" IS
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_SSC_CODE NUMBER,
PAR_SSC_CHS_CODE NUMBER,
PAR_SSC_MNEMO VARCHAR2,
PAR_SSC_COMMENT VARCHAR2,
PAR_SSC_CHK_MNEMO VARCHAR2,
PAR_SSC_ITERATOR_CODE NUMBER)
IS

BEGIN
UPDATE B_SUITE_SCENARIOS
SET 
SSC_CHS_CODE = PAR_SSC_CHS_CODE,
SSC_MNEMO = PAR_SSC_MNEMO,
SSC_COMMENT = PAR_SSC_COMMENT,
SSC_CHK_MNEMO = PAR_SSC_CHK_MNEMO,
SSC_ITERATOR_CODE = PAR_SSC_ITERATOR_CODE
WHERE SSC_CODE = PAR_SSC_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(PAR_FIELD_NAME IN VARCHAR2, PAR_KEY IN NUMBER,
PAR_RESULTS OUT SYS_REFCURSOR)
IS

LC_SELECT VARCHAR2(2000);

BEGIN
LC_SELECT := ' SELECT * FROM B_SUITE_SCENARIOS WHERE '||par_field_name||' = :KEY';
OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value NUMBER)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE B_SUITE_SCENARIOS
set '||PAR_COLUMN||' = :value
where SSC_code = :code' using par_value, par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value VARCHAR2)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE B_SUITE_SCENARIOS
set '||PAR_COLUMN||' = :value
where SSC_code = :code' using par_value, par_code;
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
lc_sql :='select ssc_code,ssc_chs_code,ssc_mnemo,ssc_comment,ssc_chk_mnemo,ssc_iterator_code
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_SUITE_SCENARIOS ) tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
ELSE
lc_sql := 'select ssc_code,ssc_chs_code,ssc_mnemo,ssc_comment,ssc_chk_mnemo,ssc_iterator_code
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_SUITE_SCENARIOS where '||par_find_by_field||'='||par_find_by_value||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
end if;
OPEN RESULT_SET FOR lc_sql;
end GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
par_ssc_chs_code NUMBER,
par_ssc_mnemo VARCHAR2,
par_ssc_comment VARCHAR2,
par_ssc_chk_mnemo VARCHAR2,
par_ssc_iterator_code NUMBER
)
IS
BEGIN
INSERT
INTO B_SUITE_SCENARIOS
(
ssc_chs_code,ssc_mnemo,ssc_comment,ssc_chk_mnemo,ssc_iterator_code
)
VALUES
(
par_ssc_chs_code, par_ssc_mnemo, par_ssc_comment, par_ssc_chk_mnemo, par_ssc_iterator_code
);
END INSERT_ROW;
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW(par_code NUMBER)
IS
BEGIN
DELETE FROM B_SUITE_SCENARIOS WHERE ssc_code = par_code;
END DELETE_ROW;
-----------------------------------------------------------------------------
END P_SUITE_SCENARIOS;

/
