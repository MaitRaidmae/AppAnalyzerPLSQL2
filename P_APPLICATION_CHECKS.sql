--------------------------------------------------------
--  DDL for Package P_APPLICATION_CHECKS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."P_APPLICATION_CHECKS" IS
-----------------------------------------------------------------------------

PROCEDURE GET_ROWS(PAR_FIELD_NAME IN VARCHAR2, PAR_KEY IN NUMBER,
PAR_RESULTS OUT SYS_REFCURSOR);
-----------------------------------------------------------------------------
PROCEDURE GET_RESULTS_PAGE(PAR_PAGE_NR IN NUMBER, PAR_RESULTS_PER_PAGE IN  NUMBER,
  RESULT_SET OUT SYS_REFCURSOR, PAR_FIND_BY_FIELD VARCHAR2 DEFAULT NULL, 
  PAR_FIND_BY_VALUE NUMBER DEFAULT NULL);
-----------------------------------------------------------------------------
END P_APPLICATION_CHECKS;

/
