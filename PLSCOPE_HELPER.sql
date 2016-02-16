--------------------------------------------------------
--  DDL for Package PLSCOPE_HELPER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."PLSCOPE_HELPER" 
  /*
  Helper package for PL/Scope and ALL_IDENTIFIERS
  Author: Steven Feuerstein, steven@stevenfeuerstein.com
  with assistance from Lucas Jellema of AMIS:
  http://technology.amis.nl/blog/2584/enforcing-plsql-naming-conventions-through-a-simple-sql-query-using-oracle-11g-plscope
  Modification History
  Date          Change
  12-APR-2010   created package from Lucas' original query
  Notes:
  * This package requires Oracle Database 11g Release 1 or higher.
  */
IS
  /* Wild cards are supported for object names. */
  PROCEDURE show_identifiers_in(
      owner_in IN VARCHAR2,
      NAME_IN IN VARCHAR2,
      identifier_filter_in IN VARCHAR2 DEFAULT '%',
      usage_type_in IN VARCHAR2 DEFAULT '%') ;

  PROCEDURE should_contain(
      owner_in IN VARCHAR2,
      NAME_IN IN VARCHAR2,
      type_list_in IN VARCHAR2,
      filter_in IN VARCHAR2,
      escape_in IN VARCHAR2 DEFAULT '\',
      title_in IN VARCHAR2) ;

  PROCEDURE should_start_with(
      owner_in IN VARCHAR2,
      NAME_IN IN VARCHAR2,
      type_list_in IN VARCHAR2,
      prefix_in IN VARCHAR2,
      escape_in IN VARCHAR2 DEFAULT '\') ;

  PROCEDURE should_end_with(
      owner_in IN VARCHAR2,
      NAME_IN IN VARCHAR2,
      type_list_in IN VARCHAR2,
      suffix_in IN VARCHAR2,
      escape_in IN VARCHAR2 DEFAULT '\') ;

  PROCEDURE exposed_package_data_in(
      owner_in IN VARCHAR2,
      NAME_IN IN VARCHAR2) ;

  PROCEDURE all_changes_to(
      owner_in IN VARCHAR2,
      NAME_IN IN VARCHAR2,
      variable_name_in IN VARCHAR2) ;

  PROCEDURE unused_exceptions_in(
      owner_in IN VARCHAR2) ;
END PLSCOPE_HELPER;

/
