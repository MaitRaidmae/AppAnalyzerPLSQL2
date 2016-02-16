--------------------------------------------------------
--  DDL for Package Body JAVAFX_CONTROLLER_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."JAVAFX_CONTROLLER_SYNTH" 
IS

  ------------------------------------------------------------------------------
  -------------- PRIVATE MEHTODS -----------------------------------------------
  ------------------------------------------------------------------------------
--- State of 29/12/2015 23:38

FUNCTION TABLE_VIEW(
    PAR_TABLE_NAME VARCHAR2)
  RETURN VARCHAR2
IS

  LC_OUT        VARCHAR2(32000);
  lc_class      VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name);
  LC_INSTANCE   VARCHAR2(2000) := CSH.CAMEL_TABLENAME_WOB(PAR_TABLE_NAME, TRUE);
  LC_FACTORY    VARCHAR2(32000);
  
BEGIN

  ADD_LN(LC_OUT, 'ObservableList<'||CSH.CAMEL_TABLENAME_WOB(PAR_TABLE_NAME)||'> obsArrayList = FXCollections.observableArrayList();');
  add_ln(lc_out, 'CallableStatementResults callResults = SQLExecutor.getTablePage("'||PAR_TABLE_NAME||'", 1, results);');
  ADD_LN(LC_OUT, 'ResultSet query_results = callResults.getResultSet();');
  ADD_LN(LC_OUT, 'TableView<'||lc_class||'> '||LC_INSTANCE||'Table = new TableView();');
  add_ln(lc_out, LC_INSTANCE||'Table.getSelectionModel().selectedItemProperty().addListener((observable, oldValue, newValue) -> setCurr'||lc_class||'(newValue));');
  ADD_LN(LC_OUT, 'AnchorPane.setBottomAnchor('||LC_INSTANCE||'Table, 0.0);');
  ADD_LN(LC_OUT, 'AnchorPane.setTopAnchor('||LC_INSTANCE||'Table, 0.0);');
  ADD_LN(LC_OUT, 'AnchorPane.setRightAnchor('||LC_INSTANCE||'Table, 0.0);');
  ADD_LN(LC_OUT, 'AnchorPane.setLeftAnchor('||LC_INSTANCE||'Table, 0.0);');
  -- Add column declarations;
  FOR rTabCols IN CSH.cTabCols(PAR_TABLE_NAME)
  LOOP
    add_ln(lc_out, 'TableColumn '|| lower(rTabCols.column_name)||' = Helpers.initTableColumn("'||par_table_name||'", "'||rTabCols.column_name||'");');
  END LOOP;
  add_ln(lc_out, lc_instance||'Pane.getChildren().add('||lc_instance||'Table);');

  ADD_LN(LC_OUT, lc_instance||'Table.getColumns().setAll('||csh.COL_LIST(par_table_name)||');');
  add_ln(lc_out, 'try {');
  add_ln(lc_out, 'while (query_results.next()) {');
  add_ln(lc_out, lc_class||' dataInstance = new '||lc_class||csh.TABLE_PAR_LIST(par_table_name, 'query_results')||';');
  add_ln(lc_out, 'obsArrayList.add(dataInstance);');
  add_ln(lc_out, '}');

  -- This has some code remaining from editable Tables version - leaving it in for now;
  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    IF (csh.gr_par_type_map(rTabCols.column_name)                    != 'String') THEN
      IF (csh.IS_BOOLEAN_COLUMN(par_table_name, rTabCols.column_name) = 1) THEN
        lc_factory                                                   := 'new '||lc_class||'CheckBoxFactory()';
      ELSE
        lc_factory := 'TextFieldTableCell.forTableColumn(new StringToDecimal("'||csh.gr_par_type_map(rTabCols.column_name)||'"))';
      END IF;
    END IF;
    add_ln(lc_out, lower(rTabCols.column_name)||'.setCellValueFactory(new PropertyValueFactory<>("'||csh.SNAKE_TO_CAMEL(rTabCols.column_name)||'"));');
    IF (csh.IS_BOOLEAN_COLUMN(par_table_name, rTabCols.column_name) = 1) THEN
      add_ln(lc_out, lower(rTabCols.column_name)||'.setCellFactory('||lc_factory||');');
    END IF;
    lc_factory := 'TextFieldTableCell.forTableColumn()';
  END LOOP;
  -- Add tableRowFactory for the doubleClick Thingy (this has a bit of a problem though).

  add_ln(lc_out, lc_instance||'Table.setRowFactory(rowfactory -> {');
  add_ln(lc_out, '              TableRow<'||lc_class||'> row = new TableRow<>();');
  add_ln(lc_out, '            row.setOnMouseClicked(MouseEventHandler(row));');
  add_ln(lc_out, '              return row;');
  add_ln(lc_out, '          });  ');
  add_ln(lc_out, lc_instance||'Table.setItems(obsArrayList);');
  add_ln(lc_out, lc_instance||'Table.getColumns().setAll('||csh.COL_LIST(par_table_name)||');');
  add_ln(lc_out, '}');

  add_ln(lc_out, 'catch (SQLException sqle){');
  add_ln(lc_out, 'Alerts.AlertSQL(sqle);');
  add_ln(lc_out, '}');
  -- Close the statement
  add_ln(lc_out, 'callResults.close();');
  RETURN lc_out;
END TABLE_VIEW;
--------------------------------------------------------------------------------
FUNCTION GRID_VIEW(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);
  lc_class      VARCHAR2(2000) := CSH.CAMEL_TABLENAME_WOB(par_table_name);
  lc_instance   VARCHAR2(2000) := CSH.CAMEL_TABLENAME_WOB(par_table_name, TRUE);
BEGIN

  add_ln(lc_out, 'GridPane '||lc_instance||'Grid = '||lc_instance||'.getGrid(false);');

  RETURN lc_out;
END GRID_VIEW;

--------------------------------------------------------------------------------
-------------- PUBLIC MEHTODS --------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE CONTROLLER_CLASS(
    par_controller   VARCHAR2)
IS

  LC_TABLE      VARCHAR2(100) := CSH.PARENT_TABLE(PAR_CONTROLLER);
  lc_table_name VARCHAR2(100) := CSH.CAMEL_TABLENAME_WOB(lc_table);
  lc_instance   VARCHAR2(100) := CSH.CAMEL_TABLENAME_WOB(lc_table, TRUE);
  lr_app_controller B_APP_CONTROLLERS%ROWTYPE;
  lc_child_instance VARCHAR2(1000);
  lc_class          VARCHAR2(1000);
  lb_checkBox_col   BOOLEAN := false;

  CURSOR cAppController
  IS
    SELECT * FROM b_app_controllers WHERE aco_controller=par_controller;
  rAppController cAppController%rowtype;

BEGIN
  -- Generate import list
  doutln('import java.net.URL;
import java.util.ResourceBundle;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.control.cell.TextFieldTableCell;
import javafx.scene.control.Alert;
import javafx.scene.control.Alert.AlertType;
import javafx.geometry.Pos;

');

  OPEN cAppController;
  FETCH cAppController INTO rAppController;
  CLOSE cAppController;

  -- Generate class header
  doutln('public class '||CSH.CAMEL_TABLENAME_WOB(par_controller)||'Controller implements Initializable {');



  DOUTLN('@FXML');
  DOUTLN('private AnchorPane '||csh.CAMEL_TABLENAME_WOB(par_controller, false)||';');
  doutln('@FXML');
  DOUTLN('private AnchorPane '||LC_INSTANCE||'Pane;');

  FOR rChildren IN csh.cControllerChildren(upper(par_controller))
  LOOP
    doutln('@FXML');
    DOUTLN('private AnchorPane '||csh.CAMEL_TABLENAME_WOB(rChildren.cos_table, true)||'Pane;');
  END LOOP;

  -- Add object declarations
  doutln(lc_table_name||' '||lc_instance||';');
  
  -- Add parent object declaration;
  IF (rAppController.aco_parent_table IS NOT NULL) THEN
    doutln(csh.CAMEL_TABLENAME_WOB(rAppController.aco_parent_table, false)||' '||csh.CAMEL_TABLENAME_WOB(rAppController.aco_parent_table, true)||';');
  END IF;

  
  FOR rChildren IN csh.cControllerChildren(upper(par_controller))
  LOOP
    LC_CHILD_INSTANCE := CSH.CAMEL_TABLENAME_WOB(rChildren.cos_table, TRUE);
    LC_CLASS          := CSH.CAMEL_TABLENAME_WOB(rChildren.cos_table, FALSE);
    DOUTLN(lc_class||' '||lc_child_instance||';');
  END LOOP;
  doutln('Stage stage;');


  -- TODO: Move this to the initializer - Search button can just call initializer.
  /* TODO: Disregard previeous TODO - this is a stupid plan.
  Move this stuff to separate function and call it where you need to
  (buttons, initializers and stuff).
  */
  -- TODO: PS. Do the previous TODO.
  doutln('');
  doutln(SEARCH_DATA(lc_table));
  doutln('');

  DOUTLN('');
  doutln(SHOW_RESULTS(par_controller, rAppController.aco_view_type));
  doutln('');

  -- Generate ValueHandlers
  doutln('');
  doutln(CONTROLLER_EDIT_HANDLERS(lc_table));
  doutln('');

  -- Add Default MouseEventHandler for DoubleClickable TableRows
  doutln(JAVAFX_APP_SPEC_SYNTH.MOUSE_EVENT_HANDLER(par_controller));

  -- Add Cell Factory for CheckBoxes
  IF (upper(rAppController.aco_view_type) = 'TABLE') THEN
    FOR rTabCols IN csh.cTabCols(lc_table)
    loop
      IF (CSH.IS_BOOLEAN_COLUMN(lc_table,rTabCols.column_name) = 1) THEN
         doutln(CHECK_BOX_FACTORY(lc_table,rTabCols.column_name));
      end if;
    end loop;
  END IF;
  -- Add Cell factory for children
  FOR rChildren IN csh.cControllerChildren(upper(par_controller))
  loop
  IF (upper(rChildren.cos_view_type) = 'TABLE') THEN
    FOR rTabCols IN csh.cTabCols(rChildren.cos_table)
    loop
      IF (CSH.IS_BOOLEAN_COLUMN(rChildren.cos_table,rTabCols.column_name) = 1) THEN
         doutln(CHECK_BOX_FACTORY(rChildren.cos_table,rTabCols.column_name));
      end if;
    END loop;
  END IF;
  end loop;
  
  -- Add setStage function
  doutln(SET_STAGE);

  -- Add initObject function
  doutln(INIT_OBJECT(par_controller));
  
  -- Add ParentObjectSetter
  IF (rAppController.aco_parent_table IS NOT NULL) THEN
    doutln(SET_PARENT(rAppController.aco_parent_table));
  END IF;
  
  -- Add Table Row updaters for main object
  doutln(javafx_app_spec_synth.set_curr_object(par_controller,rAppController.aco_table));
  
  -- Add Table Row updaters for child tables
  FOR rChildren IN csh.cControllerChildren(upper(par_controller))
  loop
  IF (upper(rChildren.cos_view_type) = 'TABLE') THEN
    doutln(javafx_app_spec_synth.set_curr_object(par_controller,rChildren.cos_table));
  END IF;
  end loop;
  
  -- Add Custom Code 
  doutln(javafx_app_spec_synth.custom_code(par_controller));
  
  -- Add closing bracket for class body
  doutln('}');

END CONTROLLER_CLASS;
--------------------------------------------------------------------------------

FUNCTION SEARCH_DATA(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
AS
  lc_out VARCHAR2(32000);
BEGIN

  add_ln(lc_out, '@FXML');
  add_ln(lc_out, 'private void searchData(ActionEvent event) {');
  add_ln(lc_out, 'showResults();');
  add_ln(lc_out, '}');

  RETURN lc_out;
END SEARCH_DATA;
--------------------------------------------------------------------------------
FUNCTION CONTROLLER_EDIT_HANDLERS(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
AS
BEGIN
  -- TODO: Implementation required for FUNCTION JAVAFX_CONTROLLER_SYNTH.CONTROLLER_EDIT_HANDLERS
  RETURN NULL;
END CONTROLLER_EDIT_HANDLERS;
--------------------------------------------------------------------------------
FUNCTION CHECK_BOX_FACTORY(
    par_table_name VARCHAR2,
    par_parameter  VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out       VARCHAR2(32000);
  lc_class     VARCHAR2(200) := csh.camel_tablename_wob(par_table_name, false);
  lc_parameter VARCHAR2(200) := csh.snake_to_camel(par_parameter);

begin
  add_ln(lc_out, 'public class '||lc_class||'CheckBoxFactory<T, Boolean> implements Callback {');
  add_ln(lc_out, '@Override');
  add_ln(lc_out, 'public TableCell call(Object param) {');
  add_ln(lc_out, 'CheckBox checkBox = new CheckBox();');
  add_ln(lc_out, 'TableCell<Checks, Boolean> checkBoxCell = new TableCell() {');
  add_ln(lc_out, '@Override');
  add_ln(lc_out, 'public void updateItem(Object item, boolean empty) {');
  add_ln(lc_out, 'super.updateItem(item, empty);');

  add_ln(lc_out, 'if (empty || item == null) {');
  add_ln(lc_out, 'setText(null);');
  add_ln(lc_out, 'setGraphic(null);');
  add_ln(lc_out, '} else {');
  add_ln(lc_out, 'checkBox.setAlignment(Pos.CENTER);');
  add_ln(lc_out, 'setGraphic(checkBox);');
  add_ln(lc_out, lc_class||' data = ('||lc_class||') getTableRow().getItem();');
  add_ln(lc_out, 'if (data != null && data.get'||lc_parameter||'() == 1) {');
  add_ln(lc_out, 'checkBox.setSelected(true);');
  add_ln(lc_out, '} else {');
  add_ln(lc_out, 'checkBox.setSelected(false);');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  add_ln(lc_out, '};');

  add_ln(lc_out, 'checkBoxCell.addEventFilter(MouseEvent.MOUSE_CLICKED,');
  add_ln(lc_out, '(MouseEvent event) -> {');
  add_ln(lc_out, 'TableCell c = (TableCell) event.getSource();');
  add_ln(lc_out, 'CheckBox chkBox = (CheckBox) checkBoxCell.getChildrenUnmodifiable().get(0);');
  add_ln(lc_out, lc_class||' data = ('||lc_class||') c.getTableRow().getItem();');

  add_ln(lc_out, 'if (chkBox.isSelected()) {');
  add_ln(lc_out, 'data.set'||lc_parameter||'(1);');
  add_ln(lc_out, '} else {');
  add_ln(lc_out, 'data.set'||lc_parameter||'(0);');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');
  add_ln(lc_out, ');');

  add_ln(lc_out, 'return checkBoxCell;');
  add_ln(lc_out, '}');
  add_ln(lc_out, '}');

  RETURN lc_out;
END CHECK_BOX_FACTORY;
--------------------------------------------------------------------------------
FUNCTION SHOW_RESULTS(
    PAR_CONTROLLER   VARCHAR2,
    PAR_DISPLAY_TYPE VARCHAR2)
  RETURN VARCHAR2
IS

  LC_OUT   VARCHAR2(32000);
  lc_table VARCHAR2(200) := CSH.parent_table(par_controller);

BEGIN
  -- Connection manager for getting database connection
  csh.map_pars(lc_table);
  add_ln(lc_out, 'public void showResults(){showResults(99999999);}'); -- Overloading default
  ADD_LN(LC_OUT, 'public void showResults(Integer results) {');
  IF (upper(par_display_type) = 'TABLE') THEN
    ADD_LN(LC_OUT, TABLE_VIEW(LC_TABLE));
  elsif (upper(par_display_type) = 'GRID') THEN
    add_ln(lc_out, GRID_VIEW(lc_table));
  END IF;
  add_ln(lc_out, '');

  -- Close function bracket
  add_ln(lc_out, '}');
  RETURN lc_out;
END SHOW_RESULTS;
--------------------------------------------------------------------------------
FUNCTION SET_STAGE
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);

BEGIN
  add_ln(lc_out, 'public void setStage(Stage newStage) {');
  add_ln(lc_out, '    stage = newStage;');
  add_ln(lc_out, '}');
  RETURN lc_out;
END SET_STAGE;
--------------------------------------------------------------------------------
FUNCTION INIT_OBJECT(
    par_controller VARCHAR2)
  RETURN VARCHAR2
IS

  LC_OUT            VARCHAR2(32000);
  lc_table          VARCHAR2(2000) := CSH.parent_table(par_controller);
  lc_table_name     VARCHAR2(2000) := csh.camel_tablename_wob(lc_table);
  lc_instance       VARCHAR2(2000) := csh.camel_tablename_wob(lc_table, true);
  lc_child_instance VARCHAR2(2000);

BEGIN
  add_ln(lc_out, 'public void initObjects('||lc_table_name||' newInstance) {');
  add_ln(lc_out, '');
  --TODO figure out some params stuff for the resource
  ADD_LN(LC_OUT, LC_INSTANCE||' = newInstance;');
  add_ln(lc_out, 'GridPane '||lc_instance||'Grid = '||lc_instance||'.getGrid(true);');
  ADD_LN(LC_OUT, 'CssLoader css = new CssLoader("/applicationanalyzer/FXML/CSS/'||LC_TABLE_NAME||'.css", "'||LC_INSTANCE||'Grid");');
  ADD_LN(LC_OUT, LC_INSTANCE||'Grid.getColumnConstraints().add(new ColumnConstraints(css.GRID_COL1_WIDTH));');
  ADD_LN(LC_OUT, LC_INSTANCE||'Grid.getColumnConstraints().add(new ColumnConstraints(css.GRID_COL2_WIDTH));');
  add_ln(lc_out, lc_instance||'Grid.getStyleClass().add("'||lc_instance||'Grid");');
  add_ln(lc_out, lc_instance||'Pane.getChildren().add('||lc_instance||'Grid);');

  FOR rChildren IN csh.cControllerChildren(par_controller)
  LOOP
    lc_child_instance          := csh.camel_tablename_wob(rChildren.cos_table, true);
    
    
    IF (rChildren.cos_view_type = 'TABLE') THEN
      add_ln(lc_out, 'TableView '||lc_child_instance||'Table;');
      add_ln(lc_out, table_view(rChildren.cos_table));
    elsif (rChildren.cos_view_type = 'GRID') THEN
      add_ln(lc_out, GRID_VIEW(rChildren.cos_table));
    END IF;
    add_ln(lc_out, lc_child_instance||'Pane.getChildren().add('||lc_child_instance||initcap(rChildren.cos_view_type)||');');
  END LOOP;

  add_ln(lc_out, '}');

  RETURN lc_out;
END INIT_OBJECT;
--------------------------------------------------------------------------------
FUNCTION SET_PARENT(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);
  lc_class     VARCHAR2(200) := csh.camel_tablename_wob(par_table_name);
  lc_instance  varchar2(200) := csh.camel_tablename_wob(par_table_name,true);
  
begin
  add_ln(lc_out, 'public void set'||lc_class||'('||lc_class||' new'||lc_class||') {');
  add_ln(lc_out, lc_instance||' = new'||lc_class||';');
  add_ln(lc_out, '}');
  RETURN lc_out;
END SET_PARENT;

END JAVAFX_CONTROLLER_SYNTH;

/
