--------------------------------------------------------
--  DDL for Package P_SCENARIO_CHECK_PARS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."P_SCENARIO_CHECK_PARS" 
IS
  -----------------------------------------------------------------------------
  PROCEDURE UPDATE_ROW(
      PAR_SCP_CODE      NUMBER,
      PAR_SCP_CHK_MNEMO VARCHAR2,
      PAR_SCP_CHK_TYPE  VARCHAR2,
      PAR_SCP_PAR_NAME  VARCHAR2,
      PAR_SCP_PAR_VALUE VARCHAR2,
      PAR_SCP_SRN_CODE  NUMBER,
      PAR_SCP_SSC_CODE  NUMBER,
      PAR_SCP_TYPE      VARCHAR2);
  -----------------------------------------------------------------------------

  PROCEDURE GET_ROWS(
      PAR_FIELD_NAME IN VARCHAR2,
      PAR_KEY        IN NUMBER,
      PAR_RESULTS OUT SYS_REFCURSOR);
  -----------------------------------------------------------------------------

  PROCEDURE UPDATE_ROW_NVALUE(
      par_code   NUMBER,
      par_column VARCHAR2,
      par_value  NUMBER);
  -----------------------------------------------------------------------------

  PROCEDURE UPDATE_ROW_NVALUE(
      par_code   NUMBER,
      par_column VARCHAR2,
      par_value  VARCHAR2);
  -----------------------------------------------------------------------------

  PROCEDURE GET_RESULTS_PAGE(
      par_page_nr          IN NUMBER,
      par_results_per_page IN NUMBER,
      result_set OUT SYS_REFCURSOR,
      par_find_by_field VARCHAR2 DEFAULT NULL,
      par_find_by_value NUMBER DEFAULT NULL);
  -----------------------------------------------------------------------------

  PROCEDURE INSERT_ROW(
      par_scp_chk_mnemo VARCHAR2,
      par_scp_chk_type  VARCHAR2,
      par_scp_par_name  VARCHAR2,
      par_scp_par_value VARCHAR2,
      par_scp_srn_code  NUMBER,
      par_scp_ssc_code  NUMBER,
      par_scp_type      VARCHAR2 );
  -----------------------------------------------------------------------------

  PROCEDURE DELETE_ROW(
      par_code NUMBER);
  -----------------------------------------------------------------------------
END P_SCENARIO_CHECK_PARS;

/
