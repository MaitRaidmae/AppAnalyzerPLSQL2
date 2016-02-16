--------------------------------------------------------
--  DDL for Package P_RUN_STATS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."P_RUN_STATS" 
IS
  -----------------------------------------------------------------------------
  PROCEDURE UPDATE_ROW(
      PAR_RST_CODE            NUMBER,
      PAR_RST_SRN_CODE        NUMBER,
      PAR_RST_TOTAL_APPLS     NUMBER,
      PAR_RST_TOTAL_AMOUNT    NUMBER,
      PAR_RST_ACCEPTED_APPLS  NUMBER,
      PAR_RST_ACCEPTED_AMOUNT NUMBER) ;
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

  PROCEDURE UPDATE_ROW_NVALUE(
      par_code   NUMBER,
      par_column VARCHAR2,
      par_value  VARCHAR2) ;
  -----------------------------------------------------------------------------

  PROCEDURE GET_RESULTS_PAGE(
      par_page_nr IN NUMBER,
      par_results_per_page IN NUMBER,
      result_set OUT SYS_REFCURSOR,
      par_find_by_field VARCHAR2 DEFAULT NULL,
      par_find_by_value NUMBER DEFAULT NULL) ;
  -----------------------------------------------------------------------------

  PROCEDURE INSERT_ROW(
      par_rst_srn_code        NUMBER,
      par_rst_total_appls     NUMBER,
      par_rst_total_amount    NUMBER,
      par_rst_accepted_appls  NUMBER,
      par_rst_accepted_amount NUMBER) ;
  -----------------------------------------------------------------------------

  PROCEDURE DELETE_ROW(
      par_code NUMBER) ;
  -----------------------------------------------------------------------------
END P_RUN_STATS;

/
