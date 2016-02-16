--------------------------------------------------------
--  DDL for Type WORKLIST_ENTRY_TYPE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "HUNDISILM"."WORKLIST_ENTRY_TYPE" 
as object
( object_name varchar2(100)
, object_type varchar2(100)
, task         varchar2(4000)
, line_number  number(5)
, code         varchar2(4000)
)

/
