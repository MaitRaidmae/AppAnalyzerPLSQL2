--------------------------------------------------------
--  DDL for Package Body JAVAFX_DATA_CLASS_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."JAVAFX_DATA_CLASS_SYNTH" 
IS

  --------------------------------------------------------------------------------
  -- Local private helper functions ----------------------------------------------
  --------------------------------------------------------------------------------
  
  /**
  *  par_type can be either UPDATE or INSERT depending on which operation is required.
  */
FUNCTION CALL_STATEMENT(
    par_table_name VARCHAR2,
    par_type       VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);
  li_i pls_integer := 0;
  lc_pars VARCHAR2(32000);
  lc_qs   VARCHAR2(100);
  lc_package csh.gt_identifier := regexp_replace(upper(par_table_name),'B_','P_',1,1);

BEGIN


  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    IF (csh.cTabCols%ROWCOUNT > 1 OR par_type = 'UPDATE') THEN
      li_i                   :=li_i+1;
      lc_pars                := lc_pars || 'callStmt.set'||
      CASE csh.gr_par_type_map(rTabCols.column_name)
      WHEN 'Integer' THEN
        'Int'
      ELSE
        csh.gr_par_type_map(rTabCols.column_name)
      END|| '("par_'||lower(rTabCols.column_name)||'", this.get'||csh.snake_to_camel(rTabCols.column_name)||'());'||CHR(10);
    END IF;
  END LOOP;

  --cut the last newline from lc_pars
  lc_pars := SUBSTR(lc_pars, 1, LENGTH(lc_pars)-1);

  lc_out  := 'try(CallableStatement callStmt = db_connection.prepareCall("{ call '||lc_package||'.'||par_type||'_ROW('||rpad('?', 2*li_i-1, ',?')||') }")) {';
  add_ln(lc_out, lc_pars);

  add_ln(lc_out, 'callStmt.execute();');
  RETURN lc_out;

END;
--------------------------------------------------------------------------------
FUNCTION EDIT_GRID_CASE_BLOCK(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);

BEGIN

  FOR rTabCols IN csh.cTabCols(par_Table_name)
  LOOP
    add_ln(lc_out, 'case "'||rTabCols.column_name||'":');
    IF (CSH.IS_LOV_COLUMN(PAR_TABLE_NAME, rTabCols.COLUMN_NAME) = 1) THEN
      add_ln(lc_out, 'comboBox = new ComboBox(SQLExecutor.getLov("'||par_table_name||'",metaData.getColumnName(i)));');
      add_ln(lc_out, 'comboBox.setValue(dataValues.getString(i));');
      add_ln(lc_out, 'fieldType = "comboBox";');
    ELSE
      add_ln(lc_out, 'textField = new TextField(dataValues.getString(i));');
      add_ln(lc_out, 'fieldType = "textField";');
    END IF;
    add_ln(lc_out, 'break;');
  END LOOP;
  RETURN lc_out;
END;
--------------------------------------------------------------------------------
FUNCTION SET_FROM_GRID_CASE_BLOCK(
    par_Table_name VARCHAR2,
    par_type       VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);

BEGIN

  csh.MAP_PARS(par_table_name);
  FOR rTabCols IN csh.cTabCols(par_Table_name)
  LOOP
    IF (CSH.IS_LOV_COLUMN(PAR_TABLE_NAME, rTabCols.COLUMN_NAME) = 0 AND PAR_TYPE = 'TextField') THEN

      ADD_LN(LC_OUT, 'case "'||rTabCols.COLUMN_NAME||'":');
      CASE (CSH.GR_PAR_TYPE_MAP(rTabCols.COLUMN_NAME))
      WHEN 'Integer' THEN
        ADD_LN(LC_OUT, 'this.set'||csh.SNAKE_TO_CAMEL(rTabCols.column_name)||'(Integer.parseInt(textField.getText()));');
      WHEN 'Double' THEN
        ADD_LN(LC_OUT, 'this.set'||csh.SNAKE_TO_CAMEL(rTabCols.column_name)||'(Double.parseDouble(textField.getText()));');
      WHEN 'String' THEN
        ADD_LN(LC_OUT, 'this.set'||CSH.SNAKE_TO_CAMEL(rTabCols.COLUMN_NAME)||'(textField.getText());');
      ELSE
        ADD_LN(LC_OUT, 'Nuuks');
      END CASE;
      ADD_LN(LC_OUT, 'break;');
    ELSIF (CSH.IS_LOV_COLUMN(PAR_TABLE_NAME, rTabCols.COLUMN_NAME) = 1 AND par_type = 'ComboBox') THEN
      ADD_LN(LC_OUT, 'case "'||rTabCols.COLUMN_NAME||'":');
      CASE (CSH.GR_PAR_TYPE_MAP(rTabCols.COLUMN_NAME))
      WHEN 'Integer' THEN
        ADD_LN(LC_OUT, 'this.set'||csh.SNAKE_TO_CAMEL(rTabCols.column_name)||'((Integer) comboBox.getValue());');
      WHEN 'Double' THEN
        add_ln(lc_out, 'this.set'||csh.SNAKE_TO_CAMEL(rTabCols.column_name)||'((Double) comboBox.getValue());');
      WHEN 'String' THEN
        ADD_LN(LC_OUT, 'this.set'||CSH.SNAKE_TO_CAMEL(rTabCols.COLUMN_NAME)||'((String) comboBox.getValue());');
      END CASE;
      ADD_LN(LC_OUT, 'break;');
    END IF;

  END LOOP;

  RETURN LC_OUT;
END SET_FROM_GRID_CASE_BLOCK;
--------------------------------------------------------------------------------
------- Published functions ----------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE DATA_CLASS(
    PAR_TABLE_NAME       VARCHAR2,
    PAR_PARENT_CODE_NAME VARCHAR2 DEFAULT '',
    par_view_only        BOOLEAN DEFAULT false)
IS
  lc_table_name csh.gt_identifier;
  lc_buffer     VARCHAR2(32000):= '';

BEGIN

  -- Map parameters:
  CSH.MAP_PARS(par_table_name);
  -- convert input to lowercase
  lc_table_name := lower(par_table_name);
  -- Generate header imports etc
  lc_buffer := 'import applicationanalyzer.Misc.Alerts;
import applicationanalyzer.Misc.CallableStatementResults;
import applicationanalyzer.Misc.ConnectionManager;
import applicationanalyzer.Misc.SQLExecutor;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.List;
import javafx.scene.Node;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.GridPane;
' ;
  doutln(lc_buffer);
  lc_table_name := csh.CAMEL_TABLENAME_WOB(lc_table_name);
  -- Generate class declaration
  doutln('public class ' ||lc_table_name|| '{');

  -- Generate general properties
  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    CASE CSH.GR_PAR_TYPE_MAP(rTabCols.COLUMN_NAME)
    WHEN 'Date' THEN
      DOUTLN('private final SimpleObjectProperty<Date> '||LOWER(rTabCols.COLUMN_NAME)||';');
    ELSE
      DOUTLN('private final Simple'||CSH.GR_PAR_TYPE_MAP(rTabCols.COLUMN_NAME)||'Property '||LOWER(rTabCols.COLUMN_NAME)||';');
    END CASE;
  END LOOP;
  doutln('');
  -- Add constructor to the class
  doutln(DATA_CONSTRUCTOR(par_table_name));
  -- Add Blank constructor to the class
  doutln(BLANK_CONSTRUCTOR(par_table_name));

  -- Add parent constructor if parent code is indicated:
  IF (par_parent_code_name IS NOT NULL) THEN
    DOUTLN(PARENT_CONSTRUCTOR(par_table_name, par_parent_code_name));
  END IF;

  --Generate getters and setters
  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    doutln(GETTER(rTabCols.column_name, par_table_name));
    IF (par_view_only = FALSE) THEN
      DOUTLN(SETTER(rTabCols.COLUMN_NAME, PAR_TABLE_NAME));
    END IF;
  END LOOP;

  -- Add getGrid function
  doutln(GET_GRID(par_table_name));

  -- Add getEmptyGrid function
  doutln(GET_EMPTY_GRID(par_table_name));

  IF (par_view_only = FALSE) THEN
    --Add Commit function
    DOUTLN(COMMIT_FUNCTION(PAR_TABLE_NAME));
    -- Add showEditDialog function
    doutln(SHOW_EDIT_DIALOG(par_table_name));
    -- Add setEditGrid function
    DOUTLN(SET_FROM_GRID(PAR_TABLE_NAME));
  END IF;

  --Add create function
  doutln(create_fun(par_table_name));
  
  --Add delete function
  doutln(delete_fun(par_table_name));

  --Add getResultSet function (only when parent code is indicated for now)
  IF (PAR_PARENT_CODE_NAME IS NOT NULL) THEN
    DOUTLN(GET_RESULT_SET(PAR_TABLE_NAME, PAR_PARENT_CODE_NAME));
  END IF;

  -- Add closing bracket
  DOUTLN('}');

END DATA_CLASS;
--------------------------------------------------------------------------------
FUNCTION DATA_CONSTRUCTOR(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_table_name csh.gt_identifier;
  lc_buffer     VARCHAR2(32000):= '';
  lc_parameters VARCHAR2(32000):= '';
  lc_out        VARCHAR2(32000):= '';

BEGIN
  lc_table_name := csh.CAMEL_TABLENAME_WOB(par_table_name);

  -- Map pars just in case
  csh.MAP_PARS(par_table_name);
  -- Generate parameters list
  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    -- Generate pars
    lc_parameters := lc_parameters ||csh.gr_par_type_map(rTabCols.column_name)||' '||lower(rTabCols.column_name)||','||CHR(10);
  END LOOP;

  -- Cut last coma and newline
  lc_parameters := SUBSTR(lc_parameters, 1, LENGTH(lc_parameters)-2);

  -- Generate constructor
  add_ln(lc_out, 'public ' ||lc_table_name|| '('|| lc_parameters||'){');
  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    CASE CSH.GR_PAR_TYPE_MAP(rTabCols.COLUMN_NAME)
    WHEN 'Date' THEN
      ADD_LN(LC_OUT, 'this.'||LOWER(rTabCols.COLUMN_NAME)|| ' = new SimpleObjectProperty('||LOWER(rTabCols.COLUMN_NAME)||');');
    ELSE
      ADD_LN(LC_OUT, 'this.'||LOWER(rTabCols.COLUMN_NAME)|| ' = new Simple'||CSH.GR_PAR_TYPE_MAP(rTabCols.COLUMN_NAME)||'Property('||LOWER(rTabCols.COLUMN_NAME)||');');
    END CASE;
  END LOOP;

  add_ln(lc_out, '}');

  RETURN LC_OUT;

END DATA_CONSTRUCTOR;
--------------------------------------------------------------------------------
FUNCTION BLANK_CONSTRUCTOR(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_class  csh.gt_identifier;
  lc_buffer VARCHAR2(32000):= '';
  lc_out    VARCHAR2(32000):= '';

BEGIN
  lc_class := csh.CAMEL_TABLENAME_WOB(par_table_name);

  -- Map pars just in case
  csh.MAP_PARS(par_table_name);

  -- Generate constructor
  add_ln(lc_out, 'public ' ||lc_class|| '(){');
  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    CASE CSH.GR_PAR_TYPE_MAP(rTabCols.COLUMN_NAME)
    WHEN 'Date' THEN
      ADD_LN(LC_OUT, 'this.'||LOWER(rTabCols.COLUMN_NAME)|| ' = new SimpleObjectProperty();');
    ELSE
      ADD_LN(LC_OUT, 'this.'||LOWER(rTabCols.COLUMN_NAME)|| ' = new Simple'||CSH.GR_PAR_TYPE_MAP(rTabCols.COLUMN_NAME)||'Property();');
    END CASE;
  END LOOP;

  add_ln(lc_out, '}');

  RETURN LC_OUT;

END BLANK_CONSTRUCTOR;
--------------------------------------------------------------------------------
FUNCTION GETTER(
    par_par_name   VARCHAR2,
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);

BEGIN
  -- Generate getter function
  add_ln(lc_out, 'public '||csh.gr_par_type_map(par_par_name)||' get'||csh.SNAKE_TO_CAMEL(par_par_name)||'() {');
  add_ln(lc_out, 'return '||lower(par_par_name)||'.get();');
  add_ln(lc_out, '}');
  RETURN lc_out;
END GETTER;
--------------------------------------------------------------------------------
FUNCTION SETTER(
    par_par_name   VARCHAR2,
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_local_name   csh.gt_identifier := lower(SUBSTR(par_par_name, instr(par_par_name, '_', 1)   +1, 99));
  lc_table_prefix csh.gt_identifier := lower(SUBSTR(par_par_name, 1, instr(par_par_name, '_', 1)-1));
  lc_out          VARCHAR2(32000);
BEGIN

  add_ln(lc_out, 'public void set'||csh.SNAKE_TO_CAMEL(par_par_name)||'('||csh.gr_par_type_map(par_par_name)||' '||lc_local_name||') {');
  add_ln(lc_out, lower(par_par_name)||'.set('||lc_local_name||');');
  -- If it's a boolean column assume it's a checkbox and update directly.
  IF (csh.IS_BOOLEAN_COLUMN(par_table_name, par_par_name) = 1) THEN
    add_ln(lc_out, 'SQLExecutor.updateRowNvalue("'||par_table_name||'",getChkCode(),"'||par_par_name||'",get'||csh.SNAKE_TO_CAMEL(par_par_name)||'());');
  END IF;
  add_ln(lc_out, '}');

  RETURN lc_out;
END SETTER;
--------------------------------------------------------------------------------
FUNCTION COMMIT_FUNCTION(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  LC_OUT VARCHAR2(32000);

BEGIN

  add_ln(lc_out, 'public void commit() {');
  add_ln(lc_out, 'Connection db_connection = ConnectionManager.cl_conn;');
  add_ln(lc_out, CALL_STATEMENT(par_table_name, 'UPDATE'));
  add_ln(lc_out, '} catch (SQLException sqle) {');
  add_ln(lc_out, 'Alerts.AlertSQL(sqle);');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');

  RETURN LC_OUT;

END COMMIT_FUNCTION;
--------------------------------------------------------------------------------
FUNCTION PARENT_CONSTRUCTOR(
    par_table_name       VARCHAR2,
    par_parent_code_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out        VARCHAR2(32000);
  lc_table_name csh.gt_identifier;
  lc_parameters VARCHAR2(2000);

BEGIN

  lc_table_name := csh.camel_tablename_wob(par_table_name);
  -- Map pars just in case
  csh.MAP_PARS(par_table_name);

  -- Generate pars
  lc_parameters := '(Integer '||lower(par_parent_code_name)||')';


  -- Generate constructor
  add_ln(lc_out, 'public ' ||lc_table_name||lc_parameters||'{');
  add_ln(lc_out, 'this();');
  add_ln(lc_out, 'CallableStatementResults callResults = SQLExecutor.getTableRow("'||par_table_name|| '", "'||csh.get_table_prefix(par_table_name)||'_'||upper(par_parent_code_name)||'", '||lower(par_parent_code_name)||');');
  add_ln(lc_out, 'ResultSet pars = callResults.getResultSet();');


  -- Generate the try block
  add_ln(lc_out, 'try {');
  add_ln(lc_out, 'if (pars.next()) {');
  -- Loop Here
  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    add_ln(lc_out, lower(rTabCols.column_name)||'.set(pars.get'||
    CASE csh.gr_par_type_map(rTabCols.column_name)
    WHEN 'Integer' THEN
      'Int'
    ELSE
      csh.gr_par_type_map(rTabCols.column_name)
    END || '("'||lower(rTabCols.column_name)||'"));');
  END LOOP;

add_ln(lc_out, '}');
add_ln(lc_out, '} catch (SQLException sqle) {');
add_ln(lc_out, 'Alerts.AlertSQL(sqle);');
add_ln(lc_out, '}');
add_ln(lc_out, 'callResults.close();');
add_ln(lc_out, '}');

RETURN lc_out;

END PARENT_CONSTRUCTOR;
--------------------------------------------------------------------------------

FUNCTION GET_RESULT_SET(
    PAR_TABLE_NAME       VARCHAR2,
    par_parent_code_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);
BEGIN
  CSH.MAP_PARS(PAR_TABLE_NAME);

  ADD_LN(LC_OUT, 'public static CallableStatementResults getResultSet(Integer '||par_parent_code_name||') {');
  ADD_LN(LC_OUT, 'CallableStatementResults callResults = SQLExecutor.getTableRow("'||par_table_name|| '", "'||CSH.GET_TABLE_PREFIX(PAR_TABLE_NAME)||upper(PAR_PARENT_CODE_NAME)||'", '||PAR_PARENT_CODE_NAME||');');
  ADD_LN(LC_OUT, 'return callResults;');
  ADD_LN(LC_OUT, '}');

  RETURN lc_out;
END GET_RESULT_SET;
--------------------------------------------------------------------------------
FUNCTION SHOW_EDIT_DIALOG(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);

BEGIN
  lc_out:='public boolean showEditDialog(Window owner) {';
  add_ln(lc_out, 'try {');
  add_ln(lc_out, '//Load Edit FXML');
  add_ln(lc_out, 'FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/applicationanalyzer/FXML/Edit'||CSH.CAMEL_TABLENAME_WOB(par_table_name)||'.fxml"));');
  add_ln(lc_out, 'AnchorPane page = (AnchorPane) fxmlLoader.load();');
  add_ln(lc_out, '//Load edit Stage');
  add_ln(lc_out, 'Stage editStage = new Stage();');
  add_ln(lc_out, 'editStage.setTitle("<<<PUT TITLE HERE>>>");');
  add_ln(lc_out, 'editStage.initModality(Modality.WINDOW_MODAL);');
  add_ln(lc_out, 'editStage.initOwner(owner);');
  add_ln(lc_out, 'Scene scene = new Scene(page);');
  add_ln(lc_out, 'editStage.setScene(scene);');
  add_ln(lc_out, '// Set data object into the contoller');
  ADD_LN(LC_OUT, CSH.CAMEL_TABLENAME_WOB(par_table_name)||'Controller controller = fxmlLoader.getController();');
  add_ln(lc_out, 'controller.initObject(this);');
  add_ln(lc_out, 'controller.setStage(editStage);');
  add_ln(lc_out, 'editStage.showAndWait();');

  add_ln(lc_out, 'return controller.isCommited();');
  add_ln(lc_out, '} catch (IOException e) {');
  add_ln(lc_out, 'Alerts.AlertIO(e);');
  add_ln(lc_out, 'return false;');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');

  RETURN lc_out;
END SHOW_EDIT_DIALOG;
--------------------------------------------------------------------------------

FUNCTION GET_GRID(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS
  lc_table_name csh.gt_identifier := csh.CAMEL_TABLENAME_WOB(par_table_name);
  lc_out        VARCHAR2(2000);
BEGIN
   

  lc_out :='public GridPane getGrid(Boolean editable) {';
  add_ln(lc_out, 'GridPane grid = new GridPane();');
  add_ln(lc_out, 'Boolean noData = true; //Assume not to find anything');
  add_ln(lc_out, 'int k = 0;');
  add_ln(lc_out, 'String fieldType = "";');
  add_ln(lc_out, 'CallableStatementResults callResults = SQLExecutor.getTableRow("'||par_table_name||'", "'||csh.get_table_prefix(par_Table_name) ||'_CODE", this.get'||initcap(csh.get_table_prefix(par_Table_name))||'Code());');
  add_ln(lc_out, 'ResultSet dataValues = callResults.getResultSet();');
  add_ln(lc_out, 'ResultSetMetaData metaData;');
  add_ln(lc_out, 'TextField textField = new TextField();');
  add_ln(lc_out, 'ComboBox comboBox  = new ComboBox();');
  add_ln(lc_out, 'try {');
  add_ln(lc_out, 'while (dataValues.next()) {');
  add_ln(lc_out, 'noData = false;');
  add_ln(lc_out, 'metaData = dataValues.getMetaData();');
  add_ln(lc_out, 'for (int i = 2; i <= metaData.getColumnCount(); i++) {');
  add_ln(lc_out, 'Label fieldNameLbl = new Label(SQLExecutor.getPrettyName("'||par_table_name||'", metaData.getColumnName(i)));');
  add_ln(lc_out, 'grid.add(fieldNameLbl, 0, k);');
  add_ln(lc_out, 'if (!editable) {');
  add_ln(lc_out, 'Label fieldValueLbl = new Label(dataValues.getString(i));');
  add_ln(lc_out, 'grid.add(fieldValueLbl, 1, k);');
  add_ln(lc_out, '} else {');
  add_ln(lc_out, 'switch (metaData.getColumnName(i)) {');
  add_ln(lc_out, EDIT_GRID_CASE_BLOCK(par_table_name));
  add_ln(lc_out, '}');
  add_ln(lc_out, 'switch (fieldType) {');
  add_ln(lc_out, 'case "textField":');
  add_ln(lc_out, 'textField.setId(metaData.getColumnName(i));');
  add_ln(lc_out, 'grid.add(textField, 1, k);');
  add_ln(lc_out, 'break;');
  add_ln(lc_out, 'case "comboBox":');
  add_ln(lc_out, 'comboBox.setId(metaData.getColumnName(i));');
  add_ln(lc_out, 'grid.add(comboBox, 1, k);');
  add_ln(lc_out, 'break;');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  add_ln(lc_out, 'k++;');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  add_ln(lc_out, '} catch (SQLException sqle) {');
  add_ln(lc_out, 'Alerts.AlertSQL(sqle);');
  add_ln(lc_out, '}');
  add_ln(lc_out, 'callResults.close();');
  add_ln(lc_out, 'if (noData == false) {');
  add_ln(lc_out, 'return grid;');
  add_ln(lc_out, '} else {');
  add_ln(lc_out, 'return null;');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  RETURN lc_out;
END;
--------------------------------------------------------------------------------
FUNCTION GET_EMPTY_GRID(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);

BEGIN

  add_ln(lc_out, 'public GridPane getEmptyGrid(List hiddenCols, String constraint) {');
  add_ln(lc_out, 'GridPane grid = new GridPane();');
  add_ln(lc_out, 'int k = 0;');
  add_ln(lc_out, 'String fieldType = "";');
  add_ln(lc_out, 'CallableStatementResults callResults = SQLExecutor.getColumnData("'||upper(par_table_name)||'");');
  add_ln(lc_out, 'ResultSet dataValues = callResults.getResultSet();');
  add_ln(lc_out, 'TextField textField = new TextField();');
  add_ln(lc_out, 'ComboBox comboBox = new ComboBox();');
  add_ln(lc_out, 'try {');
  add_ln(lc_out, 'while (dataValues.next()) {');
  add_ln(lc_out, 'if (hiddenCols == null || !hiddenCols.contains(dataValues.getString("column_name"))) {');
  add_ln(lc_out, 'Label fieldNameLbl = new Label(SQLExecutor.getPrettyName("'||upper(par_table_name)||'", dataValues.getString("column_name")));');
  add_ln(lc_out, 'grid.add(fieldNameLbl, 0, k);');
  add_ln(lc_out, 'switch (dataValues.getInt("is_lov")) {');
  add_ln(lc_out, 'case 1:');
  add_ln(lc_out, 'comboBox = new ComboBox(SQLExecutor.getLov("'||upper(par_table_name)||'", dataValues.getString("column_name, constraint));');
  add_ln(lc_out, 'fieldType = "comboBox";');
  add_ln(lc_out, 'break;');
  add_ln(lc_out, 'default:');
  add_ln(lc_out, 'textField = new TextField();');
  add_ln(lc_out, 'fieldType = "textField";');
  add_ln(lc_out, '}');

  add_ln(lc_out, 'switch (fieldType) {');
  add_ln(lc_out, 'case "textField":');
  add_ln(lc_out, 'textField.setId(dataValues.getString("column_name"));');
  add_ln(lc_out, 'grid.add(textField, 1, k);');
  add_ln(lc_out, 'break;');
  add_ln(lc_out, 'case "comboBox":');
  add_ln(lc_out, 'comboBox.setId(dataValues.getString("column_name"));');
  add_ln(lc_out, 'grid.add(comboBox, 1, k);');
  add_ln(lc_out, 'break;');
  add_ln(lc_out, '}');
  add_ln(lc_out, 'k++;');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  add_ln(lc_out, '} catch (SQLException sqle) {');
  add_ln(lc_out, 'Alerts.AlertSQL(sqle);');
  add_ln(lc_out, '}');
  add_ln(lc_out, 'callResults.close();');
  add_ln(lc_out, 'return grid;');
  add_ln(lc_out, '}');
  RETURN lc_out;
END GET_EMPTY_GRID;

--------------------------------------------------------------------------------
FUNCTION SET_FROM_GRID(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);
BEGIN
  add_ln(lc_out, 'public void setFromGrid(GridPane grid) {');
  add_ln(lc_out, 'for (Node node : grid.getChildren()) {');
  add_ln(lc_out, 'if (node instanceof TextField) {');
  add_ln(lc_out, 'TextField textField = (TextField) node;');
  ADD_LN(LC_OUT, 'switch (textField.getId()) {');
  ADD_LN(LC_OUT, SET_FROM_GRID_CASE_BLOCK(par_table_name, 'TextField'));
  add_ln(lc_out, '}');
  add_ln(lc_out, '} else if (node instanceof ComboBox) {');
  add_ln(lc_out, 'ComboBox comboBox = (ComboBox) node;');
  ADD_LN(LC_OUT, 'switch (comboBox.getId()) {');
  add_ln(lc_out, SET_FROM_GRID_CASE_BLOCK(par_table_name, 'ComboBox'));
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  RETURN lc_out;
END SET_FROM_GRID;
--------------------------------------------------------------------------------
FUNCTION CREATE_FUN(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);

BEGIN
  add_ln(lc_out, 'public void create() {');
  add_ln(lc_out, 'Connection db_connection = ConnectionManager.cl_conn;');
  add_ln(lc_out, call_statement(par_table_name, 'INSERT'));
  add_ln(lc_out, '} catch (SQLException sqle) {');
  add_ln(lc_out, 'Alerts.AlertSQL(sqle);');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  RETURN lc_out;
END CREATE_FUN;
--------------------------------------------------------------------------------
FUNCTION DELETE_FUN(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);

BEGIN

    add_ln(lc_out, 'public void delete(){');
        add_ln(lc_out, 'SQLExecutor.deleteRow("'||upper(par_table_name)||'", get'||initcap(csh.get_table_prefix(par_table_name))||'Code());');
    add_ln(lc_out, '}');
  
  RETURN lc_out;
END DELETE_FUN;
--------------------------------------------------------------------------------
END JAVAFX_DATA_CLASS_SYNTH;

/
