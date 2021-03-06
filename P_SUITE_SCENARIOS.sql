--------------------------------------------------------
--  DDL for Package P_SUITE_SCENARIOS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."P_SUITE_SCENARIOS" IS
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_SSC_CODE NUMBER,
PAR_SSC_CHS_CODE NUMBER,
PAR_SSC_MNEMO VARCHAR2,
PAR_SSC_COMMENT VARCHAR2,
PAR_SSC_CHK_MNEMO VARCHAR2,
PAR_SSC_ITERATOR_CODE NUMBER);
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
par_ssc_chs_code NUMBER,
par_ssc_mnemo VARCHAR2,
par_ssc_comment VARCHAR2,
par_ssc_chk_mnemo VARCHAR2,
par_ssc_iterator_code NUMBER
);
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW(par_code NUMBER);
-----------------------------------------------------------------------------
END P_SUITE_SCENARIOS;

/
