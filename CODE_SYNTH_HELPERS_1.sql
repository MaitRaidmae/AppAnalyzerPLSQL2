--------------------------------------------------------
--  DDL for Package Body CODE_SYNTH_HELPERS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."CODE_SYNTH_HELPERS" 
IS
  --------------------------------------------------------------------------------
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
    par_string     VARCHAR2,
    par_lower_init BOOLEAN DEFAULT false)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(2000);
BEGIN
  lc_out            := REPLACE(initcap(par_string), '_', '');
  IF (par_lower_init = true) THEN
    lc_out          := lower(SUBSTR(lc_out, 1, 1))||SUBSTR(lc_out, 2, 9999999);
  END IF;
  RETURN lc_out;
END;
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
PROCEDURE ADD_LN(
    par_clob    IN OUT NOCOPY CLOB,
    par_string2 IN VARCHAR2)
IS

BEGIN
  par_clob:=par_clob||CHR(10)||par_string2;
END;
--------------------------------------------------------------------------------
FUNCTION CAMEL_TABLENAME_WOB(
    par_table_name VARCHAR2,
    par_lower_init BOOLEAN DEFAULT false)
  RETURN VARCHAR2
IS

  lc_table_name VARCHAR2(100) := lower(par_table_name);
BEGIN
  -- Remove b_ or v_ from table_name
  if (substr(lc_table_name,1,2) = 'b_') then
    lc_table_name := regexp_replace(lc_table_name, 'b_', '', 1, 1);
  else
    lc_table_name := regexp_replace(lc_table_name, 'v_', '', 1, 1);
  end if;

  -- initcap and remove _ thingies
  lc_table_name     := REPLACE(initcap(lc_table_name), '_', '');

  IF (par_lower_init = true) THEN
    lc_table_name   := lower(SUBSTR(lc_table_name, 1, 1))||SUBSTR(lc_table_name, 2, 9999999);
  END IF;

  RETURN lc_table_name;
END;
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
FUNCTION COL_LIST(
    par_table_name VARCHAR2,
    par_wo_key     BOOLEAN DEFAULT false)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(2000);

BEGIN
  FOR rTabCols IN cTabCols(par_table_name)
  LOOP
    IF (cTabCols%ROWCOUNT>1 OR par_wo_key = false) THEN
      lc_out            :=lc_out||lower(rTabCols.column_name)||',';
    END IF;
  END LOOP;
  RETURN SUBSTR(lc_out, 1, LENGTH(lc_out)-1);
END;
--------------------------------------------------------------------------------
FUNCTION IS_BOOLEAN_COLUMN(
    par_table_name  VARCHAR2,
    par_column_name VARCHAR2)
  RETURN PLS_INTEGER
IS

  lc_owner VARCHAR2(2000);

BEGIN
  EXECUTE IMMEDIATE 'SELECT owner FROM user_constraints WHERE table_name = '''||par_table_name||''' AND
constraint_name like ''%'||par_column_name||'_BOOLEAN%''' INTO lc_owner;
  IF (LENGTH(lc_owner) > 0) THEN
    RETURN 1;
  ELSE
    RETURN 0;
  END IF;

EXCEPTION
WHEN no_data_found THEN
  RETURN 0;

END IS_BOOLEAN_COLUMN;
--------------------------------------------------------------------------------
FUNCTION GET_TABLE_PREFIX(
    PAR_TABLE_NAME VARCHAR2)
  RETURN VARCHAR2
IS

  lc_col_name VARCHAR2(2000);

BEGIN

  SELECT column_name
  INTO lc_col_name
  FROM user_tab_cols
  WHERE table_name = upper(par_Table_name)
  AND rownum       = 1;

  RETURN SUBSTR(lc_col_name, 1, instr(lc_col_name, '_', 1)-1);

END GET_TABLE_PREFIX;
--------------------------------------------------------------------------------
FUNCTION PAR_NAME_WO_IDENTIFIER(
    PAR_PAR_NAME VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(2000);

BEGIN

  lc_out := SUBSTR(par_par_name, instr(par_par_name, '_', 1)+1, 999);

  RETURN lc_out;
END PAR_NAME_WO_IDENTIFIER;
--------------------------------------------------------------------------------
FUNCTION IS_LOV_COLUMN(
    PAR_TABLE_NAME  VARCHAR2,
    par_column_name VARCHAR2)
  RETURN PLS_INTEGER
AS
  lc_owner VARCHAR2(2000);


li_out PLS_INTEGER := 0;

cursor cTableColLovPars(p_table_name varchar2, p_column_name varchar2) is
  select tlp_code from b_table_col_lov_pars where tlp_table = upper(p_table_name) and tlp_column = upper(p_column_name);
rTableColLovPars cTableColLovPars%ROWTYPE;

BEGIN
  
  open cTableColLovPars(par_table_name, par_column_name);
  fetch cTableColLovPars into rTableColLovPars;
  if cTableColLovPars%FOUND then
     li_out := 1;
  else
     li_out := 0;
  end if;
  close cTableColLovPars;  
   
  return li_out;

EXCEPTION
WHEN no_data_found THEN
  RETURN 0;
END IS_LOV_COLUMN;
--------------------------------------------------------------------------------
FUNCTION PARENT_TABLE(
    par_controller VARCHAR2)
  RETURN VARCHAR2
IS

  lc_table VARCHAR2(2000);

BEGIN

  SELECT aco_table
  INTO lc_table
  FROM b_app_controllers
  WHERE aco_controller = par_controller;

  RETURN lc_table;

END PARENT_TABLE;
--------------------------------------------------------------------------------
FUNCTION CAMEL_TO_SNAKE(par_input varchar2) return varchar2 is

lc_out varchar2(32000);

begin

lc_out := regexp_replace(par_input,'([A-Z])', '_\1', 2);

return lc_out;
end;

END code_synth_helpers;

/
