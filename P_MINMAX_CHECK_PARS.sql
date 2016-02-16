--------------------------------------------------------
--  DDL for Package P_MINMAX_CHECK_PARS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."P_MINMAX_CHECK_PARS" IS
-----------------------------------------------------------------------------
PROCEDURE UPDATE_ROW(
PAR_MCP_CODE NUMBER,
PAR_MCP_CHK_CODE NUMBER,
PAR_MCP_THRESHOLD NUMBER,
PAR_MCP_CHECK_FIELD VARCHAR2);
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
par_mcp_chk_code NUMBER,
par_mcp_threshold NUMBER,
par_mcp_check_field VARCHAR2
);
-----------------------------------------------------------------------------

PROCEDURE DELETE_ROW(par_code NUMBER);
-----------------------------------------------------------------------------
END P_MINMAX_CHECK_PARS;

/
