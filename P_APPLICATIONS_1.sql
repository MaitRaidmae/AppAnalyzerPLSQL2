--------------------------------------------------------
--  DDL for Package Body P_APPLICATIONS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."P_APPLICATIONS" 
IS
  -----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
    PAR_APL_CODE           NUMBER,
    PAR_APL_NAME           VARCHAR2,
    PAR_APL_INCOME         NUMBER,
    PAR_APL_OBLIGATIONS    NUMBER,
    PAR_APL_RESERVE        NUMBER,
    PAR_APL_DEBT_TO_INCOME NUMBER,
    PAR_APL_AGE            NUMBER,
    PAR_APL_EDUCATION      VARCHAR2,
    PAR_APL_REJECTED       NUMBER,
    PAR_APL_IN_DEFAULT     NUMBER,
    PAR_APL_AMOUNT         NUMBER)
IS

BEGIN
  UPDATE B_APPLICATIONS
  SET APL_NAME = PAR_APL_NAME, APL_INCOME = PAR_APL_INCOME,
    APL_OBLIGATIONS = PAR_APL_OBLIGATIONS, APL_RESERVE = PAR_APL_RESERVE,
    APL_DEBT_TO_INCOME = PAR_APL_DEBT_TO_INCOME, APL_AGE = PAR_APL_AGE,
    APL_EDUCATION = PAR_APL_EDUCATION, APL_REJECTED = PAR_APL_REJECTED,
    APL_IN_DEFAULT = PAR_APL_IN_DEFAULT, APL_AMOUNT = PAR_APL_AMOUNT
  WHERE APL_CODE = PAR_APL_CODE;
END UPDATE_ROW;
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(
    PAR_FIELD_NAME IN VARCHAR2,
    PAR_KEY IN NUMBER,
    PAR_RESULTS OUT SYS_REFCURSOR)
IS

  LC_SELECT VARCHAR2(2000) ;

BEGIN
  LC_SELECT := ' SELECT * FROM B_APPLICATIONS WHERE '||par_field_name||' = :KEY';
  OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;

END GET_ROWS;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(
    par_code   NUMBER,
    par_column VARCHAR2,
    par_value  NUMBER)
IS
BEGIN
  EXECUTE IMMEDIATE 'UPDATE B_APPLICATIONS
set '||PAR_COLUMN||' = :value
where APL_code = :code' USING par_value,
  par_code;
END UPDATE_ROW_NVALUE;
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_CVALUE(
    par_code   NUMBER,
    par_column VARCHAR2,
    par_value  VARCHAR2)
IS
BEGIN
  EXECUTE IMMEDIATE 'UPDATE B_APPLICATIONS
set '||PAR_COLUMN||' = :value
where APL_code = :code' USING par_value,
  par_code;
END UPDATE_ROW_CVALUE;
-----------------------------------------------------------------------------

PROCEDURE GET_RESULTS_PAGE(
    par_page_nr IN NUMBER,
    par_results_per_page IN NUMBER,
    result_set OUT SYS_REFCURSOR,
    par_where_json CLOB DEFAULT NULL)
IS
  ln_first_row PLS_INTEGER;
  ln_last_row PLS_INTEGER;
  lc_sql VARCHAR2(2000) ;
  lc_where_clause varchar2(2000);
  
BEGIN
  ln_first_row := par_page_nr * par_results_per_page -(par_results_per_page - 1) ;
  ln_last_row := par_page_nr * par_results_per_page;
  
  IF(par_where_json IS NULL) THEN
    lc_sql :=
    'select apl_code,apl_name,apl_income,apl_obligations,apl_reserve,apl_debt_to_income,apl_age,apl_education,apl_rejected,apl_in_default,apl_amount
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_APPLICATIONS ) tbl
where ROWNUM <=
'
    ||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
  ELSE
    lc_where_clause := JSON_THINGIES.BUILD_WHERE_CLAUSE(par_where_json);
    lc_sql :=
    'select apl_code,apl_name,apl_income,apl_obligations,apl_reserve,apl_debt_to_income,apl_age,apl_education,apl_rejected,apl_in_default,apl_amount
FROM ( SELECT /*+ FIRST_ROWS(n) */
tbl.*, ROWNUM rnum
from ( select * from B_APPLICATIONS '||lc_where_clause||') tbl
where ROWNUM <=
'||ln_last_row||' )
WHERE RNUM  >= '||LN_FIRST_ROW;
  END IF;
  OPEN RESULT_SET FOR lc_sql;
END GET_RESULTS_PAGE;
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
    par_apl_name           VARCHAR2,
    par_apl_income         NUMBER,
    par_apl_obligations    NUMBER,
    par_apl_reserve        NUMBER,
    par_apl_debt_to_income NUMBER,
    par_apl_age            NUMBER,
    par_apl_education      VARCHAR2,
    par_apl_rejected       NUMBER,
    par_apl_in_default     NUMBER,
    par_apl_amount         NUMBER)
IS
BEGIN
  INSERT
  INTO B_APPLICATIONS
    (
      apl_name, apl_income,
      apl_obligations, apl_reserve,
      apl_debt_to_income, apl_age,
      apl_education, apl_rejected,
      apl_in_default, apl_amount
    )
    VALUES
    (
      par_apl_name, par_apl_income,
      par_apl_obligations, par_apl_reserve,
      par_apl_debt_to_income, par_apl_age,
      par_apl_education, par_apl_rejected,
      par_apl_in_default, par_apl_amount
    ) ;
END INSERT_ROW;
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW
  (
    par_code NUMBER
  )
IS
BEGIN
  DELETE FROM B_APPLICATIONS WHERE apl_code = par_code;
END DELETE_ROW;
-----------------------------------------------------------------------------
END P_APPLICATIONS;

/
