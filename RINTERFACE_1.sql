--------------------------------------------------------
--  DDL for Package Body RINTERFACE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."RINTERFACE" AS

  FUNCTION Predict_value(par_datastore_name   rqsys.rq$datastore.dsname%TYPE,
                         par_script_name      SYS.RQ$SCRIPT.NAME%TYPE, 
                         par_data_query       VARCHAR2)
    RETURN NUMBER AS 
    
    ln_return_value NUMBER;
    lc_input_cur VARCHAR2(2000);
    lc_pars_cur  VARCHAR2(2000);
    lc_execute   varchar2(2000);
  BEGIN
  
    -- Create R Script for the model
    lc_input_cur := 'cursor('||par_data_query||')';
    lc_pars_cur  := 'cursor(select 1 as "ore.connect",'''||par_datastore_name||''' as "datastore.name" from dual)';
    
    -- Generate R interface select string
    lc_execute := 'select "prediction" from table(rqRowEval('
    ||lc_input_cur||', '
    ||lc_pars_cur||', '
    ||'''select 1 "prediction" from dual'''||', '
    ||'1'||', '
    ||'''PredictRow'''||'))';
    
    EXECUTE IMMEDIATE lc_execute into ln_return_value;

    return ln_return_value;
    
  END Predict_value;

END RINTERFACE;

/
