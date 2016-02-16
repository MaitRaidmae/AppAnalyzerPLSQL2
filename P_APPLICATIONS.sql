--------------------------------------------------------
--  DDL for Package P_APPLICATIONS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."P_APPLICATIONS" 
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
      PAR_APL_AMOUNT         NUMBER) ;
  -----------------------------------------------------------------------------

  PROCEDURE GET_ROWS(
      PAR_FIELD_NAME IN VARCHAR2,
      PAR_KEY IN NUMBER,
      PAR_RESULTS OUT SYS_REFCURSOR) ;
  -----------------------------------------------------------------------------

  PROCEDURE UPDATE_ROW_NVALUE(
      par_code   NUMBER,
      par_column VARCHAR2,
      par_value  NUMBER) ;
  -----------------------------------------------------------------------------

  PROCEDURE UPDATE_ROW_CVALUE(
      par_code   NUMBER,
      par_column VARCHAR2,
      par_value  VARCHAR2) ;
  -----------------------------------------------------------------------------

  PROCEDURE GET_RESULTS_PAGE(
      par_page_nr IN NUMBER,
      par_results_per_page IN NUMBER,
      result_set OUT SYS_REFCURSOR,
      par_where_json CLOB DEFAULT NULL) ;
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
      par_apl_amount         NUMBER) ;
  -----------------------------------------------------------------------------

  PROCEDURE DELETE_ROW(
      par_code NUMBER) ;
  -----------------------------------------------------------------------------
END P_APPLICATIONS;

/
