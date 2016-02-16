--------------------------------------------------------
--  DDL for Package Body P_MINMAX_CHECK_PARS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_MINMAX_CHECK_PARS" IS
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_MCP_CODE NUMBER,
PAR_MCP_CHK_CODE NUMBER,
PAR_MCP_THRESHOLD NUMBER,
PAR_MCP_CHECK_FIELD VARCHAR2)
IS

BEGIN
UPDATE B_MINMAX_CHECK_PARS
SET 
MCP_CHK_CODE = PAR_MCP_CHK_CODE,
MCP_THRESHOLD = PAR_MCP_THRESHOLD,
MCP_CHECK_FIELD = PAR_MCP_CHECK_FIELD
WHERE MCP_CODE = PAR_MCP_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(PAR_FIELD_NAME IN VARCHAR2, PAR_KEY IN NUMBER,
PAR_RESULTS OUT SYS_REFCURSOR)
IS

LC_SELECT VARCHAR2(2000);

BEGIN
LC_SELECT := ' SELECT * FROM B_MINMAX_CHECK_PARS WHERE '||par_field_name||' = :KEY';
OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value NUMBER)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE B_MINMAX_CHECK_PARS
set '||PAR_COLUMN||' = :value
where MCP_code = :code' using par_value, par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value VARCHAR2)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE B_MINMAX_CHECK_PARS
set '||PAR_COLUMN||' = :value
where MCP_code = :code' using par_value, par_code;
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
lc_sql :='select mcp_code,mcp_chk_code,mcp_threshold,mcp_check_field
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_MINMAX_CHECK_PARS ) tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
ELSE
lc_sql := 'select mcp_code,mcp_chk_code,mcp_threshold,mcp_check_field
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_MINMAX_CHECK_PARS where '||par_find_by_field||'='||par_find_by_value||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
end if;
OPEN RESULT_SET FOR lc_sql;
end GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
par_mcp_chk_code NUMBER,
par_mcp_threshold NUMBER,
par_mcp_check_field VARCHAR2
)
IS

BEGIN
INSERT
INTO B_MINMAX_CHECK_PARS
(
mcp_chk_code,mcp_threshold,mcp_check_field
)
VALUES
(
par_mcp_chk_code, par_mcp_threshold, par_mcp_check_field
);


END INSERT_ROW;
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW(par_code NUMBER)
IS
BEGIN
DELETE FROM B_MINMAX_CHECK_PARS WHERE mcp_code = par_code;
END DELETE_ROW;
-----------------------------------------------------------------------------
END P_MINMAX_CHECK_PARS;

/
