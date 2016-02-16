--------------------------------------------------------
--  DDL for Package Body P_MINMAX_ITERATORS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_MINMAX_ITERATORS" 
IS
PROCEDURE UPDATE_ROW(
    PAR_MMI_CODE           NUMBER,
    PAR_MMI_MNEMO          VARCHAR2,
    PAR_MMI_FIELD          VARCHAR2,
    PAR_MMI_THRESHOLD_FROM NUMBER,
    PAR_MMI_THRESHOLD_TO   NUMBER,
    PAR_MMI_STEP           NUMBER)
IS

BEGIN
  UPDATE b_minmax_iterators
  SET MMI_MNEMO = PAR_MMI_MNEMO, MMI_FIELD = PAR_MMI_FIELD,
    MMI_THRESHOLD_FROM = PAR_MMI_THRESHOLD_FROM, MMI_THRESHOLD_TO = PAR_MMI_THRESHOLD_TO,
    MMI_STEP = PAR_MMI_STEP
  WHERE MMI_CODE = PAR_MMI_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(
    PAR_FIELD_NAME IN VARCHAR2,
    PAR_KEY IN NUMBER,
    PAR_RESULTS OUT SYS_REFCURSOR)
IS

  LC_SELECT VARCHAR2(2000) ;

BEGIN
  LC_SELECT := ' SELECT * FROM b_minmax_iterators WHERE '||par_field_name||' = :KEY';
  OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(
    par_code   NUMBER,
    par_column VARCHAR2,
    par_value  NUMBER)
IS
BEGIN
  EXECUTE IMMEDIATE 'UPDATE b_minmax_iterators
set '||PAR_COLUMN||' = :value
where MMI_code = :code' USING par_value,
  par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(
    par_code   NUMBER,
    par_column VARCHAR2,
    par_value  VARCHAR2)
IS
BEGIN
  EXECUTE IMMEDIATE 'UPDATE b_minmax_iterators
set '||PAR_COLUMN||' = :value
where MMI_code = :code' USING par_value,
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
    'select mmi_code,mmi_mnemo,mmi_field,mmi_threshold_from,mmi_threshold_to,mmi_step
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from b_minmax_iterators ) tbl
where ROWNUM <=
'
    ||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
  ELSE
    lc_sql :=
    'select mmi_code,mmi_mnemo,mmi_field,mmi_threshold_from,mmi_threshold_to,mmi_step
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from b_minmax_iterators where '
    ||par_find_by_field||'='||par_find_by_value||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
  END IF;
  OPEN RESULT_SET FOR lc_sql;
END GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
    par_mmi_mnemo          VARCHAR2,
    par_mmi_field          VARCHAR2,
    par_mmi_threshold_from NUMBER,
    par_mmi_threshold_to   NUMBER,
    par_mmi_step           NUMBER)
IS
BEGIN
  INSERT
  INTO b_minmax_iterators
    (
      mmi_mnemo, mmi_field,
      mmi_threshold_from, mmi_threshold_to,
      mmi_step
    )
    VALUES
    (
      par_mmi_mnemo, par_mmi_field,
      par_mmi_threshold_from, par_mmi_threshold_to,
      par_mmi_step
    ) ;
END INSERT_ROW;
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW
  (
    par_code NUMBER
  )
IS
BEGIN
  DELETE FROM B_MINMAX_ITERATORS WHERE mmi_code = par_code;
END DELETE_ROW;
-----------------------------------------------------------------------------

FUNCTION ITER_NEXT(
    par_iterator_code b_minmax_iterators.mmi_code%type,
    par_chk_code b_checks.chk_code%type,
    par_iterator_id pls_integer)
  RETURN PLS_INTEGER
IS

  li_out pls_integer := 1; -- If returned value is 0, then the iterator has reached end;
  lr_iterator b_minmax_iterators%rowtype;
  ln_next_value b_minmax_check_pars.mcp_threshold%type;
  ln_current_value NUMBER;
  ln_mcp_code b_minmax_check_pars.mcp_code%type;


BEGIN

  -- Get iterator data
  SELECT *
  INTO lr_iterator
  FROM b_minmax_iterators
  WHERE mmi_code = par_iterator_code;
  
  -- Get mcp_code for the check
  select mcp_code into ln_mcp_code from b_minmax_check_pars where mcp_chk_code=par_chk_code;
  
  -- This logic is a bit messy unfortunately
  IF(gcl_iter_value.exists(par_iterator_id) = false) THEN
    gcl_iter_value(par_iterator_id) := lr_iterator.mmi_threshold_from;
    li_out := 1;
  elsif(gcl_iter_value(par_iterator_id) = lr_iterator.mmi_threshold_to) THEN --if at end return 0;
    li_out := 0;
  ELSE
    IF(gcl_iter_value(par_iterator_id) + lr_iterator.mmi_step > lr_iterator.mmi_threshold_to) THEN
      gcl_iter_value(par_iterator_id) := lr_iterator.mmi_threshold_to;
    ELSE
      gcl_iter_value(par_iterator_id) := gcl_iter_value(par_iterator_id) + lr_iterator.mmi_step;
    END IF;
    li_out := 1;
  END IF;

  IF(li_out = 1) THEN
      P_MINMAX_CHECK_PARS.UPDATE_ROW_NVALUE(ln_mcp_code, 'MCP_THRESHOLD', gcl_iter_value(par_iterator_id)) ;
  END IF;

  RETURN li_out;

END;
-----------------------------------------------------------------------------
END P_MINMAX_ITERATORS;

/
