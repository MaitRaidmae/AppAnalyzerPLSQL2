--------------------------------------------------------
--  DDL for Package RINTERFACE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."RINTERFACE" 
AS

  /* TODO enter package declarations (types, exceptions, methods etc) here */
  FUNCTION Predict_value(par_datastore_name   rqsys.rq$datastore.dsname%TYPE,
                         par_script_name      SYS.RQ$SCRIPT.NAME%TYPE,
                         par_data_query       VARCHAR2)
    RETURN NUMBER;

END RINTERFACE;

/
