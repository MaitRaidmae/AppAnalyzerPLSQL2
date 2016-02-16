--------------------------------------------------------
--  DDL for Package JAVAFX_CSS_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."JAVAFX_CSS_SYNTH" 
AS

  PROCEDURE CSS_SYNTH(
      PAR_CONTROLLER VARCHAR2);
  ------------------------------------------------------------------------------
  FUNCTION GRID_CSS(
      PAR_TABLE_NAME VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION TABLE_CSS(
      PAR_TABLE_NAME VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
END JAVAFX_CSS_SYNTH;

/
