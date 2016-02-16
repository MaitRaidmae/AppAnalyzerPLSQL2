--------------------------------------------------------
--  DDL for Procedure DOUTLN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "HUNDISILM"."DOUTLN" (par_string varchar2) AUTHID DEFINER IS

lc_mode varchar2(200) := misc_utils.gc_output_mode;
lf_file utl_file.file_type := misc_utils.gf_output_file;

BEGIN
  if (lc_mode = 'DBMS_OUTPUT') THEN
    dbms_output.put_line(par_string);
  ELSE 
    utl_file.put_line(lf_file,par_string);
  END IF;
end;

/
