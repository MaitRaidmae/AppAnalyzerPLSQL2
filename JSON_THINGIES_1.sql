--------------------------------------------------------
--  DDL for Package Body JSON_THINGIES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."JSON_THINGIES" 
AS

type lt_json_elements
IS
  TABLE OF VARCHAR2(32000);

type lt_where_element
IS
  record
  (
    r_field    VARCHAR2(200),
    r_operator VARCHAR2(10),
    r_value    VARCHAR2(32000),
    r_is_date pls_integer := 0 );

------------------------------------------------------------------------------
PROCEDURE GET_ITEM_TYPE(
    par_input CLOB,
    par_type OUT VARCHAR2,
    par_item_list OUT VARCHAR2)
IS

  lc_start_string VARCHAR2(2000);
  li_first_quote  pls_integer := instr(par_input,'"',1,1);
  li_second_quote pls_integer := instr(par_input,'"',1,2);
  lc_input CLOB;

FUNCTION GET_ITEM_LIST(
    par_string CLOB)
  RETURN CLOB
IS

  li_start_pos pls_integer := instr(par_string, '[', 1) + 1;
  li_end_pos pls_integer := instr(par_string, ']', - 1,1);

BEGIN

  RETURN SUBSTR(par_string, li_start_pos, li_end_pos - li_start_pos);

END GET_ITEM_LIST;

BEGIN

  lc_start_string := SUBSTR(par_input, li_first_quote + 1, li_second_quote-li_first_quote-1);

  IF (upper(lc_start_string) = 'AND') THEN
    par_type := 'AND';
    par_item_list := get_item_list(par_input);
  elsif (upper(lc_start_string) = 'OR') THEN
    par_type := 'OR';
    par_item_list := get_item_list(par_input);
  ELSE
    par_type := 'ITEM';
  END IF;

END GET_ITEM_TYPE;
------------------------------------------------------------------------------
FUNCTION GET_ITEM_STRING(
    par_input CLOB)
  RETURN CLOB
IS

  lc_out CLOB;
  lc_field    VARCHAR2(200);
  lc_operator VARCHAR2(100);
  lc_value    VARCHAR2(32000);

FUNCTION GET_FIELD_VALUE(
    par_string VARCHAR2,
    par_field  VARCHAR2,
    par_quotes pls_integer DEFAULT 0)
  RETURN VARCHAR2
IS

  li_start_pos pls_integer;
  li_end pls_integer;
  li_first_quote pls_integer;
  li_first_comma pls_integer;
  li_end_quote pls_integer;
  lc_value VARCHAR2(2000);
  lc_field VARCHAR2(2000) := '"'||par_field||'":';

BEGIN

  li_start_pos := instr(par_string, lc_field, 1) + LENGTH(lc_field);
  li_first_quote := instr(par_string, '"', li_start_pos);
  li_first_comma := instr(par_string, ',', li_start_pos);

  IF (li_first_comma = 0) THEN
    li_end := length(par_string);
  ELSE
    li_end := li_first_comma;
  END IF;

  IF (li_end < li_first_quote OR li_first_quote = 0) THEN
    lc_value := SUBSTR(par_string, li_start_pos, li_end - li_start_pos);
  ELSE
    li_end_quote := instr(par_string, '"', li_end - LENGTH(par_string) - 1, 1);
    lc_value := SUBSTR(par_string, li_first_quote + 1, li_end_quote - (li_first_quote + 1));
    IF (par_quotes = 1) THEN
      lc_value := ''''||lc_value||'''';
    END IF;
  END IF;

  RETURN trim(lc_value);
END GET_FIELD_VALUE;

BEGIN

  lc_field := get_field_value(par_input, 'field');
  lc_operator := get_field_value(par_input, 'operator');
  lc_value := get_field_value(par_input, 'value', par_quotes => 1);

  lc_out := lc_field || ' ' || lc_operator ||' '|| lc_value;

  RETURN lc_out;
END GET_ITEM_STRING;
------------------------------------------------------------------------------
FUNCTION BUILD_WHERE_CLAUSE(
    par_where_json CLOB)
  RETURN VARCHAR2
AS

  lc_out VARCHAR2(32000);
  li_length pls_integer := LENGTH(par_where_json);
  li_cur_pos pls_integer := 0;

BEGIN

  lc_out := 'WHERE ';
  lc_out := lc_out || AND_OR_BLOCK(par_where_json,null);

  RETURN lc_out;
END BUILD_WHERE_CLAUSE;
------------------------------------------------------------------------------

FUNCTION GET_FIRST_AND_REST(
    par_string CLOB)
  RETURN gt_first_rest
IS

  lc_out gt_first_rest;
  li_open_brackets pls_integer := 1;
  li_start_pos pls_integer := 0;
  li_end_pos pls_integer;
  li_cur_char VARCHAR2(1);
  li_length pls_integer := LENGTH(par_string);
  li_i pls_integer := 2;

BEGIN

  -- Some simple checks to see if
  IF (ltrim(SUBSTR(par_string, 1, 1)) != '{') THEN
    raise_application_error( - 20000, 'Input string must start with a {');
  elsif(regexp_count(par_string, '{') != regexp_count(par_string, '}')) THEN
    raise_application_error( - 20000, q'[input must have equal number of {'s and }'s]');
  END IF;

  --- Find position for the end of first object;
  LOOP
    EXIT
  WHEN (li_i > li_length);
    li_cur_char := SUBSTR(par_string, li_i, 1);
    IF (li_cur_char = '}') THEN
      li_open_brackets := li_open_brackets - 1;
    elsif (li_cur_char = '{') THEN
      li_open_brackets := li_open_brackets + 1;
    END IF;

    IF (li_open_brackets = 0) THEN
      li_end_pos := li_i;
      EXIT; --  <= Exit the loop if corresponding } is found for first element.
    END IF;
    li_i := li_i + 1;
  END LOOP;

  lc_out.r_first := SUBSTR(rtrim(par_string), 2, li_end_pos - 2);
  li_end_pos := instr(par_string, '{', li_end_pos);
  IF (li_end_pos > 0) THEN
    lc_out.r_rest := SUBSTR(rtrim(par_string), li_end_pos, li_length - li_end_pos + 1);
  END IF;

  RETURN lc_out;

END;
------------------------------------------------------------------------------
FUNCTION AND_OR_BLOCK(
    par_string CLOB,
    par_operator VARCHAR2)
  RETURN CLOB
IS

  lr_first_rest gt_first_rest;
  lc_out CLOB := '';
  lc_operator VARCHAR2(100);
  lc_items CLOB;

BEGIN
  
  lr_first_rest := GET_FIRST_AND_REST(par_string);
  GET_ITEM_TYPE(lr_first_rest.r_first, lc_operator, lc_items);
  IF (LENGTH(lr_first_rest.r_rest) < 3 OR lr_first_rest.r_rest IS NULL) THEN
    IF (lc_operator = 'AND' OR lc_operator = 'OR') THEN
      lc_out := lc_out ||' ('||AND_OR_BLOCK(lc_items, lc_operator)||') ';
    ELSE
      lc_out := lc_out || GET_ITEM_STRING(lr_first_rest.r_first);
    END IF;
  elsif (lc_operator = 'ITEM') THEN
    lc_out := lc_out ||' '|| GET_ITEM_STRING(lr_first_rest.r_first)||' '||par_operator||' ';
    lc_out := lc_out || AND_OR_BLOCK(lr_first_rest.r_rest, par_operator);
  ELSE
    lc_out := lc_out || AND_OR_BLOCK(lr_first_rest.r_rest,lc_operator);
  END IF;
  RETURN lc_out;
END;

END JSON_THINGIES;

/
