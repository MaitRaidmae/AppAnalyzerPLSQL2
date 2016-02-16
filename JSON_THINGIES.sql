--------------------------------------------------------
--  DDL for Package JSON_THINGIES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."JSON_THINGIES" AUTHID DEFINER
AS

type gt_first_rest
IS
  record
  (
    r_first CLOB,
    r_rest CLOB);
------------------------------------------------------------------------------
  FUNCTION BUILD_WHERE_CLAUSE(
      par_where_json CLOB)
    RETURN VARCHAR2;
------------------------------------------------------------------------------
  FUNCTION GET_FIRST_AND_REST(
    par_string CLOB) return gt_first_rest;
------------------------------------------------------------------------------
FUNCTION AND_OR_BLOCK(
    par_string CLOB,
    par_operator VARCHAR2)
  RETURN CLOB;
  
END JSON_THINGIES;

/
