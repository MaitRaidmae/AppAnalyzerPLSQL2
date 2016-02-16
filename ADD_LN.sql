--------------------------------------------------------
--  DDL for Procedure ADD_LN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "HUNDISILM"."ADD_LN" (
    par_clob    IN OUT CLOB,
    par_string2 IN VARCHAR2)
IS

BEGIN
  par_clob:=par_clob||CHR(10)||par_string2;
END;				 
				

/
