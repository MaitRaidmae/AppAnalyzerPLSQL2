--------------------------------------------------------
--  DDL for Package Body CHECKS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."CHECKS" 
IS

PROCEDURE RUN_CHECKS(
    par_chs_code b_check_Suits.chs_code%type,
    par_comment VARCHAR2,
    par_is_scenario PLS_INTEGER DEFAULT 0,
    par_run_code OUT b_suite_runs.srn_code%type)
IS

  CURSOR cApps
  IS
    SELECT apl_code FROM b_applications;
  rApps cApps%rowType;

  rindex pls_INTEGER;
  slno pls_INTEGER;
  totalwork pls_INTEGER;
  sofar pls_INTEGER;
  obj pls_INTEGER;


  ln_srn_code b_suite_runs.srn_code%type;
  lc_run_type b_suite_runs.srn_type%type;
  
BEGIN
  -- Register suit run
  if (par_is_scenario = 1) then
    lc_run_type := 'SCENARIO';
  else
    lc_run_type := 'OTHER';
  end if;
  
  INSERT
  INTO b_suite_runs VALUES
    (
      NULL, par_chs_code,
      systimestamp, par_comment, lc_run_type
    )
  RETURNING srn_code
  INTO ln_srn_code;
  --Set up progress tracking on session longops
  par_run_code := ln_srn_code;
  rindex := dbms_application_info.set_session_longops_nohint;
  sofar := 0;
  -- Get total number of applications
  SELECT COUNT(1)
  INTO totalwork
  FROM b_applications;

  FOR rApps IN cApps
  LOOP
    RUN_APPLICATION_CHECKS(rApps.apl_code, par_chs_code, ln_srn_code, par_is_scenario) ;
    sofar := sofar + 1;
    dbms_application_info.set_session_longops(rindex, slno, 'Running Checks', obj, 0, sofar, totalwork, 'application', 'applications') ;
  END LOOP;

END RUN_CHECKS;
--------------------------------------------------------------------------------
PROCEDURE RUN_APPLICATION_CHECKS(
    PAR_APL_CODE B_APPLICATIONS.APL_CODE%TYPE,
    PAR_CHS_CODE B_CHECK_SUITS.CHS_CODE%TYPE,
    PAR_SRN_CODE B_SUITE_RUNS.SRN_CODE%TYPE,
    par_is_scenario PLS_INTEGER)
IS

  CURSOR cChecks
  IS
    SELECT * FROM b_checks WHERE chk_active = 1 AND chk_chs_code = par_chs_code;
  rChecks cChecks%rowtype;

BEGIN
  FOR rChecks IN cChecks
  LOOP
    checks.register_check(par_apl_code, rChecks, par_srn_code, par_is_scenario) ;
  END LOOP;

END RUN_APPLICATION_CHECKS;
--------------------------------------------------------------------------------
PROCEDURE REGISTER_CHECK(
    par_apl_code b_applications.APL_CODE%TYPE,
    par_checks B_CHECKS%ROWTYPE,
    par_srn_code b_suite_Runs.srn_code%type,
    par_is_scenario PLS_INTEGER)
IS

  lb_check_result BOOLEAN;
  ln_check_result NUMBER;
  lr_check_row b_checks%rowtype;

BEGIN

  lb_check_result := RUN_CHECK(par_apl_code, par_checks) ;

  IF(lb_check_result = TRUE) THEN
    ln_check_result := 1;
  ELSE
    ln_check_result := 0;
  END IF;

  IF(par_is_scenario = 0) THEN
    INSERT
    INTO b_app_checks VALUES
      (
        NULL, par_apl_code,
        par_checks.chk_code, ln_check_result,
        par_srn_code
      ) ;
  ELSE
    P_SCENARIO_CHECKS.INSERT_ROW(par_apl_code,ln_check_result,par_srn_code,par_checks.chk_code);
  END IF;

END REGISTER_CHECK;
--------------------------------------------------------------------------------
FUNCTION RUN_CHECK
  (
    par_apl_code b_applications.APL_CODE%TYPE,
    par_checks B_CHECKS%ROWTYPE
  )
  RETURN BOOLEAN
IS

  lc_chk_type     VARCHAR2(20) ;
  lc_chk_field    VARCHAR2(50) ;
  lb_check_result BOOLEAN;
  lr_check_row b_checks%rowtype;
  lr_rpredict_row B_RPREDICT_CHECK_PARS%ROWTYPE;

BEGIN

  IF(par_checks.chk_type = 'MIN' OR par_checks.chk_type = 'MAX') THEN
    lb_check_result := MINMAX_CHECK(par_apl_code, par_checks.chk_code, par_checks.chk_type) ;
  ELSIF(lr_check_row.chk_type = 'RPREDICT') THEN

    SELECT *
    INTO lr_rpredict_row
    FROM b_rpredict_check_pars
    WHERE rcp_chk_code = par_checks.chk_code;

    lb_check_result := R_PREDICT(par_apl_code, lr_rpredict_row.rcp_model, lr_rpredict_row.rcp_type, lr_rpredict_row.rcp_threshold) ;
  ELSIF(par_checks.chk_type = 'ALLOWED_LOV' OR par_checks.chk_type = 'FORBIDDEN_LOV') THEN
    lb_check_result := LOV_CHECK(par_apl_code, par_checks.chk_code, par_checks.chk_type) ;
  END IF;

  RETURN lb_check_result;

END RUN_CHECK;
------------------------------------------------------------------------------
FUNCTION MINMAX_CHECK(
    par_apl_code b_applications.apl_code%TYPE,
    par_chk_code b_checks.chk_code%TYPE,
    par_type b_checks.chk_type%type)
  RETURN BOOLEAN
IS

  ln_apl_value NUMBER;
  lr_minmax_pars b_minmax_check_pars%rowtype;
BEGIN
  SELECT *
  INTO lr_minmax_pars
  FROM b_minmax_check_pars
  WHERE mcp_chk_code = par_chk_code;
  -- Get the value from the application
  EXECUTE IMMEDIATE 'select ' || lr_minmax_pars.mcp_check_field || ' from b_applications where apl_code = :1' INTO ln_apl_value USING par_apl_code;

  -- Return True of false based on the which type check is executed.
  IF(par_type = 'MIN' AND ln_apl_value < lr_minmax_pars.mcp_threshold) THEN
    RETURN TRUE;
  ELSIF(par_type = 'MAX' AND ln_apl_value > lr_minmax_pars.mcp_threshold) THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END MINMAX_CHECK;
--------------------------------------------------------------------------------
FUNCTION R_PREDICT(
    par_apl_code b_applications.apl_code%TYPE,
    par_model_name rqsys.rq$datastore.dsname%TYPE,
    par_check_type b_rpredict_check_pars.rcp_type%type,
    par_threshold NUMBER)
  RETURN BOOLEAN
IS

  lc_script_name     VARCHAR2(2000) := 'PredictRow';
  ln_predicted_value NUMBER;

BEGIN
  ln_predicted_value := RINTERFACE.PREDICT_VALUE(par_model_name, lc_script_name, 'select * from b_applications where apl_code = '||par_apl_code) ;

  IF(par_check_type = 'MAX' AND ln_predicted_value > par_threshold) THEN
    RETURN true;
  ELSIF(par_check_type = 'MIN' AND ln_predicted_value < par_threshold) THEN
    RETURN true;
  ELSE
    RETURN false;
  END IF;
END R_PREDICT;

--------------------------------------------------------------------------------
FUNCTION LOV_CHECK(
    par_apl_code b_applications.apl_code%TYPE,
    par_chk_code b_checks.chk_code%type,
    par_chk_type VARCHAR2)
  RETURN BOOLEAN
IS

  lb_return BOOLEAN;
  lr_lov_pars b_lov_check_pars%rowtype;
  lc_column_value VARCHAR2(2000) ;
  lb_found        BOOLEAN := false;

  CURSOR cCheckLovs(p_lov_pars_code NUMBER)
  IS
    SELECT clv_value FROM b_check_lovs WHERE clv_lcp_code = p_lov_pars_code;
  rCheckLovs cCheckLovs%rowtype;

BEGIN

  -- Get the pars
  SELECT *
  INTO lr_lov_pars
  FROM b_lov_check_pars
  WHERE lcp_chk_code = par_chk_code;

  -- Get application value
  EXECUTE immediate 'select '||lr_lov_pars.lcp_check_field||' from b_applications where apl_code = :apl_code' INTO lc_column_value USING par_apl_code
  ;

  -- Check if application is in LOV
  FOR rCheckLovs IN cCheckLovs(lr_lov_pars.lcp_code)
  LOOP
    IF(upper(rCheckLovs.clv_value) = upper(lc_column_value)) THEN
      lb_found := true;
      EXIT;
    END IF;
  END LOOP;

  -- If type inclusive return found = true else return the opposite (i.e.) if found return false.
  IF(par_chk_type = 'FORBIDDEN_LOV') THEN
    RETURN lb_found;
  elsif(par_chk_type = 'ALLOWED_LOV') THEN
    RETURN NOT(lb_found) ;
  END IF;

  RETURN lb_return;
END LOV_CHECK;

END;

/
