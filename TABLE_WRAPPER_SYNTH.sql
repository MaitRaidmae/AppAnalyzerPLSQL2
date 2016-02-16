--------------------------------------------------------
--  DDL for Package TABLE_WRAPPER_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."TABLE_WRAPPER_SYNTH" 
IS

  PROCEDURE GENERATE_TABLE_PACKAGE(
      par_table_name VARCHAR2,
      par_new_package PLS_INTEGER DEFAULT 0);
  ------------------------------------------------------------------------------
  FUNCTION GEN_UPDATE_ROW(
      par_table_name VARCHAR2,
      par_type       VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION GEN_GET_ROWS(
      PAR_TABLE_NAME VARCHAR2,
      par_type       VARCHAR2)
    RETURN VARCHAR2;
  --TODO: Add generate get_row_xvalue and get results page functions
  ------------------------------------------------------------------------------
  FUNCTION UPDATE_ROW_NVALUE(
      PAR_TABLE_NAME VARCHAR2,
      par_type       VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION UPDATE_ROW_CVALUE(
      par_table_name VARCHAR2,
      par_type       VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION GET_RESULTS_PAGE(
      par_table_name VARCHAR2,
      par_type       VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION INSERT_ROW(
      par_table_name VARCHAR2,
      par_type       VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION DELETE_ROW(
      par_table_name VARCHAR2,
      par_type       VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION CODE_SEQUENCE(
      par_table_name VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION PRIMARY_KEY_TRIGGER(
      par_table_name VARCHAR2)
    RETURN VARCHAR2;
    ------------------------------------------------------------------------------

  END TABLE_WRAPPER_SYNTH;

/
