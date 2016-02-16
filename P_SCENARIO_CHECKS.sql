--------------------------------------------------------
--  DDL for Package P_SCENARIO_CHECKS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."P_SCENARIO_CHECKS" IS
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_SCC_CODE NUMBER,
PAR_SCC_APL_CODE NUMBER,
PAR_SCC_VALUE VARCHAR2,
PAR_SCC_SRN_CODE VARCHAR2,
PAR_SCC_CHK_CODE NUMBER);
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(PAR_FIELD_NAME IN VARCHAR2, PAR_KEY IN NUMBER,
PAR_RESULTS OUT SYS_REFCURSOR);
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value NUMBER);
-----------------------------------------------------------------------------

PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value VARCHAR2);
-----------------------------------------------------------------------------

PROCEDURE GET_RESULTS_PAGE(par_page_nr IN NUMBER, par_results_per_page IN NUMBER,
result_set OUT SYS_REFCURSOR, par_find_by_field VARCHAR2 DEFAULT NULL,
par_find_by_value NUMBER DEFAULT NULL);
-----------------------------------------------------------------------------

PROCEDURE INSERT_ROW(
par_scc_apl_code NUMBER,
par_scc_value VARCHAR2,
par_scc_srn_code VARCHAR2,
par_scc_chk_code NUMBER
);
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW(par_code NUMBER);
-----------------------------------------------------------------------------
END P_SCENARIO_CHECKS;

/
