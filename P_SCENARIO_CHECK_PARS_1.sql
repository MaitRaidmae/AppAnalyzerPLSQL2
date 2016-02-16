--------------------------------------------------------
--  DDL for Package Body P_SCENARIO_CHECK_PARS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_SCENARIO_CHECK_PARS" IS
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_SCP_CODE NUMBER,
PAR_SCP_CHK_MNEMO VARCHAR2,
PAR_SCP_CHK_TYPE VARCHAR2,
PAR_SCP_PAR_NAME VARCHAR2,
PAR_SCP_PAR_VALUE VARCHAR2,
PAR_SCP_SRN_CODE NUMBER,
PAR_SCP_SSC_CODE NUMBER,
PAR_SCP_TYPE VARCHAR2)
IS

BEGIN
UPDATE B_SCENARIO_CHECK_PARS
SET 
SCP_CHK_MNEMO = PAR_SCP_CHK_MNEMO,
SCP_CHK_TYPE = PAR_SCP_CHK_TYPE,
SCP_PAR_NAME = PAR_SCP_PAR_NAME,
SCP_PAR_VALUE = PAR_SCP_PAR_VALUE,
SCP_SRN_CODE = PAR_SCP_SRN_CODE,
SCP_SSC_CODE = PAR_SCP_SSC_CODE,
SCP_TYPE = PAR_SCP_TYPE
WHERE SCP_CODE = PAR_SCP_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(PAR_FIELD_NAME IN VARCHAR2, PAR_KEY IN NUMBER,
PAR_RESULTS OUT SYS_REFCURSOR)
IS

LC_SELECT VARCHAR2(2000);

BEGIN
LC_SELECT := ' SELECT * FROM B_SCENARIO_CHECK_PARS WHERE '||par_field_name||' = :KEY';
OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value NUMBER)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE B_SCENARIO_CHECK_PARS
set '||PAR_COLUMN||' = :value
where SCP_code = :code' using par_value, par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value VARCHAR2)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE B_SCENARIO_CHECK_PARS
set '||PAR_COLUMN||' = :value
where SCP_code = :code' using par_value, par_code;
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
lc_sql :='select scp_code,scp_chk_mnemo,scp_chk_type,scp_par_name,scp_par_value,scp_srn_code,scp_ssc_code,scp_type
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_SCENARIO_CHECK_PARS ) tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
ELSE
lc_sql := 'select scp_code,scp_chk_mnemo,scp_chk_type,scp_par_name,scp_par_value,scp_srn_code,scp_ssc_code,scp_type
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_SCENARIO_CHECK_PARS where '||par_find_by_field||'='||par_find_by_value||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
end if;
OPEN RESULT_SET FOR lc_sql;
end GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
par_scp_chk_mnemo VARCHAR2,
par_scp_chk_type VARCHAR2,
par_scp_par_name VARCHAR2,
par_scp_par_value VARCHAR2,
par_scp_srn_code NUMBER,
par_scp_ssc_code NUMBER,
par_scp_type VARCHAR2
)
IS
BEGIN
INSERT
INTO B_SCENARIO_CHECK_PARS
(
scp_chk_mnemo,scp_chk_type,scp_par_name,scp_par_value,scp_srn_code,scp_ssc_code,scp_type
)
VALUES
(
par_scp_chk_mnemo, par_scp_chk_type, par_scp_par_name, par_scp_par_value, par_scp_srn_code, par_scp_ssc_code, par_scp_type
);
END INSERT_ROW;
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW(par_code NUMBER)
IS
BEGIN
DELETE FROM B_SCENARIO_CHECK_PARS WHERE scp_code = par_code;
END DELETE_ROW;
-----------------------------------------------------------------------------
END P_SCENARIO_CHECK_PARS;

/
