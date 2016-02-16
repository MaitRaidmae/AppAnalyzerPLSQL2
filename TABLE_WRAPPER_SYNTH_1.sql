--------------------------------------------------------
--  DDL for Package Body TABLE_WRAPPER_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."TABLE_WRAPPER_SYNTH" 
IS

FUNCTION IS_PRIMARY_KEY(
    par_owner       VARCHAR2,
    par_table_name  VARCHAR2,
    par_column_name VARCHAR2)
  RETURN BOOLEAN
IS

  CURSOR cColConstraints
  IS
    SELECT *
    FROM all_cons_columns
    WHERE table_name = upper(par_table_name)
    AND column_name  = upper(par_column_name)
    AND owner        = upper(par_owner);
  rColConstraints cColConstraints%rowtype;

  lb_return   BOOLEAN := false;
  lc_con_name VARCHAR2(2000);

BEGIN
  --check column has constraint on it:
  FOR rColConstraints IN cColConstraints
  LOOP
    SELECT constraint_type
    INTO lc_con_name
    FROM all_constraints
    WHERE constraint_name=rColConstraints.constraint_name;

    IF (lc_con_name      = 'P') THEN
      lb_return         := true;
    END IF;

  END LOOP;

  RETURN lb_return;

END IS_PRIMARY_KEY;
--------------------------------------------------------------------------------
FUNCTION GEN_UPDATE_PARS(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out         VARCHAR2(32000);
  lc_primary_key VARCHAR2(2000);
BEGIN
  lc_out := 'SET ';
  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    IF (is_primary_key('HUNDISILM', par_table_name, rTabCols.column_name) = TRUE) THEN
      lc_primary_key                                                     :=rTabCols.column_name;
    ELSE

      add_ln(lc_out, rTabCols.column_name||' = PAR_'||rTabCols.column_name||',');
    END IF;
  END LOOP;

  --Remove last coma
  lc_out := SUBSTR(lc_out, 1, LENGTH(lc_out)-1);

  ADD_LN(LC_OUT, 'WHERE '||lc_primary_key||' = PAR_'||lc_primary_key||';');
  RETURN LC_OUT;
END GEN_UPDATE_PARS;
--------------------------------------------------------------------------------
PROCEDURE GENERATE_TABLE_PACKAGE(
    par_table_name VARCHAR2,
    par_new_package PLS_INTEGER DEFAULT 0)
IS

  LC_SQL          VARCHAR2(32000);
  LC_PACKAGE_NAME VARCHAR2(2000);
  lc_line         VARCHAR2(1000);

BEGIN

  IF (UPPER(SUBSTR(par_table_name, 1, 2)) = 'B_') THEN
    lc_package_name                      := regexp_replace(UPPER(par_table_name), 'B_', 'P_', 1, 1);
  ELSE
    lc_package_name := regexp_replace(UPPER(par_table_name), 'V_', 'P_', 1, 1);
  END IF;

  lc_line:='-----------------------------------------------------------------------------';
  ---- PACKAGE SPEC SYNTH ------------------------------------------------------
  doutln('CREATE OR REPLACE PACKAGE '||lc_package_name|| ' IS');
  doutln(lc_line);
  doutln(GEN_UPDATE_ROW(par_table_name, 'HEADER'));
  doutln(lc_line);
  doutln(GEN_GET_ROWS(par_table_name, 'HEADER'));
  doutln(lc_line);
  doutln(UPDATE_ROW_NVALUE(par_table_name, 'HEADER'));
  doutln(lc_line);
  doutln(UPDATE_ROW_CVALUE(par_table_name, 'HEADER'));
  doutln(lc_line);
  doutln(GET_RESULTS_PAGE(par_table_name, 'HEADER'));
  doutln(lc_line);
  doutln(INSERT_ROW(par_table_name, 'HEADER'));
  doutln(lc_line);
  doutln(DELETE_ROW(par_table_name, 'HEADER'));
  doutln(lc_line);
  doutln('END ' ||LC_PACKAGE_NAME||';');
  doutln('/');
  ---- PACKAGE BODY SYNTH ------------------------------------------------------
  doutln('CREATE OR REPLACE PACKAGE BODY '||LC_PACKAGE_NAME ||' IS');
  doutln(LC_LINE);
  doutln(GEN_UPDATE_ROW(PAR_TABLE_NAME, 'BODY'));
  doutln(LC_LINE);
  doutln(GEN_GET_ROWS(PAR_TABLE_NAME, 'BODY'));
  doutln(lc_line);
  doutln(UPDATE_ROW_NVALUE(par_table_name, 'BODY'));
  doutln(lc_line);
  doutln(UPDATE_ROW_CVALUE(par_table_name, 'BODY'));
  doutln(lc_line);
  doutln(GET_RESULTS_PAGE(par_table_name, 'BODY'));
  doutln(lc_line);
  doutln(INSERT_ROW(par_table_name, 'BODY'));
  doutln(lc_line);
  doutln(DELETE_ROW(par_table_name, 'BODY'));
  doutln(lc_line);
  doutln('END ' ||LC_PACKAGE_NAME||';');
  doutln('/');
  IF (par_new_package = 1) THEN
    ---- SEQUENCE SYNTH ----------------------------------------------------------
    doutln(CODE_SEQUENCE(par_table_name));
    doutln('/');
    ---- PRIMARY_KEY_TRIGGER SYNTH -----------------------------------------------
    doutln(PRIMARY_KEY_TRIGGER(par_table_name));
    doutln('/');
  END IF;
END GENERATE_TABLE_PACKAGE;
--------------------------------------------------------------------------------
FUNCTION GEN_UPDATE_ROW(
    par_table_name VARCHAR2,
    par_type       VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out        VARCHAR2(32000);
  lc_out_header VARCHAR2(2000);
  lc_parameters VARCHAR2(2000);

BEGIN
  -- Map pars just in case
  csh.MAP_PARS(par_table_name);

  -- Generate parameters list
  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    -- Generate pars
    lc_parameters := lc_parameters ||'PAR_'||rTabCols.column_name||' '||rTabCols.data_type||','||CHR(10);
  END LOOP;

  -- Cut last coma and newline and add closing bracket
  lc_parameters := SUBSTR(lc_parameters, 1, LENGTH(lc_parameters)-2)||')';

  LC_OUT        :='PROCEDURE UPDATE_ROW(';
  add_ln(lc_out, lc_parameters);
  -- Return declaration if in header mode.
  IF (par_type = 'HEADER') THEN
    lc_out    := lc_out||';';
    RETURN lc_out;
  END IF;
  --Generate body
  add_ln(lc_out, 'IS');
  add_ln(lc_out, '');
  add_ln(lc_out, 'BEGIN');
  add_ln(lc_out, 'UPDATE '||par_table_name);
  add_ln(lc_out, GEN_UPDATE_PARS(par_table_name));
  add_ln(lc_out, 'END UPDATE_ROW;');

  RETURN LC_OUT;

END GEN_UPDATE_ROW;
--------------------------------------------------------------------------------
FUNCTION GEN_GET_ROWS(
    PAR_TABLE_NAME VARCHAR2,
    par_type       VARCHAR2 )
  RETURN VARCHAR2
IS

  lc_out VARCHAR2(32000);

BEGIN

  ADD_LN(LC_OUT, 'PROCEDURE GET_ROWS(PAR_FIELD_NAME IN VARCHAR2, PAR_KEY IN NUMBER,');
  ADD_LN(LC_OUT, 'PAR_RESULTS OUT SYS_REFCURSOR)');
  IF (PAR_TYPE = 'HEADER') THEN
    LC_OUT    := LC_OUT || ';';
    RETURN lc_out;
  END IF;
  ADD_LN(LC_OUT, 'IS');
  ADD_LN(LC_OUT, '');
  ADD_LN(LC_OUT, 'LC_SELECT VARCHAR2(2000);');
  ADD_LN(LC_OUT, '');
  ADD_LN(LC_OUT, 'BEGIN');
  ADD_LN(LC_OUT, 'LC_SELECT := '' SELECT * FROM '||par_table_name||' WHERE ''||par_field_name||'' = :KEY'';');
  ADD_LN(LC_OUT, 'OPEN PAR_RESULTS FOR LC_SELECT USING PAR_KEY;');
  ADD_LN(LC_OUT, '');
  add_ln(lc_out, 'END GET_ROWS;');

  RETURN lc_out;
END GEN_GET_ROWS;
--------------------------------------------------------------------------------
-- TODO: Add update_row_nvalue and update_row_cvalue functions
FUNCTION UPDATE_ROW_NVALUE(
    PAR_TABLE_NAME VARCHAR2,
    par_type       VARCHAR2)
  RETURN VARCHAR2
AS

  lc_out VARCHAR2(32000);

BEGIN
  ADD_LN(LC_OUT, 'PROCEDURE UPDATE_ROW_NVALUE(par_code NUMBER, par_column VARCHAR2, par_value NUMBER)');
  IF (PAR_TYPE = 'HEADER') THEN
    LC_OUT    := LC_OUT || ';';
    RETURN LC_OUT;
  END IF;
  ADD_LN(LC_OUT, 'IS');
  ADD_LN(LC_OUT, 'BEGIN');
  ADD_LN(LC_OUT, 'EXECUTE IMMEDIATE');
  ADD_LN(LC_OUT, '''UPDATE '||par_table_name||'');
  ADD_LN(LC_OUT, 'set ''||PAR_COLUMN||'' = :value');
  ADD_LN(LC_OUT, 'where '||csh.get_table_prefix(par_Table_name)||'_code = :code'' using par_value, par_code;');

  ADD_LN(LC_OUT, 'END UPDATE_ROW_NVALUE;');

  RETURN lc_out;
END UPDATE_ROW_NVALUE;
--------------------------------------------------------------------------------
FUNCTION UPDATE_ROW_CVALUE(
    par_table_name VARCHAR2,
    par_type       VARCHAR2)
  RETURN VARCHAR2
AS

  LC_OUT VARCHAR2(32000);

BEGIN
  ADD_LN(LC_OUT, 'PROCEDURE UPDATE_ROW_CVALUE(par_code NUMBER, par_column VARCHAR2, par_value VARCHAR2)');
  IF (PAR_TYPE = 'HEADER') THEN
    LC_OUT    := LC_OUT || ';';
    RETURN LC_OUT;
  END IF;
  ADD_LN(LC_OUT, 'IS');
  ADD_LN(LC_OUT, 'BEGIN');
  ADD_LN(LC_OUT, 'EXECUTE IMMEDIATE');
  ADD_LN(LC_OUT, '''UPDATE '||par_table_name||'');
  ADD_LN(LC_OUT, 'set ''||PAR_COLUMN||'' = :value');
  ADD_LN(LC_OUT, 'where '||csh.get_table_prefix(par_Table_name)||'_code = :code'' using par_value, par_code;');
  ADD_LN(LC_OUT, 'END UPDATE_ROW_CVALUE;');
  RETURN lc_out;
END UPDATE_ROW_CVALUE;
--------------------------------------------------------------------------------
FUNCTION GET_RESULTS_PAGE(
    par_table_name VARCHAR2,
    par_type       VARCHAR2)
  RETURN VARCHAR2
AS

  LC_OUT VARCHAR2(32000);

BEGIN

  ADD_LN(LC_OUT, 'PROCEDURE GET_RESULTS_PAGE(par_page_nr IN NUMBER, par_results_per_page IN NUMBER,');
  ADD_LN(LC_OUT, 'par_result_set OUT SYS_REFCURSOR, par_where_json CLOB DEFAULT NULL)');
  IF (PAR_TYPE = 'HEADER') THEN
    LC_OUT    := LC_OUT || ';';
    RETURN LC_OUT;
  END IF;
  ADD_LN(LC_OUT, 'IS');

  ADD_LN(LC_OUT, 'ln_first_row    PLS_INTEGER;');
  ADD_LN(LC_OUT, 'ln_last_row     PLS_INTEGER;');
  ADD_LN(LC_OUT, 'lc_sql          VARCHAR2(2000);');
  add_ln(lc_out, 'lc_where_clause varchar2(2000);');

  ADD_LN(LC_OUT, 'BEGIN');
  ADD_LN(LC_OUT, 'ln_first_row := par_page_nr * par_results_per_page - (par_results_per_page - 1);');
  ADD_LN(LC_OUT, 'ln_last_row := par_page_nr * par_results_per_page;');

  add_ln(lc_out, 'if (par_where_json is null) then');
  ADD_LN(LC_OUT, 'lc_sql :=''select '||csh.col_list(par_table_name));
  add_ln(lc_out, 'FROM ( SELECT /*+ FIRST_ROWS(n) */');
  add_ln(lc_out, 'tbl.*, ROWNUM rnum');
  ADD_LN(LC_OUT, 'from ( select * from '||par_table_name||' ) tbl');
  ADD_LN(LC_OUT, 'where ROWNUM <=');
  ADD_LN(LC_OUT, '''||ln_last_row||'' )');
  ADD_LN(LC_OUT, 'WHERE RNUM  >= ''||LN_FIRST_ROW;');
  ADD_LN(LC_OUT, 'ELSE');
  add_ln(lc_out, 'lc_where_clause := JSON_THINGIES.BUILD_WHERE_CLAUSE(par_where_json);');
  ADD_LN(LC_OUT, 'lc_sql := ''select '||csh.col_list(par_table_name));
  add_ln(lc_out, 'FROM ( SELECT /*+ FIRST_ROWS(n) */');
  add_ln(lc_out, 'tbl.*, ROWNUM rnum');
  add_ln(lc_out, 'from ( select * from '||par_table_name||' ''||lc_where_clause||'') tbl');
  ADD_LN(LC_OUT, 'where ROWNUM <=');
  ADD_LN(LC_OUT, '''||ln_last_row||'' )');
  ADD_LN(LC_OUT, 'WHERE RNUM  >= ''||LN_FIRST_ROW;');
  ADD_LN(LC_OUT, 'end if;');

  ADD_LN(LC_OUT, 'OPEN par_result_set FOR lc_sql;');

  ADD_LN(LC_OUT, 'END GET_RESULTS_PAGE;');

  RETURN lc_out;
END GET_RESULTS_PAGE;
--------------------------------------------------------------------------------
FUNCTION INSERT_ROW(
    par_table_name VARCHAR2,
    par_type       VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out       VARCHAR2(32000);
  lc_pars      VARCHAR2(2000);
  lc_pars_lite VARCHAR2(2000);
BEGIN
  -- Map pars just in case
  csh.MAP_PARS(par_table_name);

  -- Generate parameters list
  FOR rTabCols IN csh.cTabCols(par_table_name)
  LOOP
    IF (csh.cTabCols%ROWCOUNT > 1) THEN
      -- Generate pars
      lc_pars := lc_pars ||'par_'||lower(rTabCols.column_name)||' '||rTabCols.data_type||','||CHR(10);
      -- Generate pars wo types
      lc_pars_lite := lc_pars_lite ||'par_'||lower(rTabCols.column_name)||', ';
    END IF;
  END LOOP;

  -- Cut last coma and newline and add closing bracket
  lc_pars      := SUBSTR(lc_pars, 1, LENGTH(lc_pars)          -2);
  lc_pars_lite := SUBSTR(lc_pars_lite, 1, LENGTH(lc_pars_lite)-2);

  add_ln(lc_out, 'PROCEDURE INSERT_ROW(');
  add_ln(lc_out, lc_pars);
  add_ln(lc_out, ')');
  IF (par_type = 'HEADER') THEN
    lc_out    := lc_out || ';';
    RETURN lc_out;
  END IF;
  add_ln(lc_out, 'IS');
  add_ln(lc_out, 'BEGIN');
  add_ln(lc_out, 'INSERT');
  add_ln(lc_out, 'INTO '||par_table_name);
  add_ln(lc_out, '(');
  add_ln(lc_out, csh.col_list(par_table_name, true));
  add_ln(lc_out, ')');
  add_ln(lc_out, 'VALUES');
  add_ln(lc_out, '(');
  add_ln(lc_out, lc_pars_lite);
  add_ln(lc_out, ');');

  add_ln(lc_out, 'END INSERT_ROW;');

  RETURN lc_out;
END INSERT_ROW;
--------------------------------------------------------------------------------
FUNCTION DELETE_ROW(
    par_table_name VARCHAR2,
    par_type       VARCHAR2)
  RETURN VARCHAR2

IS
  lc_out    VARCHAR2(32000);
  lc_prefix VARCHAR2(2000) := lower(csh.get_table_prefix(par_Table_name));

BEGIN
  add_ln(lc_out, 'PROCEDURE DELETE_ROW(par_code NUMBER)');
  IF (par_type = 'HEADER') THEN
    lc_out    := lc_out || ';';
    RETURN lc_out;
  END IF;
  add_ln(lc_out, 'IS');
  add_ln(lc_out, 'BEGIN');
  add_ln(lc_out, 'DELETE FROM '||upper(par_table_name)||' WHERE '||lc_prefix||'_code = par_code;');
  add_ln(lc_out, 'END DELETE_ROW;');

  RETURN lc_out;
END DELETE_ROW;
--------------------------------------------------------------------------------
FUNCTION CODE_SEQUENCE(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out       VARCHAR2(32000);
  lc_table_wob VARCHAR2(2000) := regexp_replace(upper(par_table_name), 'B_', '', 1, 1);
  lc_seq_name  VARCHAR2(100)  := upper(lc_table_wob)||'#'||upper(csh.get_table_prefix(par_table_name))||'_CODE';

BEGIN
  IF (LENGTH(lc_seq_name)<=30) THEN
    add_ln(lc_out, 'CREATE SEQUENCE '||lc_seq_name||' INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20;');
  ELSE
    add_ln(lc_out, 'CREATE SEQUENCE '||'<<ADD CUSTOM SEQUENCE NAME HERE>>'||' INCREMENT BY 1 MAXVALUE 9999999999999999999999999999 MINVALUE 1 CACHE 20;');
  END IF;

  RETURN lc_out;
END CODE_SEQUENCE;
------------------------------------------------------------------------------
FUNCTION PRIMARY_KEY_TRIGGER(
    par_table_name VARCHAR2)
  RETURN VARCHAR2
IS

  lc_out          VARCHAR2(32000);
  lc_prefix       VARCHAR2(2000) := upper(csh.get_table_prefix(par_table_name));
  lc_table_wob    VARCHAR2(2000) := regexp_replace(upper(par_table_name), 'B_', '', 1, 1);
  lc_trigger_name VARCHAR2(100)  := lc_table_wob||'#CODE';
  lc_seq_name     VARCHAR2(100)  := upper(lc_table_wob)||'#'||upper(csh.get_table_prefix(par_table_name))||'_CODE';

BEGIN
  IF (LENGTH(lc_trigger_name)>30) THEN
    lc_trigger_name         := '<<ADD CUSTOM TRIGGER NAME HERE>>';
  END IF;

  IF (LENGTH(lc_seq_name)>30) THEN
    lc_seq_name         := '<<ADD CUSTOM SEQUENCE NAME HERE>>';
  END IF;

  add_ln(lc_out, 'create or replace TRIGGER "'||lc_trigger_name||'"');
  add_ln(lc_out, 'before insert on "'||upper(par_table_name)||'"');
  add_ln(lc_out, 'for each row');
  add_ln(lc_out, 'begin');
  add_ln(lc_out, 'if inserting then');
  add_ln(lc_out, 'if :NEW."'||lc_prefix||'_CODE" is null then');
  add_ln(lc_out, 'select '||lc_seq_name||'.nextval into :NEW."'||lc_prefix||'_CODE" from dual;');
  add_ln(lc_out, 'end if;');
  add_ln(lc_out, 'end if;');
  add_ln(lc_out, 'end;');
  RETURN lc_out;
END PRIMARY_KEY_TRIGGER;
------------------------------------------------------------------------------
END TABLE_WRAPPER_SYNTH;

/
