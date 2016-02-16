--------------------------------------------------------
--  DDL for Package SCENARIO_RUNNER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."SCENARIO_RUNNER" authid definer
AS
/*
  Important if new type of check (new tables etc is added - make sure this package is updated. (the case blocks require updating).
  Otherwise the scenario runner will probably not work 
*/
  /* TODO enter package declarations (types, exceptions, methods etc) here */
  PROCEDURE RUN_SCENARIO(
      par_scenario_mnemo b_suite_scenarios.ssc_mnemo%type);
  ------------------------------------------------------------------------------
  PROCEDURE REGISTER_CHECK_PARS(
    par_scenario_code b_suite_scenarios.ssc_code%type,
    par_run_code b_suite_runs.srn_code%type,
    par_run_type b_scenario_check_pars.scp_type%type);
  ------------------------------------------------------------------------------
END SCENARIO_RUNNER;

/
