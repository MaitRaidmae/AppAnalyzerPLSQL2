--------------------------------------------------------
--  DDL for Package Body P_CHECK_SUITS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_CHECK_SUITS" IS
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_CHS_CODE NUMBER,
PAR_CHS_MNEMO VARCHAR2,
PAR_CHS_COMMENT VARCHAR2,
PAR_CHS_DATETIME TIMESTAMP)
IS

BEGIN
UPDATE B_CHECK_SUITS
SET 
CHS_MNEMO = PAR_CHS_MNEMO,
CHS_COMMENT = PAR_CHS_COMMENT,
CHS_DATETIME = PAR_CHS_DATETIME
WHERE CHS_CODE = PAR_CHS_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_CHS_CODE NUMBER,
PAR_CHS_MNEMO VARCHAR2,
PAR_CHS_COMMENT VARCHAR2,
PAR_CHS_DATETIME TIMESTAMP,
par_updated_row out SYS_REFCURSOR)
IS

BEGIN
UPDATE B_CHECK_SUITS
SET 
CHS_MNEMO = PAR_CHS_MNEMO,
CHS_COMMENT = PAR_CHS_COMMENT,
CHS_DATETIME = PAR_CHS_DATETIME
WHERE CHS_CODE = PAR_CHS_CODE;

open par_updated_row for select * from b_check_suits where chs_code=par_chs_code;

END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(PAR_FIELD_NAME IN VARCHAR2, PAR_KEY IN NUMBER,
PAR_RESULTS OUT SYS_REFCURSOR)
IS

LC_SELECT VARCHAR2(2000);

BEGIN
LC_SELECT := ' SELECT * FROM B_CHECK_SUITS WHERE '||par_field_name||' = :KEY';
OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value NUMBER)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE B_CHECK_SUITS
set '||PAR_COLUMN||' = :value
where CHS_code = :code' using par_value, par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_CVALUE(par_code NUMBER, par_column VARCHAR2, par_value VARCHAR2)
IS
BEGIN
EXECUTE IMMEDIATE
'UPDATE B_CHECK_SUITS
set '||PAR_COLUMN||' = :value
where CHS_code = :code' using par_value, par_code;
END UPDATE_ROW_CVALUE;
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
lc_sql :='select chs_code,chs_mnemo,chs_comment,chs_datetime
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_CHECK_SUITS ) tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
ELSE
lc_sql := 'select chs_code,chs_mnemo,chs_comment,chs_datetime
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_CHECK_SUITS where '||par_find_by_field||'='||par_find_by_value||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
end if;
OPEN RESULT_SET FOR lc_sql;
end GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
par_chs_mnemo VARCHAR2,
par_chs_comment VARCHAR2,
par_chs_datetime TIMESTAMP
)
IS
BEGIN
INSERT
INTO B_CHECK_SUITS
(
chs_mnemo,chs_comment,chs_datetime
)
VALUES
(
par_chs_mnemo, par_chs_comment, par_chs_datetime
);
END INSERT_ROW;
-----------------------------------------------------------------------------
PROCEDURE INSERT_ROW(
par_chs_mnemo VARCHAR2,
par_chs_comment VARCHAR2,
par_chs_datetime TIMESTAMP,
par_new_row out SYS_REFCURSOR
)
IS

li_chs_code   b_check_suits.chs_code%type;


BEGIN
INSERT
INTO B_CHECK_SUITS
(
chs_mnemo,chs_comment,chs_datetime
)
VALUES
(
par_chs_mnemo, par_chs_comment, par_chs_datetime
) returning chs_code into li_chs_code;

open par_new_row for select * from b_check_suits where chs_code=li_chs_code;

END INSERT_ROW;
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW(par_code NUMBER)
IS
BEGIN
DELETE FROM B_CHECK_SUITS WHERE chs_code = par_code;
END DELETE_ROW;
-----------------------------------------------------------------------------
END P_CHECK_SUITS;

/
