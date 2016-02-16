--------------------------------------------------------
--  DDL for Package CODE_SYNTH_HELPERS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."CODE_SYNTH_HELPERS" 
IS

  SUBTYPE gt_identifier IS VARCHAR2(200) ;
  -- define collection type for storing parameters and their
TYPE gt_type_map
IS
  TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(50) ;
  gr_par_type_map gt_type_map;
  ------------------------------------------------------------------------------
  CURSOR cTabCols(p_table_name VARCHAR2)
  IS
    (SELECT *
    FROM user_tab_cols
    WHERE table_name = upper(p_table_name)
    AND Column_id IS NOT NULL
    ) ;
  rTabCols cTabCols%ROWTYPE;
  ------------------------------------------------------------------------------
  CURSOR cControllerChildren(p_controller VARCHAR2)
  IS
    (SELECT *
    FROM b_controller_siblings
    WHERE cos_aco_code =
      (SELECT aco_code
      FROM b_app_controllers
      WHERE aco_controller = p_controller
      AND cos_type = 'CHILD'
      )
    ) ;
    ------------------------------------------------------------------------------
    PROCEDURE MAP_PARS(
        par_table_name VARCHAR2) ;
    ------------------------------------------------------------------------------
    FUNCTION SNAKE_TO_CAMEL(
        par_string     VARCHAR2,
        par_lower_init BOOLEAN DEFAULT false)
      RETURN VARCHAR2;
    ------------------------------------------------------------------------------
    FUNCTION COL_TAG(
        par_fxid VARCHAR2,
        par_text VARCHAR2)
      RETURN XMLTYPE;
    ------------------------------------------------------------------------------
    PROCEDURE ADD_LN(
        par_clob IN OUT NOCOPY CLOB,
        par_string2 IN VARCHAR2) ;
    ------------------------------------------------------------------------------
    FUNCTION CAMEL_TABLENAME_WOB(
        par_table_name VARCHAR2,
        par_lower_init BOOLEAN DEFAULT false)
      RETURN VARCHAR2;
    ------------------------------------------------------------------------------
    FUNCTION TABLE_PAR_LIST(
        par_table_name    VARCHAR2,
        par_variable_name VARCHAR2)
      RETURN VARCHAR2;
    ------------------------------------------------------------------------------
    FUNCTION COL_LIST(
        par_table_name VARCHAR2,
        par_wo_key     BOOLEAN DEFAULT false)
      RETURN VARCHAR2;
    ------------------------------------------------------------------------------
    FUNCTION IS_BOOLEAN_COLUMN(
        par_table_name  VARCHAR2,
        par_column_name VARCHAR2)
      RETURN PLS_INTEGER;
    ------------------------------------------------------------------------------
    FUNCTION GET_TABLE_PREFIX(
        PAR_TABLE_NAME VARCHAR2)
      RETURN VARCHAR2;
    ------------------------------------------------------------------------------
    FUNCTION PAR_NAME_WO_IDENTIFIER(
        PAR_PAR_NAME VARCHAR2)
      RETURN VARCHAR2;
    ------------------------------------------------------------------------------
    /** Function returns true if the column has LOV type constraint.
    *
    *
    */
    FUNCTION IS_LOV_COLUMN(
        par_table_name  VARCHAR2,
        par_column_name VARCHAR2)
      RETURN PLS_INTEGER;
    ------------------------------------------------------------------------------
    FUNCTION PARENT_TABLE(
        PAR_CONTROLLER VARCHAR2)
      RETURN VARCHAR2;
    ------------------------------------------------------------------------------
    FUNCTION CAMEL_TO_SNAKE(
        par_input VARCHAR2)
      RETURN VARCHAR2;

  END code_synth_helpers;

/
