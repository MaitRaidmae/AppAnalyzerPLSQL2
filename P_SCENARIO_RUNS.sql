--------------------------------------------------------
--  DDL for Package P_SCENARIO_RUNS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."P_SCENARIO_RUNS" IS
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_SCR_CODE NUMBER,
PAR_SCR_SSC_CODE NUMBER,
PAR_SCR_SRN_CODE NUMBER,
PAR_SCR_TYPE VARCHAR2);
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
par_scr_ssc_code NUMBER,
par_scr_srn_code NUMBER,
par_scr_type VARCHAR2
);
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW(par_code NUMBER);
-----------------------------------------------------------------------------
END P_SCENARIO_RUNS;

/
