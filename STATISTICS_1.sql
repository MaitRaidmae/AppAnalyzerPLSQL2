--------------------------------------------------------
--  DDL for Package Body STATISTICS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."STATISTICS" 
AS

PROCEDURE GATHER_RUN_STATS(
    par_srn_code b_suite_runs.srn_code%type)
AS

  CURSOR cApplications
  IS
    SELECT * FROM b_applications;
  rApplications cApplications%rowtype;

  li_total_apps PLS_INTEGER := 0;
  li_total_amount NUMBER := 0;
  li_approved_apps PLS_INTEGER := 0;
  li_approved_amount NUMBER := 0;
  ln_run_code b_suite_runs.srn_code%type;
  ln_base_run_code b_suite_runs.srn_code%type;
  lc_run_type b_scenario_runs.scr_type%type; -- Scenario run type (BASE or ITERATION)
  ln_ssc_code b_suite_scenarios.ssc_code%type;

  lr_run_pars b_suite_runs%rowtype;

BEGIN

  SELECT * INTO lr_run_pars FROM b_suite_runs WHERE srn_code = par_srn_code;

  -- Check if this is a base run.
  IF(lr_run_pars.srn_type = 'SCENARIO') THEN
    SELECT scr_type, scr_ssc_code
    INTO lc_run_type, ln_ssc_code
    FROM b_scenario_runs
    WHERE scr_srn_code = par_srn_code;
    IF(lc_run_type = 'BASE') THEN
      ln_base_run_code := NULL;
    ELSE
      SELECT scr_srn_code
      INTO ln_base_run_code
      FROM b_scenario_runs
      WHERE scr_type = 'BASE'
      AND scr_ssc_code = ln_ssc_code;
    END IF;
  END IF;


  FOR rApplications IN cApplications
  LOOP
    li_total_apps := li_total_apps + 1;
    li_total_amount := li_total_amount + rApplications.apl_amount;
    -- TODO: Something is amiss here.
    IF(IS_APPLICATION_APPROVED(rApplications.apl_code, par_srn_code, ln_base_run_code) = 1) THEN
      li_approved_apps := li_approved_apps + 1;
      li_approved_amount := li_approved_amount + rApplications.apl_amount;
    END IF;
  END LOOP;

  P_RUN_STATS.INSERT_ROW(par_rst_srn_code => par_srn_code, par_rst_total_appls => li_total_apps, par_rst_total_amount => li_total_amount,
  par_rst_accepted_appls => li_approved_apps, par_rst_accepted_amount => li_approved_amount) ;

END GATHER_RUN_STATS;

------------------------------------------------------------------------------
FUNCTION IS_APPLICATION_APPROVED(
    par_apl_code b_applications.apl_code%type,
    par_srn_code b_suite_runs.srn_code%type,
    par_base_srn_code b_suite_runs.srn_code%type DEFAULT NULL)
  RETURN PLS_INTEGER
AS

  li_out PLS_INTEGER := 1;
  lr_suite_run b_suite_runs%rowtype;
  ln_iter_chk_code b_scenario_checks.scc_chk_code%type;
  li_chk_value PLS_INTEGER;


BEGIN

  -- Get run params
  SELECT *
  INTO lr_suite_run
  FROM b_suite_runs
  WHERE srn_code = par_srn_code;

  -- If Scenario run is indicated - check it first;
  IF(par_base_srn_code IS NOT NULL) THEN
    SELECT scc_chk_code, scc_value
    INTO ln_iter_chk_code, li_chk_value
    FROM b_scenario_checks
    WHERE scc_srn_code = par_srn_code
    AND scc_apl_code = par_apl_code;

    IF(li_chk_value = 1) THEN
      li_out := 0;
    END IF;

    IF(li_out = 1) THEN -- Only check other params, if iteration check is not null;
      SELECT
        CASE
          WHEN EXISTS
            (SELECT 1
            FROM b_scenario_checks
            WHERE scc_apl_code = par_apl_Code AND scc_srn_code = par_base_srn_code AND scc_value = 1 AND scc_chk_code != ln_iter_chk_code
            )
          THEN 0
          ELSE 1
        END
      INTO li_out
      FROM dual;
    END IF;

  ELSE
    SELECT
      CASE
        WHEN EXISTS
          (SELECT 1
          FROM b_scenario_checks
          WHERE scc_apl_code = par_apl_Code AND scc_srn_code = par_srn_code AND scc_value = 1
          )
        THEN 0
        ELSE 1
      END
    INTO li_out
    FROM dual;
  END IF;

  RETURN li_out;

END IS_APPLICATION_APPROVED;
------------------------------------------------------------------------------

END STATISTICS;

/
