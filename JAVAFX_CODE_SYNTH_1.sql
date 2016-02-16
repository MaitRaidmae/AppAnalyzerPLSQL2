--------------------------------------------------------
--  DDL for Package Body JAVAFX_CODE_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."JAVAFX_CODE_SYNTH" 
IS
  -- Here are local functions - i.e functions that are not visible outsid the package
  ------------------------------------------------------------------------------
  -- Procedure maps the pl/sql types to Java types per parameter
PROCEDURE MAP_PARS(
    par_table_name VARCHAR2)
IS

BEGIN
  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    -- Generate properties
    IF (rTabCols.data_type                   = 'NUMBER' AND rTabCols.data_scale = 0) THEN
      gr_par_type_map(rTabCols.column_name) := 'Integer';
    ELSIF (rTabCols.data_type                = 'NUMBER') THEN
      gr_par_type_map(rTabCols.column_name) := 'Double';
    ELSIF (rTabCols.data_type                = 'VARCHAR2' OR rTabCols.data_type = 'CHAR') THEN
      gr_par_type_map(rTabCols.column_name) := 'String';
    ELSIF (rTabCols.data_type                = 'TIMESTAMP(6)') THEN
      gr_par_type_map(rTabCols.column_name) := 'Date';
    END IF;
  END LOOP;
END;
--------------------------------------------------------------------------------
FUNCTION SNAKE_TO_CAMEL(
    par_string VARCHAR2)
  RETURN VARCHAR2
IS

BEGIN
  RETURN REPLACE(initcap(par_string), '_', '');
END;
--------------------------------------------------------------------------------
FUNCTION indent(
    par_indent_lvl IN pls_integer)
  RETURN VARCHAR2
IS
  li_i pls_integer;
  lc_return VARCHAR2(100):='';
BEGIN
  FOR i IN 1..par_indent_lvl*gn_indent_size
  LOOP
    lc_return:=lc_return || ' ';
  END LOOP;
  RETURN lc_return;
END;

------------------------------------------------------------------------------
FUNCTION COL_TAG(
    par_fxid VARCHAR2,
    par_text VARCHAR2)
  RETURN xmltype
IS

  lc_tag VARCHAR2(2000);

BEGIN
  lc_tag :='<TableColumn';
  lc_tag :=lc_tag || ' fx:id="'||par_fxid||'"';
  lc_tag :=lc_tag || ' text="'||par_text||'"';
  lc_tag := lc_tag || ' />';

  RETURN xmltype(lc_tag);

END;
------------------------------------------------------------------------------
PROCEDURE ADD_LN(
    par_clob    IN OUT CLOB,
    par_string2 IN VARCHAR2)
IS

BEGIN
  par_clob:=par_clob||CHR(10)||par_string2;
END;
------------------------------------------------------------------------------
FUNCTION CAMEL_TABLENAME_WOB(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_table_name VARCHAR2(100) := lower(par_table_name);
BEGIN
  -- Remove b_ or v_ from table_name
  lc_table_name := regexp_replace(lc_table_name, 'b_', '', 1, 1);
  lc_table_name := regexp_replace(lc_table_name, 'v_', '', 1, 1);
  -- initcap and remove _ thingies
  lc_table_name := REPLACE(initcap(lc_table_name), '_', '');

  RETURN lc_table_name;
END;
------------------------------------------------------------------------------
FUNCTION TABLE_PAR_LIST(
    par_table_name    VARCHAR2,
    par_variable_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_parameters VARCHAR2(2000);
  li_i PLS_INTEGER := 0;

BEGIN

  MAP_PARS(par_table_name);
  lc_parameters := '(';
  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    li_i:=li_i+1;
    -- Generate pars
    lc_parameters := lc_parameters ||par_variable_name||'.get'||
    CASE gr_par_type_map(rTabCols.column_name)
    WHEN 'Integer' THEN
      'Int'
    ELSE
      gr_par_type_map(rTabCols.column_name)
    END||'('||li_i||')'||','||CHR(10);
  END LOOP;

  -- Cut last coma and newline
  lc_parameters := SUBSTR(lc_parameters, 1, LENGTH(lc_parameters)-2)||')';

  RETURN lc_parameters;
END;
------------------------------------------------------------------------------
FUNCTION COL_LIST(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(2000);

BEGIN
  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    lc_out:=lc_out||lower(rTabCols.column_name)||',';
  END LOOP;
  RETURN SUBSTR(lc_out, 1, LENGTH(lc_out)-1);
END;

------------------------------------------------------------------------------
FUNCTION IS_BOOLEAN_COLUMN(
    par_table_name  VARCHAR2,
    par_column_name VARCHAR2) return BOOLEAN
IS

lc_owner varchar2(2000);

BEGIN
 EXECUTE IMMEDIATE 'SELECT owner FROM user_constraints WHERE table_name = '''||par_table_name||''' AND
constraint_name like ''%'||par_column_name||'_BOOLEAN%''' into lc_owner;
 IF (LENGTH(lc_owner) > 0) THEN
    RETURN TRUE;
 ELSE 
    RETURN FALSE;
 END IF;
 
 exception WHEN no_data_found THEN
   return false;
 
END IS_BOOLEAN_COLUMN;

-- Helper Generator Methods used in (some may be published due to some technicalities)
FUNCTION DEFAULT_DOUBLECLICK_HANDLER(par_table_name VARCHAR2) RETURN VARCHAR2 IS

lc_out VARCHAR2(32000) := '';
lc_tablename varchar2(2000) := CAMEL_TABLENAME_WOB(par_table_name);

begin

add_ln(lc_out,'private EventHandler<MouseEvent> MouseEventHandler(TableRow<'||lc_tablename||'> row) {');
add_ln(lc_out,'         EventHandler<MouseEvent> doubleClick');
add_ln(lc_out,'                    = new EventHandler<MouseEvent>() {');
add_ln(lc_out,'                    @Override');
add_ln(lc_out,'                    public void handle(final MouseEvent doubleClick) {');
add_ln(lc_out,'                        if (doubleClick.getClickCount() >= 2) {');
add_ln(lc_out,'                            //Add Setting dataSTore element here EXAMPLE: ');
add_ln(lc_out,'                            //dataStore.setCurrentSuite(row.getItem().getChsCode());');
add_ln(lc_out,'                            try {');
add_ln(lc_out,'                                FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource(<<<<ADD_RESOURCE_HERE>>>>>);');
add_ln(lc_out,'                                Parent root1 = (Parent) fxmlLoader.load();');
add_ln(lc_out,'                                Stage stage = new Stage();');
add_ln(lc_out,'                                stage.setScene(new Scene(root1));');
add_ln(lc_out,'                                stage.setTitle("<<<<SET_TITLE>>>>>");');
add_ln(lc_out,'                                stage.getIcons().add(new Image("/applicationanalyzer/icon.png"));');
add_ln(lc_out,'                                stage.show();');
add_ln(lc_out,'                            } catch (Exception e) {');
add_ln(lc_out,'                                Alert alert = new Alert(Alert.AlertType.ERROR);');
add_ln(lc_out,'                                alert.setTitle("Errror!!! AAAaaaaerrgggh!!");');
add_ln(lc_out,'                                alert.setHeaderText("Error loading new window");');
add_ln(lc_out,'                                System.out.println("Error loading new window " + e.getMessage());');
add_ln(lc_out,'                                alert.setContentText(e.getMessage());');
add_ln(lc_out,'                                alert.showAndWait();');
add_ln(lc_out,'                            }');
add_ln(lc_out,'                        }');
add_ln(lc_out,'                    }');
add_ln(lc_out,'                };');
add_ln(lc_out,'        RETURN doubleClick;');
add_ln(lc_out,'    }');

return lc_out;

end;

------------------------------------------------------------------------------
-- Public methods (i.e. they are declared in package header)
PROCEDURE DATA_CLASS(
    par_table_name VARCHAR2)
IS
  lc_table_name VARCHAR2(100);
  lc_buffer     VARCHAR2(32000):= '';

BEGIN

  -- Map parameters:
  MAP_PARS(par_table_name);
  -- convert input to lowercase
  lc_table_name := lower(par_table_name);
  -- Generate header imports etc
  lc_buffer := 'import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.SimpleDoubleProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
' ;
  doutln(lc_buffer);
  lc_table_name := CAMEL_TABLENAME_WOB(lc_table_name);
  -- Generate class declaration
  doutln('public class ' ||lc_table_name|| '{');

  -- Generate general properties
  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    doutln(indent(1)||'private final Simple'||gr_par_type_map(rTabCols.column_name)||'Property '||lower(rTabCols.column_name)||';');
  END LOOP;

  -- Add empty line
  doutln('');

  -- Add constructor to the class
  DATA_CONSTRUCTOR(par_table_name);
  -- Add empty line
  doutln('');

  --Generate getters and setters
  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    GETTER(rTabCols.column_name, par_table_name);
    doutln('');
    SETTER(rTabCols.column_name, par_table_name);
    doutln('');
  END LOOP;
  -- Add closing bracket
  doutln('}');

END DATA_CLASS;

------------------------------------------------------------------------------
PROCEDURE DATA_CONSTRUCTOR(
    par_table_name VARCHAR2)
IS

  lc_table_name VARCHAR2(100);
  lc_buffer     VARCHAR2(32000):= '';
  lc_parameters VARCHAR2(32000):= '';

BEGIN
  lc_table_name := CAMEL_TABLENAME_WOB(par_table_name);

  -- Map pars just in case
  MAP_PARS(par_table_name);
  -- Generate parameters list
  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    -- Generate pars
    lc_parameters := lc_parameters ||gr_par_type_map(rTabCols.column_name)||' '||lower(rTabCols.column_name)||','||CHR(10);
  END LOOP;

  -- Cut last coma and newline
  lc_parameters := SUBSTR(lc_parameters, 1, LENGTH(lc_parameters)-2);

  -- Generate constructor
  doutln(indent(1)||'public ' ||lc_table_name|| '('|| lc_parameters||'){');
  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    doutln(indent(1)||'this.'||lower(rTabCols.column_name)|| ' = new Simple'||gr_par_type_map(rTabCols.column_name)||'Property('||lower(rTabCols.column_name)||');');
  END LOOP;

  doutln('}');
END DATA_CONSTRUCTOR;
------------------------------------------------------------------------------
PROCEDURE GETTER(
    par_par_name   VARCHAR2,
    par_table_name VARCHAR2)
IS

BEGIN
  -- Generate getter function
  doutln('public '||gr_par_type_map(par_par_name)||' get'||SNAKE_TO_CAMEL(par_par_name)||'() {');
  doutln(indent(1)||'return '||lower(par_par_name)||'.get();');
  doutln('}');
END GETTER;
------------------------------------------------------------------------------
PROCEDURE SETTER(
    par_par_name   VARCHAR2,
    par_table_name VARCHAR2)
IS

  lc_local_name VARCHAR2(50)   := lower(SUBSTR(par_par_name, instr(par_par_name, '_', 1)+1, 99));
  lc_table_prefix varchar2(10) := lower(SUBSTR(par_par_name, 1,instr(par_par_name, '_', 1)-1));

BEGIN
  doutln('public void set'||SNAKE_TO_CAMEL(par_par_name)||'('||gr_par_type_map(par_par_name)||' '||lc_local_name||') {');
  doutln(indent(1)||lower(par_par_name)||'.set('||lc_local_name||');');
  IF (gr_par_type_map(par_par_name) = 'String') THEN
    doutln('boolean execution = SQLExecutor.executeProcedure("P_CHECKS.UPDATE_ROW_CVALUE("+this.get'||initcap(lc_table_prefix)||'Code()+",'''||par_par_name||''',''"+'||lc_local_name||'+"''));');
  ELSE
    doutln('boolean execution = SQLExecutor.executeProcedure("P_CHECKS.UPDATE_ROW_NVALUE("+this.get'||initcap(lc_table_prefix)||'Code()+",'''||par_par_name||''',"+'||lc_local_name||'+ ")");');
  end if;
  doutln('}');
END SETTER;
------------------------------------------------------------------------------
PROCEDURE TABLE_VIEW(
    par_table_name VARCHAR2)
IS

  lc_table_name VARCHAR2(100) := lower(par_table_name);
  xml_columns XMLTYPE;
  xml_TableView XMLTYPE;
  xml_varchar VARCHAR2(32000);

BEGIN

  -- Convert table name
  lc_table_name := CAMEL_TABLENAME_WOB(par_table_name);

  SELECT XMLELEMENT("columns", -- Columns main tab
    xmlagg(XMLELEMENT("TableColumn", xmlattributes(lower(column_name) AS "fx:id", column_name AS "text", '#handle'||Snake_to_camel(column_name)||'EditCommit' as "onEditCommit")) ))
  INTO xml_columns
  FROM user_tab_cols
  WHERE table_name=par_table_name;

  SELECT XMLELEMENT("TableView", XMLATTRIBUTES('tblv_' ||lc_table_name AS "fx:id", 'true' as "editable"), xml_columns )
  INTO xml_TableView
  FROM dual;
  xml_varchar :=xml_TableView.getStringVal;
  doutln(xml_varchar);

END;
------------------------------------------------------------------------------
PROCEDURE CONTROLLER_CLASS(
    par_table_name VARCHAR2)
IS

  lc_table_name VARCHAR2(100);
  lc_out CLOB;

BEGIN
  -- Generate import list
  add_ln(lc_out, 'import java.net.URL;
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

  -- Convert table name string
  lc_table_name := CAMEL_TABLENAME_WOB(par_table_name);

  -- Generate class header

  add_ln(lc_out, 'public class '||lc_table_name||'Controller implements Initializable {');

  -- Generate FXML parameters
  add_ln(lc_out, '@FXML');
  add_ln(lc_out, 'private TableView tblv_'||lc_table_name||';');

  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    add_ln(lc_out, '@FXML');
    add_ln(lc_out, 'private TableColumn '|| lower(rTabCols.column_name)||';');
  END LOOP;

  -- Generate handleGetData - general function for retrieving table data;
  -- TODO: Move this to the initializer - Search button can just call initializer.
  add_ln(lc_out, '');
  add_ln(lc_out, CONTROLLER_GET_DATA_TABLE(par_table_name));
  add_ln(lc_out, '');

  -- Generate ValueHandlers
  add_ln(lc_out, '');
  add_ln(lc_out, CONTROLLER_EDIT_HANDLERS(par_table_name));
  add_ln(lc_out, '');

  add_ln(lc_out, '@Override
public void initialize(URL url, ResourceBundle rb){}');
  
  -- Add Default MouseEventHandler for DoubleClickable TableRows
  add_ln(lc_out,DEFAULT_DOUBLECLICK_HANDLER(par_table_name));
 
  -- Add Cell Factory for CheckBoxes
  add_ln(lc_out, CHECK_BOX_FACTORY(par_table_name));
  -- Add closing bracket for class body
  add_ln(lc_out, '}');
  doutln(lc_out);
END CONTROLLER_CLASS;
--------------------------------------------------------------------------------
FUNCTION CONTROLLER_GET_DATA_TABLE(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out                 VARCHAR2(32000);
  lc_factory             VARCHAR2(100) := 'TextFieldTableCell.forTableColumn()';

BEGIN
  -- Connection manager for getting database connection
  MAP_PARS(par_table_name);
add_ln(lc_out, 'public void showResults(Integer results) {');
add_ln(lc_out, 'ObservableList<'||CAMEL_TABLENAME_WOB(par_table_name)||'> obsArrayList = FXCollections.observableArrayList();');
add_ln(lc_out, 'CallableStatementResults callResults = SQLExecutor.getTablePage("'||regexp_replace(upper(par_table_name),'B_','P_',1,1)||'", 1, results);');
add_ln(lc_out, 'ResultSet query_results = callResults.getResultSet();   ');

  add_ln(lc_out, 'try {');
  add_ln(lc_out, 'while (query_results.next()) {');
  add_ln(lc_out, CAMEL_TABLENAME_WOB(par_table_name)||' dataInstance = new '||CAMEL_TABLENAME_WOB(par_table_name)||TABLE_PAR_LIST(par_table_name, 'query_results')||';');
  add_ln(lc_out, 'obsArrayList.add(dataInstance);');
  add_ln(lc_out, '}');

  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    IF (gr_par_type_map(rTabCols.column_name) != 'String') THEN
      IF (IS_BOOLEAN_COLUMN(par_table_name,rTabCols.column_name) = TRUE) THEN
        lc_factory                  := 'new CheckBoxCellFactory()';
      ELSE 
        lc_factory                  := 'TextFieldTableCell.forTableColumn(new StringToDecimal("'||gr_par_type_map(rTabCols.column_name)||'"))';
      end if;
    END IF;
    add_ln(lc_out, lower(rTabCols.column_name)||'.setCellValueFactory(new PropertyValueFactory<>("'||SNAKE_TO_CAMEL(rTabCols.column_name)||'"));');
    add_ln(lc_out, lower(rTabCols.column_name)||'.setCellFactory('||lc_factory||');');
    lc_factory := 'TextFieldTableCell.forTableColumn()';
  END LOOP;
  -- Add tableRowFactory for the doubleClick Thingy (this has a bit of a problem though).
  
  add_ln(lc_out, 'tblv_'||CAMEL_TABLENAME_WOB(par_table_name)||'.setRowFactory(rowfactory -> {');
  add_ln(lc_out,'              TableRow<'||CAMEL_TABLENAME_WOB(par_table_name)||'> row = new TableRow<>();');
  add_ln(lc_out,'            row.setOnMouseClicked(MouseEventHandler(row));');
  add_ln(lc_out,'              return row;');
  add_ln(lc_out,'          });  ');
  add_ln(lc_out, 'tblv_'||CAMEL_TABLENAME_WOB(par_table_name)||'.setItems(obsArrayList);');
  add_ln(lc_out, 'tblv_'||CAMEL_TABLENAME_WOB(par_table_name)||'.getColumns().setAll('||COL_LIST(par_table_name)||');');
  add_ln(lc_out, '}');

  add_ln(lc_out, 'catch (SQLException sqle){');
  add_ln(lc_out, 'AlertSQL.AlertSQL(sqle);');
  add_ln(lc_out, '}');
  add_ln(lc_out, '');
  -- Close function bracket
  add_ln(lc_out, '}');
  RETURN lc_out;
END CONTROLLER_GET_DATA_TABLE;
--------------------------------------------------------------------------------
FUNCTION CONTROLLER_EDIT_HANDLERS(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);
  lc_tbl VARCHAR2(2000);
  lc_col VARCHAR2(2000);

BEGIN
  MAP_PARS(par_table_name);
  lc_tbl := CAMEL_TABLENAME_WOB(par_table_name);
  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    lc_col := SNAKE_TO_CAMEL(rTabCols.column_name);

    add_ln(lc_out, '@FXML');
    add_ln(lc_out, 'public void handle'||lc_col||'EditCommit(CellEditEvent<'||lc_tbl||', '|| gr_par_type_map(rTabCols.column_name) ||'> t) {');
    add_ln(lc_out, lc_tbl||' data = ('||lc_tbl||') t.getTableView().getItems().get(');
    add_ln(lc_out, 't.getTablePosition().getRow());');
    add_ln(lc_out, 'data.set'||lc_col||'(t.getNewValue());');
    add_ln(lc_out, '}');
    add_ln(lc_out, '');

  END LOOP;

  RETURN lc_out;
END CONTROLLER_EDIT_HANDLERS;
--------------------------------------------------------------------------------
FUNCTION CHECK_BOX_FACTORY(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);
  lc_tbl VARCHAR2(2000);
  lc_col VARCHAR2(2000);

BEGIN
  MAP_PARS(par_table_name);
  lc_tbl    := CAMEL_TABLENAME_WOB(par_table_name);


  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    lc_col  := SNAKE_TO_CAMEL(rTabCols.column_name);
    IF (IS_BOOLEAN_COLUMN(par_table_name, rTabCols.column_name) = TRUE) THEN
      
      add_ln(lc_out, 'public class CheckBoxCellFactory<T, Boolean> implements Callback {      

@Override    
public TableCell call(Object param) {        
CheckBox checkBox = new CheckBox();');
      add_ln(lc_out, 'TableCell<'||lc_tbl||', Boolean> checkBoxCell = new TableCell() {');
      add_ln(lc_out, ' @Override            
public void updateItem(Object item, boolean empty) {                
super.updateItem(item, empty);                

if (empty || item == null) {                    
setText(null);                    
setGraphic(null);                
} else {                    
checkBox.setAlignment(Pos.CENTER);                    
setGraphic(checkBox);');
      add_ln(lc_out, lc_tbl||' data = ('||lc_tbl||') getTableRow().getItem();');
      add_ln(lc_out, 'if(data != null && data.getChkActive() == 1) {                        
checkBox.setSelected(true);                    
} else {                        
checkBox.setSelected(false);                    
}                
}            
}        
};        

checkBoxCell.addEventFilter(MouseEvent.MOUSE_CLICKED,                
(MouseEvent event) -> {                    
TableCell c = (TableCell) event.getSource();                    
CheckBox chkBox = (CheckBox) checkBoxCell.getChildrenUnmodifiable().get(0);');
      add_ln(lc_out, lc_tbl||' data = ('||lc_tbl||') c.getTableRow().getItem();');
      add_ln(lc_out, '');
      add_ln(lc_out, 'if (chkBox.isSelected()){');
      add_ln(lc_out, 'data.set'||lc_col||'(1);');
      add_ln(lc_out, '} else {');
      add_ln(lc_out, 'data.set'||lc_col||'(0);');
      add_ln(lc_out, '                    }                
}        
);                

return checkBoxCell;    
}
}');
    END IF;
  END LOOP;

return lc_out;

END CHECK_BOX_FACTORY;
--------------------------------------------------------------------------------

END JAVAFX_CODE_SYNTH;

/
