--------------------------------------------------------
--  DDL for Function WORKLIST
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "HUNDISILM"."WORKLIST" 
  RETURN worklist_type pipelined
AS
  l_task VARCHAR2(4000) ;

FUNCTION get_code(
    p_name IN VARCHAR2,
    p_type IN VARCHAR2,
    from_line IN INTEGER)
  RETURN VARCHAR2
IS
  l_code VARCHAR2(32000) ;
  CURSOR src_cur
  IS
    SELECT S.line, S.text
    FROM user_source S
    WHERE S.name = UPPER(p_name)
    AND S.type = UPPER(p_type)
    AND S.line BETWEEN from_line AND from_line + 10 ;
BEGIN
  FOR r_src IN src_cur
  LOOP
    l_code := l_code ||TO_CHAR(r_src.line) ||':'|| r_src.text;
  END LOOP;
  RETURN l_code;
END get_code;


BEGIN

  FOR src IN
  (SELECT src.name, src.type,
    src.line, src.text
  FROM user_source src
  WHERE instr(src.text, '--'||' TODO') > 0
  ORDER BY type, name, line
  )
  LOOP
    l_task := SUBSTR(src.text, instr(src.text, '--'||' TODO') + 8) ;
    l_task := SUBSTR(l_task, 1, instr(l_task, chr(10)) - 1) ;
    pipe row(worklist_entry_type(src.name, src.type, l_task, src.line, get_code(src.name, src.type, src.line + 1))) ;
  END LOOP;
  RETURN;
END worklist;

/
