--------------------------------------------------------
--  DDL for Package JAVAFX_CODE_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."JAVAFX_CODE_SYNTH" IS
  gn_indent_size PLS_INTEGER := 2;
  
  -- define collection type for storing parameters and their
  TYPE gt_type_map IS TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(50);
  gr_par_type_map gt_type_map;
    
  CURSOR cTabCols(p_table_name VARCHAR2) IS
   ( SELECT * FROM user_tab_cols WHERE table_name=upper(p_table_name)
    ) ;
  rTabCols cTabCols%ROWTYPE;

  PROCEDURE DATA_CLASS(par_table_name VARCHAR2); -- Generates java class for the table data
  PROCEDURE DATA_CONSTRUCTOR(par_table_name VARCHAR2); -- Generates the constructor for the class
  PROCEDURE GETTER(par_par_name VARCHAR2, par_table_name VARCHAR2); -- Generates getter functions
  PROCEDURE SETTER(par_par_name VARCHAR2, par_table_name VARCHAR2); -- Generates setter functions
  PROCEDURE TABLE_VIEW(par_table_name VARCHAR2); --Generates TableView XML
  PROCEDURE CONTROLLER_CLASS(par_table_name VARCHAR2); --Generate code for view controller
  FUNCTION CONTROLLER_GET_DATA_TABLE(par_table_name VARCHAR2) RETURN VARCHAR2; -- Generate GetData method for controller
  FUNCTION CONTROLLER_EDIT_HANDLERS(par_table_name VARCHAR2) RETURN VARCHAR2;  -- Generates EditHandlers
  FUNCTION CHECK_BOX_FACTORY(par_table_name VARCHAR2) RETURN VARCHAR2; -- Generates cell factory for booleans
  
  FUNCTION SNAKE_TO_CAMEL(par_string VARCHAR2) RETURN VARCHAR2; -- Makes Snakes out of camels
  
  
end;

/
