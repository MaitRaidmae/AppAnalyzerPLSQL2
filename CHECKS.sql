--------------------------------------------------------
--  DDL for Package CHECKS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."CHECKS" authid definer
IS
  /**
  *   Runs all Checks that are active for all applications
  */
  PROCEDURE RUN_CHECKS(
      par_chs_code b_check_Suits.chs_code%type,
      par_comment VARCHAR2,
      par_is_scenario PLS_INTEGER DEFAULT 0,
      par_run_code OUT b_suite_runs.srn_code%type) ;
  ------------------------------------------------------------------------------
  /**
  *   Runs all Checks that are active for an application.
  *   # par_apl_code -> unique code for the application
  */
  PROCEDURE RUN_APPLICATION_CHECKS(
      PAR_APL_CODE B_APPLICATIONS.APL_CODE%TYPE,
      PAR_CHS_CODE B_CHECK_SUITS.CHS_CODE%TYPE,
      PAR_SRN_CODE B_SUITE_RUNS.SRN_CODE%TYPE,
      par_is_scenario PLS_INTEGER) ;
  ------------------------------------------------------------------------------
  /**
  *   Runs a check for a given application and saves the result to database
  *   # par_apl_code   -> unique code for the application
  *   # par_chk_mnemo  -> mnemo for the check to run
  */
  PROCEDURE REGISTER_CHECK(
      par_apl_code b_applications.APL_CODE%TYPE,
      par_checks B_CHECKS%ROWTYPE,
      par_srn_code b_suite_Runs.srn_code%type,
      par_is_scenario PLS_INTEGER) ;
  ------------------------------------------------------------------------------
  /**
  *   Runs a check for a given application:
  *   # par_apl_code   -> unique code for the application
  *   # par_chk_mnemo  -> mnemo for the check to run
  */
  FUNCTION RUN_CHECK(
      par_apl_code b_applications.APL_CODE%TYPE,
      par_checks B_CHECKS%ROWTYPE)
    RETURN BOOLEAN;
  ------------------------------------------------------------------------------
  /**
  *   Returns true if the checked minimum or maximum value is below/above the
  *   value indicated in the chk_value parameter
  *   otherwise returns false.
  */
  FUNCTION MINMAX_CHECK(
      par_apl_code b_applications.apl_code%TYPE,
      par_chk_code b_checks.chk_code%TYPE,
      par_type b_checks.chk_type%TYPE)
    RETURN BOOLEAN;
  ------------------------------------------------------------------------------
  /**
  *   Runs an R model predict function and returns true or false based on
  *   whether the predicted value is over/under the given threshold value.
  */
  FUNCTION R_PREDICT(
      par_apl_code b_applications.apl_code%TYPE,
      par_model_name rqsys.rq$datastore.dsname%TYPE,
      par_check_type b_rpredict_check_pars.rcp_type%type,
      par_threshold NUMBER)
    RETURN BOOLEAN;
  ------------------------------------------------------------------------------
  /**
  *   Runs LOV Checks (LOV and EXCL_LOV)
  *
  */
  FUNCTION LOV_CHECK(
      par_apl_code b_applications.apl_code%TYPE,
      par_chk_code b_checks.chk_code%type,
      par_chk_type VARCHAR2)
    RETURN BOOLEAN;

END;

/
