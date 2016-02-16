--------------------------------------------------------
--  DDL for Package Body JAVAFX_CSS_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."JAVAFX_CSS_SYNTH" 
AS

PROCEDURE CSS_SYNTH(
    PAR_CONTROLLER VARCHAR2)
AS

  LC_TABLE VARCHAR2(2000) := CSH.PARENT_TABLE(PAR_CONTROLLER);

  rAppController b_app_controllers%rowtype;

BEGIN

  SELECT *
  INTO rAppController
  FROM B_APP_CONTROLLERS
  WHERE ACO_CONTROLLER                    = PAR_CONTROLLER;

  IF (UPPER(rAppController.ACO_VIEW_TYPE) = 'GRID') THEN
    DOUTLN(GRID_CSS(LC_TABLE));
  ELSIF (UPPER(rAppController.ACO_VIEW_TYPE) = 'TABLE') THEN
    DOUTLN(TABLE_CSS(LC_TABLE));
  END IF;

  FOR rChildren IN JAVAFX_CONTROLLER_SYNTH.cControllerChildren(par_controller)
  LOOP
    IF (UPPER(RCHILDREN.COS_VIEW_TYPE) = 'GRID') THEN
      DOUTLN(GRID_CSS(rChildren.cos_table));
    ELSIF (UPPER(RCHILDREN.COS_VIEW_TYPE) = 'TABLE') THEN
      DOUTLN(TABLE_CSS(rChildren.cos_table));
    END IF;
  END LOOP;

  NULL;
END CSS_SYNTH;
--------------------------------------------------------------------------------
FUNCTION GRID_CSS(
    PAR_TABLE_NAME VARCHAR2)
  RETURN VARCHAR2
IS

  LC_OUT VARCHAR2(32000);

BEGIN

  add_ln(lc_out, '.'||csh.camel_tablename_wob(par_table_name, true)||'Grid {');
  ADD_LN(LC_OUT, '  -fx-padding: 10;');
  ADD_LN(LC_OUT, '  -fx-hgap: 5;');
  ADD_LN(LC_OUT, '  -fx-vgap: 5;');
  ADD_LN(LC_OUT, '  -app-grid-col1-width: 100;');
  ADD_LN(LC_OUT, '  -app-grid-col2-width: 150;');
  ADD_LN(LC_OUT, '}');

  RETURN LC_OUT;
END GRID_CSS;
--------------------------------------------------------------------------------
FUNCTION TABLE_CSS(
    PAR_TABLE_NAME VARCHAR2)
  RETURN VARCHAR2
IS

  LC_OUT VARCHAR2(32000);

BEGIN

  FOR rTabCols IN CSH.cTabCols(PAR_TABLE_NAME)
  LOOP
    ADD_LN(LC_OUT, '.'||csh.camel_tablename_wob(par_Table_name, true)||'Table #'||lower(rTabCols.column_name)||' {');
    ADD_LN(LC_OUT, '  -app-table-col-width: 100.0;');
    ADD_LN(LC_OUT, '  -app-table-col-visible: true;');
    ADD_LN(LC_OUT, '}');
  END LOOP;

  RETURN LC_OUT;
END TABLE_CSS;

END JAVAFX_CSS_SYNTH;

/
