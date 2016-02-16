--------------------------------------------------------
--  DDL for Package P_CHECKS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."P_CHECKS" 
IS
  -----------------------------------------------------------------------------
  PROCEDURE UPDATE_ROW(
      PAR_CHK_CODE     NUMBER,
      PAR_CHK_MNEMO    VARCHAR2,
      PAR_CHK_TYPE     VARCHAR2,
      PAR_CHK_COMMENT  VARCHAR2,
      PAR_CHK_ACTIVE   NUMBER,
      PAR_CHK_CHS_CODE NUMBER);
  -----------------------------------------------------------------------------

  PROCEDURE GET_ROWS(
      PAR_FIELD_NAME IN VARCHAR2,
      PAR_KEY IN NUMBER,
      PAR_RESULTS OUT SYS_REFCURSOR);
  -----------------------------------------------------------------------------

  PROCEDURE UPDATE_ROW_NVALUE(
      par_code   NUMBER,
      par_column VARCHAR2,
      par_value  NUMBER);
  -----------------------------------------------------------------------------

  PROCEDURE UPDATE_ROW_CVALUE(
      par_code   NUMBER,
      par_column VARCHAR2,
      par_value  VARCHAR2);
  -----------------------------------------------------------------------------

  PROCEDURE GET_RESULTS_PAGE(
      par_page_nr IN NUMBER,
      par_results_per_page IN NUMBER,
      par_result_set OUT SYS_REFCURSOR,
      par_where_json CLOB DEFAULT NULL);
  -----------------------------------------------------------------------------

  PROCEDURE INSERT_ROW(
      par_chk_mnemo    VARCHAR2,
      par_chk_type     VARCHAR2,
      par_chk_comment  VARCHAR2,
      par_chk_active   NUMBER,
      par_chk_chs_code NUMBER );
  -----------------------------------------------------------------------------

  PROCEDURE DELETE_ROW(
      par_code NUMBER);
  -----------------------------------------------------------------------------
END P_CHECKS;

/
