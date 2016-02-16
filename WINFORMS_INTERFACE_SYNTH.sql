--------------------------------------------------------
--  DDL for Package WINFORMS_INTERFACE_SYNTH
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."WINFORMS_INTERFACE_SYNTH" authid definer
AS
  ------------------------------------------------------------------------------
  PROCEDURE INTERFACE_TO_FILE(
      par_screen_name VARCHAR2);
  ------------------------------------------------------------------------------
  PROCEDURE WINFORM_INTERFACE(
      par_controller b_app_controllers.aco_controller%type);
  ------------------------------------------------------------------------------
  FUNCTION PRETTY_NAMES(
      par_table_name VARCHAR2,
      par_view_type  VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION DELETE_ITEM(
      par_table_name VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION COMMIT_CHANGES(
      par_table_name VARCHAR2)
    RETURN VARCHAR2;
  ------------------------------------------------------------------------------
  FUNCTION SIBLING_GRID(
    par_table_name   VARCHAR2,
    par_parent_table VARCHAR2,
    par_view_type    VARCHAR2)
  RETURN VARCHAR2;
  ------------------------------------------------------------------------------
END WINFORMS_INTERFACE_SYNTH;

/
