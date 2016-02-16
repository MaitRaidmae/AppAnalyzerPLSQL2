--------------------------------------------------------
--  DDL for Package Body JAVAFX_APP_SPEC_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."JAVAFX_APP_SPEC_SYNTH" 
AS

FUNCTION MOUSE_EVENT_HANDLER(
    PAR_CONTROLLER VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out   VARCHAR2(32000) ;
  lc_table VARCHAR2(2000) ;
  lc_class    VARCHAR2(2000);
BEGIN

  SELECT ACO_TABLE
  INTO LC_TABLE
  FROM B_APP_CONTROLLERS
  WHERE ACO_CONTROLLER = PAR_CONTROLLER;
  
  lc_class := csh.CAMEL_TABLENAME_WOB(lc_table);
  -- TODO: Implementation required for FUNCTION JAVAFX_APP_SPEC_SYNTH.MOUSE_EVENT_HANDLER
  CASE(upper(LC_TABLE))
  WHEN 'B_APPLICATIONS' THEN
    ADD_LN(lc_out, 'private EventHandler<MouseEvent> MouseEventHandler(TableRow<'||lc_class||'> row) {') ;
    ADD_LN(lc_out, 'EventHandler<MouseEvent> mouseEvent') ;
    ADD_LN(lc_out, '= new EventHandler<MouseEvent>() {') ;
    ADD_LN(lc_out, '@Override') ;
    ADD_LN(lc_out, 'public void handle(final MouseEvent event) {') ;
    Add_ln(lc_out, 'Applications currApp = row.getItem();') ;
    ADD_LN(lc_out, 'if (event.getClickCount() >= 2) {') ;
    ----------------------------------------------------------------------------
    ADD_LN(lc_out, 'try {') ;
    ADD_LN(lc_out, 'FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/applicationanalyzer/FXML/ApplicationChecks.fxml"));') ;
    ADD_LN(LC_OUT, 'AnchorPane page = (AnchorPane) fxmlLoader.load();') ;
    ADD_LN(LC_OUT, 'Stage newStage = new Stage();') ;
    ADD_LN(LC_OUT, 'newStage.setTitle("Application Checks for: " + currApp.getAplName());') ;
    ADD_LN(LC_OUT, 'newStage.initModality(Modality.WINDOW_MODAL);') ;
    ADD_LN(lc_out, 'newStage.initOwner('||csh.snake_to_camel(par_controller, false) ||'.getScene().getWindow());') ;
    ADD_LN(lc_out, 'Scene scene = new Scene(page);') ;
    ADD_LN(lc_out, 'newStage.setScene(scene);') ;
    ADD_LN(lc_out, 'scene.getStylesheets().add("/applicationanalyzer/FXML/CSS/ApplicationChecks.css");') ;
    ADD_LN(lc_out, 'ApplicationChecksController controller = fxmlLoader.getController();') ;
    ADD_LN(lc_out, 'controller.initObject(currApp);') ;
    ADD_LN(LC_OUT, 'controller.setStage(editStage);') ;
    ADD_LN(lc_out, 'newStage.showAndWait();') ;
    ADD_LN(lc_out, '} catch (IOException e) {') ;
    ADD_LN(lc_out, 'Alerts.AlertIO(e);') ;
    ADD_LN(lc_out, '}') ;
    ---------------------------------------------------------------------------
    ADD_LN(lc_out, '} else if (event.getButton() == MouseButton.SECONDARY) {') ;
    ADD_LN(lc_out, '// Add rightClick Event here (open popupMenu for example') ;
    ADD_LN(lc_out, '}') ;
    ADD_LN(lc_out, '}') ;
    ADD_LN(lc_out, '};') ;
    ADD_LN(lc_out, 'return mouseEvent;') ;
    ADD_LN(LC_OUT, '}') ;
  WHEN 'B_CHECK_SUITS' THEN
    ADD_LN(lc_out, 'private EventHandler<MouseEvent> MouseEventHandler(TableRow<CheckSuits> row) {') ;
    ADD_LN(lc_out, 'EventHandler<MouseEvent> mouseEvent') ;
    ADD_LN(lc_out, '= new EventHandler<MouseEvent>() {') ;
    ADD_LN(lc_out, '@Override') ;
    ADD_LN(LC_OUT, 'public void handle(final MouseEvent event) {') ;
    Add_ln(lc_out, 'CheckSuits currSuite = row.getItem();') ;
    ADD_LN(lc_out, 'if (event.getClickCount() >= 2) {') ;
    ----------------------------------------------------------------------------
    ADD_LN(lc_out, 'try {') ;
    ADD_LN(lc_out, 'FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/applicationanalyzer/FXML/Checks.fxml"));') ;
    ADD_LN(LC_OUT, 'AnchorPane page = (AnchorPane) fxmlLoader.load();') ;
    ADD_LN(LC_OUT, 'Stage newStage = new Stage();') ;
    ADD_LN(LC_OUT, 'newStage.setTitle("Suite " + currSuite.getChsMnemo() + " checks : ");') ;
    ADD_LN(lc_out, 'Scene scene = new Scene(page);') ;
    ADD_LN(LC_OUT, 'newStage.setScene(scene);') ;
    ADD_LN(lc_out, 'scene.getStylesheets().add("/applicationanalyzer/FXML/CSS/Checks.css");') ;
    ADD_LN(LC_OUT, 'ApplicationChecksController controller = fxmlLoader.getController();') ;
    ADD_LN(LC_OUT, 'controller.initObject(currSuite);') ;
    ADD_LN(LC_OUT, 'controller.setStage(newStage);') ;
    ADD_LN(lc_out, 'newStage.showAndWait();') ;
    ADD_LN(lc_out, '} catch (IOException e) {') ;
    ADD_LN(lc_out, 'Alerts.AlertIO(e);') ;
    ADD_LN(lc_out, '}') ;
    ---------------------------------------------------------------------------
    ADD_LN(lc_out, '} else if (event.getButton() == MouseButton.SECONDARY) {') ;
    ADD_LN(lc_out, '// Add rightClick Event here (open popupMenu for example') ;
    ADD_LN(lc_out, '}') ;
    ADD_LN(lc_out, '}') ;
    ADD_LN(lc_out, '};') ;
    ADD_LN(LC_OUT, 'return mouseEvent;') ;
    ADD_LN(LC_OUT, '}') ;
  WHEN 'B_CHECKS' THEN
    add_ln(lc_out,
    '    private EventHandler<MouseEvent> MouseEventHandler(TableRow<Checks> row) {        
EventHandler<MouseEvent> mouseEvent                
= new EventHandler<MouseEvent>() {                    
@Override                    
public void handle(final MouseEvent event) {                        
if (event.getClickCount() >= 2) {
//Add DoubleClick Event here                        
} else if (event.getButton() == MouseButton.SECONDARY) {
// Add rightClick Event here (open popupMenu for example                            
ContextMenu contextMenu = new ContextMenu();                            
MenuItem editItem = new MenuItem("Edit");                            
Checks check = row.getItem();                            
editItem.setOnAction(new EventHandler<ActionEvent>() {                                
@Override                                
public void handle(ActionEvent e) {                                    
check.showEditDialog(checksPane.getScene().getWindow());                                    
initialize(null, null);                                
}                            
});                            
contextMenu.getItems().add(editItem);                            
contextMenu.show(row, event.getScreenX(), event.getScreenY());                        
}                    
}                
};        
return mouseEvent;    
}'
    ) ;
  ELSE
    ADD_LN(lc_out, 'private EventHandler<MouseEvent> MouseEventHandler(TableRow<'||lc_class||'> row) {') ;
    ADD_LN(lc_out, '    EventHandler<MouseEvent> mouseEvent') ;
    ADD_LN(lc_out, '= new EventHandler<MouseEvent>() {') ;
    ADD_LN(lc_out, '@Override') ;
    ADD_LN(lc_out, 'public void handle(final MouseEvent event) {') ;
    ADD_LN(lc_out, 'if (event.getClickCount() >= 2) {') ;
    ADD_LN(lc_out, '//Add DoubleClick Event here') ;
    ADD_LN(lc_out, '} else if (event.getButton() == MouseButton.SECONDARY) {') ;
    ADD_LN(lc_out, '// Add rightClick Event here (open popupMenu for example') ;
    ADD_LN(lc_out, '}') ;
    ADD_LN(lc_out, '}') ;
    ADD_LN(lc_out, '};') ;
    ADD_LN(lc_out, 'return mouseEvent;') ;
    ADD_LN(lc_out, '}') ;

  END CASE;

  RETURN lc_out;
END MOUSE_EVENT_HANDLER;
------------------------------------------------------------------------------
FUNCTION SET_CURR_OBJECT(
    par_controller VARCHAR2,
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out      VARCHAR2(32000) ;
  lc_class    VARCHAR2(2000) := csh.CAMEL_TABLENAME_WOB(par_table_name) ;
  lc_instance VARCHAR2(2000) := CSH.CAMEL_TABLENAME_WOB(par_table_name, TRUE) ;

BEGIN

  CASE(par_controller)
  WHEN 'CHECKS' THEN
    add_ln(lc_out, 'private void setCurr'||lc_class||'('||lc_class||' new'||lc_class||'){
'||lc_instance||' = new'||lc_class||
    ';
checkParsPane.getChildren().clear();        
checkLovPane.getChildren().clear();        
list = null;                

switch (check.getChkType()) {            
case "MIN":            
case "MAX":                
mmPars  = new MinmaxCheckPars(check.getChkCode());                
grid    = mmPars.getGrid(false);                
break;            
case "RPREDICT":                
rpPars  = new RpredictCheckPars(check.getChkCode());                
grid    = rpPars.getGrid(false);                
break;            
case "ALLOWED_LOV":            
case "FORBIDDEN_LOV":                
lovPars   = new LovCheckPars(check.getChkCode());                
checkLovs = new CheckLovs(lovPars.getLcpCode());                
grid      = lovPars.getGrid(false);                
list      = checkLovs.getListView(false);                
break;        
}        

CssLoader css = new CssLoader("/applicationanalyzer/FXML/CSS/Checks.css", "checkParsGrid");        
if (grid != null) {            
grid.getColumnConstraints().add(new ColumnConstraints(css.GRID_COL1_WIDTH));            
grid.getColumnConstraints().add(new ColumnConstraints(css.GRID_COL2_WIDTH));            
checkParsPane.getChildren().add(grid);            
if ( list != null) {                
checkLovPane.getChildren().add(list);            
}        
} else {            
Button createButton = CustomButton.createButton("Parameters");            
createButton.setOnAction(new EventHandler<ActionEvent>() {                
@Override                
public void handle(ActionEvent e) {                    
check.initCreatePars(check.getChkType(),ChecksForm.getScene().getWindow());                
}            
});            
checkParsPane.getChildren().add(createButton);        
}

}'
    ) ;
    -- DEFAULT UPDATER -----------------------------------------------------------
  ELSE
    add_ln(lc_out, 'private void setCurr'||lc_class||'('||lc_class||' new'||lc_class||'){
'||lc_instance||' = new'||lc_class||';
}') ;
  END CASE;

  RETURN lc_out;
END SET_CURR_OBJECT;

--------------------------------------------------------------------------------
FUNCTION CUSTOM_CODE(
    PAR_CONTROLLER VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000) ;

BEGIN

  lc_out := '//Custom part of the controller';

  CASE(PAR_CONTROLLER)
  WHEN('APPLICATIONS') THEN
    add_ln(lc_out,
    '@FXML    
private MenuBar menuBar;    
@FXML    
private TextField resultsField;        

@FXML    
public void handleQuit(ActionEvent event) {        
Stage application_stage = (Stage) menuBar.getScene().getWindow();        
application_stage.close();    
}    

@FXML    
public void handleViewSuits(ActionEvent event) {        
try {            
FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/applicationanalyzer/FXML/CheckSuits.fxml"));            
Parent root1 = (Parent) fxmlLoader.load();            
Stage newStage = new Stage();            
newStage.setTitle("Check suits");            
newStage.setScene(new Scene(root1));            
newStage.show();        
} catch (Exception e) {            
Alerts.AlertWindow(e);        
}    
}    

@FXML    
public void handleViewImage(ActionEvent event) {        
try {            
FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/applicationanalyzer/FXML/ImageView.fxml"));            
Parent root1 = (Parent) fxmlLoader.load();            
Stage imageStage = new Stage();            
imageStage.setTitle("An Image!!!!");            
imageStage.setScene(new Scene(root1));            
imageStage.show();        
} catch (Exception e) {            
Alerts.AlertWindow(e);        
}    
}        

@FXML    
private void updateResults(ActionEvent event) {        
Integer results = Integer.parseInt(resultsField.getText());        
showResults(results);    
}        

@FXML    
public void searchData(ActionEvent event) {        
Integer results = Integer.parseInt(resultsField.getText());        
showResults(results);    
}         

@Override     
public void initialize(URL url, ResourceBundle rb) {        
resultsField.setText("200");        
showResults(200);     
}'
    ) ;
  WHEN 'CHECKS' THEN
    add_ln(lc_out,
    '@FXML    
MenuBar menuBar;    
@FXML    
AnchorPane checkParsPane;        


//ADD ME TO showResults
checksTable.getColumns().setAll(chk_code, chk_mnemo, chk_type, chk_comment, chk_active, chk_chs_code);

@Override    
public void initialize(URL url, ResourceBundle rb) {        
showResults();    
}        


// Menu Handlers    

@FXML    
private void handleQuit(ActionEvent event) {        
Stage application_stage = (Stage) menuBar.getScene().getWindow();        
application_stage.close();    
}    

@FXML    
private void handleViewCheckSuits(ActionEvent event) {        
try {            
FXMLLoader fxmlLoader = new FXMLLoader(getClass().getResource("/applicationanalyzer/FXML/CheckSuits.fxml"));            
Parent root1 = (Parent) fxmlLoader.load();            
Stage newStage = new Stage();            
newStage.setScene(new Scene(root1));            
newStage.show();        
} catch (Exception e) {            
Alert alert = new Alert(AlertType.ERROR);            
alert.setTitle("Errror!!! AAAaaaaerrgggh!!");            
alert.setHeaderText("Error loading new window");            
System.out.println("Error " + e.getMessage());            
alert.setContentText(e.getMessage());            
alert.showAndWait();        
}    
}    

@FXML    
private void handleRunSuiteChecks(ActionEvent event) {        
boolean execution = SQLExecutor.executeProcedure("CHECKS.RUN_CHECKS(" + checkSuits.getChsCode() + ", ''    
Placeholder'')");    
}    

private void showCheckParsData(Checks check) {        
GridPane grid = check.getParsGrid(false);        
checkParsPane.getChildren().clear();        
CssLoader css = new CssLoader("/applicationanalyzer/FXML/CSS/Checks.css", "checkParsGrid");        
grid.getColumnConstraints().add(new ColumnConstraints(css.GRID_COL1_WIDTH));        
grid.getColumnConstraints().add(new ColumnConstraints(css.GRID_COL2_WIDTH));        
checkParsPane.getChildren().add(grid);    
}'
    ) ;

  WHEN('SUITE_SCENARIOS') THEN
    add_ln(lc_out,
    '@Override
public void initialize(URL url, ResourceBundle rb) {
}    

@FXML
private void runScenario(ActionEvent event) {
}    

@FXML
private void createScenario(ActionEvent event) {      
}    

@FXML
private void handleQuit(ActionEvent event) {    
}'
    ) ;
  ELSE
    add_ln(lc_out, '@Override     
public void initialize(URL url, ResourceBundle rb) {}') ;

  END CASE;

  RETURN LC_OUT;

END CUSTOM_CODE;


END JAVAFX_APP_SPEC_SYNTH;

/
