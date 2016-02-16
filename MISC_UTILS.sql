--------------------------------------------------------
--  DDL for Package MISC_UTILS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."MISC_UTILS" 
AS

type GT_LOV_VC2
IS
  TABLE OF       VARCHAR2(100);
  gc_output_mode VARCHAR2(100) DEFAULT 'DBMS_OUTPUT';
  gc_output_directory   VARCHAR2(100);
  gf_output_file utl_file.file_type;
  
  ------------------------------------------------------------------------------
  FUNCTION CONSTRAINT_LOV(
      par_owner      VARCHAR2,
      par_table_name VARCHAR2,
      par_field_name VARCHAR2)
    RETURN GT_LOV_VC2 PIPELINED;
  ------------------------------------------------------------------------------
  PROCEDURE GENERATE_PRETTY_NAMES(
      par_table_name VARCHAR2);
  ------------------------------------------------------------------------------
  FUNCTION PRETTY_NAME(
      PAR_TABLE_NAME  VARCHAR2,
      PAR_COLUMN_NAME VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  PROCEDURE TABLE_COLS(
      par_table_name IN VARCHAR2,
      par_results OUT SYS_REFCURSOR);
  ------------------------------------------------------------------------------
  PROCEDURE TABLE_COL_LOV(
      par_owner       VARCHAR2,
      par_table_name  VARCHAR2,
      par_field_name  VARCHAR2,
      par_constraint1 VARCHAR2 DEFAULT NULL,
      par_constraint2 VARCHAR2 DEFAULT NULL,
      par_constraint3 VARCHAR2 DEFAULT NULL,
      par_results OUT SYS_REFCURSOR);
  ------------------------------------------------------------------------------
  FUNCTION TEST_FUN
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  -- Output mode can be either 'FILE' or 'DBMS_OUTPUT' for doutln procedure;
  PROCEDURE SET_OUTPUT_MODE(
      par_mode VARCHAR2);
  ------------------------------------------------------------------------------
  PROCEDURE SET_OUTPUT_PARS(
      par_mode      VARCHAR2,
      par_directory VARCHAR2,
      par_file utl_file.file_type);
  ------------------------------------------------------------------------------
END MISC_UTILS;

/
