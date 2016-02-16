--------------------------------------------------------
--  DDL for Package Body P_SCENARIO_RUNS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_SCENARIO_RUNS" IS
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_SCR_CODE NUMBER,
PAR_SCR_SSC_CODE NUMBER,
PAR_SCR_SRN_CODE NUMBER,
PAR_SCR_TYPE VARCHAR2)
IS

BEGIN
UPDATE b_scenario_runs
SET 
SCR_SSC_CODE = PAR_SCR_SSC_CODE,
SCR_SRN_CODE = PAR_SCR_SRN_CODE,
SCR_TYPE = PAR_SCR_TYPE
WHERE SCR_CODE = PAR_SCR_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(PAR_FIELD_NAME IN VARCHAR2, PAR_KEY IN NUMBER,
PAR_RESULTS OUT SYS_REFCURSOR)
IS

LC_SELECT VARCHAR2(2000);

BEGIN
LC_SELECT := ' SELECT * FROM b_scenario_runs WHERE '||par_field_name||' = :KEY';
OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value NUMBER)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE b_scenario_runs
set '||PAR_COLUMN||' = :value
where SCR_code = :code' using par_value, par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value VARCHAR2)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE b_scenario_runs
set '||PAR_COLUMN||' = :value
where SCR_code = :code' using par_value, par_code;
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
lc_sql :='select scr_code,scr_ssc_code,scr_srn_code,scr_type
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from b_scenario_runs ) tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
ELSE
lc_sql := 'select scr_code,scr_ssc_code,scr_srn_code,scr_type
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from b_scenario_runs where '||par_find_by_field||'='||par_find_by_value||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
end if;
OPEN RESULT_SET FOR lc_sql;
end GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
par_scr_ssc_code NUMBER,
par_scr_srn_code NUMBER,
par_scr_type VARCHAR2
)
IS
BEGIN
INSERT
INTO b_scenario_runs
(
scr_ssc_code,scr_srn_code,scr_type
)
VALUES
(
par_scr_ssc_code, par_scr_srn_code, par_scr_type
);
END INSERT_ROW;
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW(par_code NUMBER)
IS
BEGIN
DELETE FROM B_SCENARIO_RUNS WHERE scr_code = par_code;
END DELETE_ROW;
-----------------------------------------------------------------------------
END P_SCENARIO_RUNS;

/
