--------------------------------------------------------
--  DDL for Package P_MINMAX_ITERATORS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."P_MINMAX_ITERATORS" AUTHID DEFINER
IS
  -----------------------------------------------------------------------------
type gt_num_int
IS
  TABLE OF NUMBER INDEX BY pls_integer;

  gcl_iter_value gt_num_int;

  -----------------------------------------------------------------------------
  PROCEDURE UPDATE_ROW(
      PAR_MMI_CODE           NUMBER,
      PAR_MMI_MNEMO          VARCHAR2,
      PAR_MMI_FIELD          VARCHAR2,
      PAR_MMI_THRESHOLD_FROM NUMBER,
      PAR_MMI_THRESHOLD_TO   NUMBER,
      PAR_MMI_STEP           NUMBER) ;
  -----------------------------------------------------------------------------

  PROCEDURE GET_ROWS(
      PAR_FIELD_NAME IN VARCHAR2,
      PAR_KEY IN NUMBER,
      PAR_RESULTS OUT SYS_REFCURSOR) ;
  -----------------------------------------------------------------------------

  PROCEDURE UPDATE_ROW_NVALUE(
      par_code   NUMBER,
      par_column VARCHAR2,
      par_value  NUMBER) ;
  -----------------------------------------------------------------------------

  PROCEDURE UPDATE_ROW_NVALUE(
      par_code   NUMBER,
      par_column VARCHAR2,
      par_value  VARCHAR2) ;
  -----------------------------------------------------------------------------

  PROCEDURE GET_RESULTS_PAGE(
      par_page_nr IN NUMBER,
      par_results_per_page IN NUMBER,
      result_set OUT SYS_REFCURSOR,
      par_find_by_field VARCHAR2 DEFAULT NULL,
      par_find_by_value NUMBER DEFAULT NULL) ;
  -----------------------------------------------------------------------------

  PROCEDURE INSERT_ROW(
      par_mmi_mnemo          VARCHAR2,
      par_mmi_field          VARCHAR2,
      par_mmi_threshold_from NUMBER,
      par_mmi_threshold_to   NUMBER,
      par_mmi_step           NUMBER) ;
  -----------------------------------------------------------------------------

  PROCEDURE DELETE_ROW(
      par_code NUMBER) ;
  -----------------------------------------------------------------------------
  FUNCTION ITER_NEXT(
      par_iterator_code b_minmax_iterators.mmi_code%type,
      par_chk_code b_checks.chk_code%type,
      par_iterator_id pls_integer)
    RETURN PLS_INTEGER;
  -----------------------------------------------------------------------------
END P_MINMAX_ITERATORS;

/
