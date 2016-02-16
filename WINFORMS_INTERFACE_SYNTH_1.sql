--------------------------------------------------------
--  DDL for Package Body WINFORMS_INTERFACE_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."WINFORMS_INTERFACE_SYNTH" 
AS
  ------------------------------------------------------------------------------

  /*
  * Generates the Grid View loader.
  */
FUNCTION GRID_VIEW_TABLE(
    par_table_name VARCHAR2,
    par_key_table  VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out         VARCHAR2(32000) ;
  lc_class       VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name);
  lc_instance    VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name, par_lower_init => true);
  lc_primary_key VARCHAR2(2000) := csh.get_table_prefix(par_table_name)||'_CODE';

BEGIN
  add_ln(lc_out, 'private void Load'||lc_class||'Grid()');
  add_ln(lc_out, '{');
  add_ln(lc_out, 'this.'||lc_instance||'Grid = new DataGridView();');
  add_ln(lc_out, 'Load'||lc_class||'Data();');
  add_ln(lc_out, 'this.'||lc_instance||'Grid.EditMode = DataGridViewEditMode.EditOnEnter;');
  add_ln(lc_out, 'this.'||lc_instance||'Grid.DataSource = this.'||lc_instance||'DataTable;');
  add_ln(lc_out, 'this.'||lc_instance||'Grid.AllowUserToDeleteRows = true;');
  add_ln(lc_out, '}');

  RETURN lc_out;
END GRID_VIEW_TABLE;
------------------------------------------------------------------------------
FUNCTION GRID_VIEW_ITEM(
    par_table_name VARCHAR2,
    par_key_table  VARCHAR2)
  RETURN VARCHAR2

IS
  lc_out              VARCHAR2(32000);
  lc_class            VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name);
  lc_instance         VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name, par_lower_init => true);
  lc_key_instance     VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_key_table, par_lower_init => true);
  lc_table_prefix     VARCHAR2(100) := csh.get_table_prefix(par_table_name);
  lc_key_table_prefix VARCHAR2(100) := csh.get_table_prefix(par_key_table);

BEGIN

  add_ln(lc_out, 'private void Load'||lc_class||'Grid(int results) {');
  add_ln(lc_out, 'this.'||lc_instance||'Grid = new DataGridView();');
  add_ln(lc_out, 'this.'||lc_instance||'Grid.ReadOnly = true;');
  add_ln(lc_out, 'this.'||lc_instance||'DataTable = new DataTable();');
  add_ln(lc_out, 'OracleDataReader '||lc_instance||'Cursor = SQLExecutor.GetRows("'||par_table_name||'", "'||lc_table_prefix||'_'||
  lc_key_table_prefix|| '_CODE", this.'||lc_key_instance||'Code);');
  add_ln(lc_out, 'dataTable.Load('||lc_instance||'Cursor);');
  add_ln(lc_out, 'this.'||lc_instance||'DataTable = Utils.TransposeDataTable(this.'||lc_instance||'DataTable); //Transpose for gridView');
  add_ln(lc_out, 'this.'||lc_instance||'Grid.DataSource = this.'||lc_instance||'DataTable;');
  add_ln(lc_out, '}');

  RETURN lc_out;
END GRID_VIEW_ITEM;
------------------------------------------------------------------------------
FUNCTION LOAD_DATA(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out          VARCHAR2(32000);
  lc_class        VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name);
  lc_instance     VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name, par_lower_init => true);
  lc_table_prefix VARCHAR2(100) := csh.get_table_prefix(par_table_name);

BEGIN

  add_ln(lc_out, 'private void Load'||lc_class||'Data()');
  add_ln(lc_out, '{');
  add_ln(lc_out, 'this.'||lc_instance||'DataTable = new DataTable();');
  add_ln(lc_out, 'this.'||lc_instance||'Cursor = SQLExecutor.GetResults("'||par_table_name||'", '||lc_instance||'Results);');
  add_ln(lc_out, 'this.'||lc_instance||'DataTable.Load(this.'||lc_instance||'Cursor);');
  add_ln(lc_out, 'this.'||lc_instance||'DataTable.TableName = "'||par_table_name||'";');
  add_ln(lc_out, 'this.'||lc_instance||'DataTable.Columns["'||lc_table_prefix||'_CODE"].AllowDBNull = true;');
  add_ln(lc_out, '}');

  RETURN lc_out;

END LOAD_DATA;

------------------------------------------------------------------------------
PROCEDURE INTERFACE_TO_FILE(
    par_screen_name VARCHAR2)
AS

  lf_file utl_file.file_type;
  lc_directory VARCHAR2(200) := 'WRITE_CODE_SYNTH_DIR';
  lc_filename  VARCHAR2(2000);
  lc_controller b_app_controllers.aco_controller%type;

BEGIN

  lc_controller := csh.CAMEL_TO_SNAKE(PAR_SCREEN_NAME);
  lc_controller := upper(SUBSTR(lc_controller, 0, LENGTH(lc_controller) - 7));
  lc_filename := par_screen_name||'.Interface.cs';
  lf_file := UTL_FILE.FOPEN(lc_directory, lc_filename, 'W', 32767);
  MISC_UTILS.SET_OUTPUT_PARS(par_mode => 'FILE', par_directory => lc_directory, par_file => lf_file);
  WINFORM_INTERFACE(lc_controller);
  UTL_FILE.FCLOSE(lf_file);
  MISC_UTILS.SET_OUTPUT_PARS(par_mode => 'DBMS_OUTPUT', par_directory => lc_directory, par_file => NULL);

END;
------------------------------------------------------------------------------

PROCEDURE WINFORM_INTERFACE(
    par_controller b_app_controllers.aco_controller%type)
AS

  lr_controller b_app_controllers%ROWTYPE;
  lc_class           VARCHAR2(2000);
  lc_instance        VARCHAR2(2000);
  lc_child_class     VARCHAR2(2000);
  lc_child_instance  VARCHAR2(2000);
  lc_parent_class    VARCHAR2(2000);
  lc_parent_instance VARCHAR2(2000);

BEGIN

  SELECT *
  INTO lr_controller
  FROM b_app_controllers
  WHERE aco_controller = par_controller;
  lc_class := csh.CAMEL_TABLENAME_WOB(lr_controller.aco_table);
  lc_instance := csh.CAMEL_TABLENAME_WOB(lr_controller.aco_table, par_lower_init => true);

  doutln(
  'using ApplicationAnalyzer.CustomControls;
using ApplicationAnalyzer.Misc;
using Oracle.DataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;'
  );

  doutln('namespace ApplicationAnalyzer.Forms');
  doutln('{');
  doutln('partial class '||lc_class||'Screen');
  doutln('{');
  doutln('DataGridView '||lc_instance||'Grid;');
  doutln('DataTable '||lc_instance||'DataTable;');
  doutln('OracleDataReader '||lc_instance||'Cursor;');
  doutln('private int '||lc_instance||'Results;');
  
  -- Add pars for child tables
  FOR rChildren IN csh.cControllerChildren(par_controller)
  LOOP
    lc_child_instance := csh.camel_tablename_wob(rChildren.cos_table, par_lower_init => true);
    doutln('DataGridView '||lc_child_instance||'Grid;');
    doutln('DataTable '||lc_child_instance||'DataTable;');
    doutln('OracleDataReader '||lc_child_instance||'Cursor;');
  END LOOP;

  -- Add Toolbar initiation
  doutln('ButtonToolBar buttonToolBar = new ButtonToolBar();');
  
  -- Add parent reference code;
  IF (lr_controller.aco_parent_table IS NOT NULL) THEN
    lc_parent_instance := csh.camel_tablename_wob(lr_controller.aco_parent_table, par_lower_init => true);
    doutln('private int '||lc_parent_instance||'Code;');
  END IF;
  doutln('');
  -- Setter for parent reference key
  IF (lr_controller.aco_parent_table IS NOT NULL) THEN
    lc_parent_class := csh.camel_tablename_wob(lr_controller.aco_parent_table);
    doutln('public void Set'||lc_parent_class||'Code(int current'||lc_parent_class||')');
    doutln('{');
    doutln('this.'||lc_parent_instance||'Code = current'||lc_parent_class||';');
    doutln('}');
  END IF;

  -- Main Grid LoadData
  IF (lr_controller.aco_view_type = 'TABLE') THEN
    doutln(GRID_VIEW_TABLE(lr_controller.aco_table, lr_controller.aco_parent_table));
    doutln(LOAD_DATA(lr_controller.aco_table));
  ELSE
    doutln(GRID_VIEW_ITEM(lr_controller.aco_table, lr_controller.aco_table));
    doutln(LOAD_DATA(lr_controller.aco_table));
  END IF;

  -- Main Grid Delete Item
  doutln(DELETE_ITEM(lr_controller.aco_table));

  -- Main Delete Item
  doutln(COMMIT_CHANGES(lr_controller.aco_table));

  -- Main Grid PrettyNames
  doutln(PRETTY_NAMES(lr_controller.aco_table, lr_controller.aco_view_type));

  -- Children Grid LoadData
  FOR rChildren IN csh.cControllerChildren(par_controller)
  LOOP
    doutln(SIBLING_GRID(rChildren.cos_table,lr_controller.aco_table,rChildren.cos_view_type));
  END LOOP;

  doutln('}');
  doutln('}');


END WINFORM_INTERFACE;
------------------------------------------------------------------------------
FUNCTION PRETTY_NAMES(
    par_table_name VARCHAR2,
    par_view_type  VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out      VARCHAR2(32000);
  lc_class    VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name);
  lc_instance VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name, par_lower_init => true);

BEGIN

  IF (par_view_type = 'TABLE') THEN
    add_ln(lc_out, 'private void '||lc_class||'Grid_PrettyNames()');
    add_ln(lc_out, '{');
    add_ln(lc_out, 'for (int i = 0; i < this.'||lc_instance||'Grid.Columns.Count; i++)');
    add_ln(lc_out, '{');
    add_ln(lc_out, 'string colName = this.'||lc_instance||'Grid.Columns[i].HeaderText;');
    add_ln(lc_out, 'string prettyName = SQLExecutor.GetPrettyName("'||par_table_name||'", colName);');
    add_ln(lc_out, 'this.'||lc_instance||'Grid.Columns[i].HeaderText = prettyName;');
    add_ln(lc_out, '}');
    add_ln(lc_out, '}');
  ELSE
    add_ln(lc_out, 'public void '||lc_class||'PrettyNames()');
    add_ln(lc_out, '{');
    add_ln(lc_out, 'for (int i = 0; i < this.'||lc_instance||'Grid.Rows.Count; i++)');
    add_ln(lc_out, '{');
    add_ln(lc_out, 'string colName = this.'||lc_instance||'Grid.Rows[i].Cells[1].Value.ToString();');
    add_ln(lc_out, 'string prettyName = SQLExecutor.GetPrettyName("'||par_table_name||'", colName);');
    add_ln(lc_out, 'this.'||lc_instance||'Grid.Rows[i].Cells[0].Value = prettyName;');
    add_ln(lc_out, '}');
    add_ln(lc_out, '}');
  END IF;
  RETURN lc_out;
END PRETTY_NAMES;
------------------------------------------------------------------------------

FUNCTION DELETE_ITEM(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
AS

  lc_out      VARCHAR2(32000);
  lc_class    VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name);
  lc_instance VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name, par_lower_init => true);

BEGIN
  add_ln(lc_out, 'private void '||lc_class||'Grid_DeleteItem()');
  add_ln(lc_out, '{');
  add_ln(lc_out, lc_instance||'Grid.Rows.RemoveAt('||lc_instance||'Grid.SelectedRows[0].Index);');
  add_ln(lc_out, '}');
  RETURN lc_out;
END DELETE_ITEM;

------------------------------------------------------------------------------
FUNCTION COMMIT_CHANGES(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
AS

  lc_out      VARCHAR2(32000);
  lc_class    VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name);
  lc_instance VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name, par_lower_init => true);

BEGIN

  add_ln(lc_out, 'private void '||lc_class||'Grid_CommitChanges()');
  add_ln(lc_out, '{');
  add_ln(lc_out, 'DataTable changesTable = this.'||lc_instance||'DataTable.GetChanges();');
  add_ln(lc_out, 'if (changesTable != null) {');
  add_ln(lc_out, 'changesTable.TableName = this.'||lc_instance||'DataTable.TableName;');
  add_ln(lc_out, '//Get updated rows from database;');
  add_ln(lc_out, 'DataTable refreshTable = SQLExecutor.CommitChanges(changesTable);');
  add_ln(lc_out, '//Remove Added rows and repopulate with data from Database');
  add_ln(lc_out, 'for (int i = 0; i < '||lc_instance||'DataTable.Rows.Count; i++)');
  add_ln(lc_out, '{');
  add_ln(lc_out, 'if ('||lc_instance||'DataTable.Rows[i].RowState == DataRowState.Added)');
  add_ln(lc_out, '{');
  add_ln(lc_out, ''||lc_instance||'DataTable.Rows[i].Delete();');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  add_ln(lc_out, 'foreach (DataRow row in refreshTable.Rows){');
  add_ln(lc_out, lc_instance||'DataTable.Rows.Add(row.ItemArray);');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');

  RETURN lc_out;
END COMMIT_CHANGES;
------------------------------------------------------------------------------
FUNCTION SIBLING_GRID(
    par_table_name   VARCHAR2,
    par_parent_table VARCHAR2,
    par_view_type    VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out      VARCHAR2(32000);
  lc_class    VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name);
  lc_instance VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name, par_lower_init => true);

BEGIN

  -- Main Grid LoadData
  IF (par_view_type = 'TABLE') THEN
    doutln(GRID_VIEW_TABLE(par_table_name, par_parent_table));
    doutln(LOAD_DATA(par_table_name));
  ELSE
    doutln(GRID_VIEW_ITEM(par_table_name, par_parent_table));
    doutln(LOAD_DATA(par_table_name));
  END IF;

  -- Main Grid Delete Item
  add_ln(lc_out, DELETE_ITEM(par_table_name));

  -- Main Delete Item
  add_ln(lc_out, COMMIT_CHANGES(par_table_name));

  -- Main Grid PrettyNames
  add_ln(lc_out, PRETTY_NAMES(par_table_name, par_parent_table));

  RETURN lc_out;

END SIBLING_GRID;

END WINFORMS_INTERFACE_SYNTH;

/
