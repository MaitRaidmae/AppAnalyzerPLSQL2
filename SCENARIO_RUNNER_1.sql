--------------------------------------------------------
--  DDL for Package Body SCENARIO_RUNNER
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."SCENARIO_RUNNER" 
AS

FUNCTION NEXT_VALUE(
    par_iterator_type VARCHAR2,
    par_iterator_code NUMBER,
    par_check_code    NUMBER,
    par_iterator_id PLS_INTEGER)
  RETURN pls_integer
IS

  li_out pls_integer;
BEGIN

  CASE par_iterator_type
  WHEN 'MIN' THEN
    li_out := p_minmax_iterators.iter_next(par_iterator_code, par_check_code, par_iterator_id) ;
  WHEN 'MAX' THEN
    li_out := p_minmax_iterators.iter_next(par_iterator_code, par_check_code, par_iterator_id) ;
  END CASE;

  RETURN li_out;
END NEXT_VALUE;
--------------------------------------------------------------------------------
PROCEDURE RESTORE_PARS(
    par_run_code B_SUITE_RUNS.SRN_CODE%type,
    par_check b_checks%rowtype)
IS

  ln_base_value NUMBER;

PROCEDURE MINMAX_RESTORE(
    par_run_code B_SUITE_RUNS.SRN_CODE%type,
    par_check b_checks%rowtype)
IS

BEGIN
  SELECT scp_par_value
  INTO ln_base_value
  FROM b_scenario_check_pars
  WHERE scp_chk_mnemo = par_check.chk_mnemo
  AND scp_par_name = 'MCP_THRESHOLD'
  AND scp_srn_code = par_run_code;

  UPDATE b_minmax_check_pars
  SET mcp_threshold = ln_base_value
  WHERE mcp_chk_code = par_check.chk_code;
END MINMAX_RESTORE;

BEGIN

  CASE par_check.chk_type
  WHEN 'MIN' THEN
    MINMAX_RESTORE(par_run_code, par_check) ;
  WHEN 'MAX' THEN
    MINMAX_RESTORE(par_run_code, par_check) ;
  END CASE;


END RESTORE_PARS;
--------------------------------------------------------------------------------
FUNCTION GET_PAR_VALUE(
    par_table_name  VARCHAR2,
    par_column_name VARCHAR2,
    par_data_type   VARCHAR2,
    par_chk_code    NUMBER)
  RETURN VARCHAR2
IS

  lc_out  VARCHAR2(2000) ;
  ln_out  NUMBER;
  lts_out TIMESTAMP;
  ld_out  DATE;
  lc_sql  VARCHAR2(2000) ;

BEGIN

  lc_sql := 'select '||par_column_name||' from '||par_table_name||' where '||csh.get_table_prefix(par_table_name) ||'_chk_code = :par_chk_code';
  CASE(par_data_type)
  WHEN 'VARCHAR2' THEN
    EXECUTE immediate lc_sql INTO lc_out USING par_chk_code;
  WHEN 'NUMBER' THEN
    EXECUTE immediate lc_sql INTO ln_out USING par_chk_code;
    lc_out := TO_CHAR(ln_out) ;
  WHEN 'TIMESTAMP(6)' THEN
    EXECUTE immediate lc_sql INTO lts_out USING par_chk_code;
    lc_out := TO_CHAR(ln_out) ;
  WHEN 'DATE' THEN
    EXECUTE immediate lc_sql INTO ld_out USING par_chk_code;
    lc_out := TO_CHAR(ln_out) ;
  ELSE
    EXECUTE immediate 'select to_char('||par_column_name||') from '||par_table_name||' where '||csh.get_table_prefix(par_table_name) ||
    '_chk_code = :par_chk_code' INTO lc_out USING par_chk_code;
  END CASE;

  RETURN LC_OUT;

END GET_PAR_VALUE;

------------------------------------------------------------------------------
PROCEDURE RUN_SCENARIO(
    par_scenario_mnemo b_suite_scenarios.ssc_mnemo%type)
AS

  lr_scenario b_suite_scenarios%rowtype;
  lr_check b_checks%rowtype;

  lc_suite_mnemo b_check_suits.chs_mnemo%type;
  li_next pls_integer;
  li_i pls_integer := 0;
  li_iterator_id PLS_INTEGER;
  ln_run_code b_suite_runs.srn_code%type;
  ln_base_run_code b_suite_runs.srn_code%type;

  CURSOR cRuns(p_ssc_code b_suite_scenarios.ssc_code%type)
  IS
    SELECT * FROM b_scenario_runs WHERE scr_ssc_code = p_ssc_code;
  rRuns cRuns%rowtype;

BEGIN

  SELECT *
  INTO lr_scenario
  FROM b_suite_scenarios
  WHERE ssc_mnemo = par_scenario_mnemo;

  SELECT chs_mnemo
  INTO lc_suite_mnemo
  FROM b_check_suits
  WHERE chs_code = lr_scenario.ssc_chs_code;

  SELECT *
  INTO lr_check
  FROM b_checks
  WHERE chk_mnemo = lr_scenario.ssc_chk_mnemo
  AND chk_chs_code = lr_scenario.ssc_chs_code;

  -- Step 1 Run suite with current steps (register pars etc)
  -- Run Checks
  checks.run_checks(lr_scenario.ssc_chs_code, 'Suite '||lc_suite_mnemo||' scenario '||lr_scenario.ssc_mnemo||' base run', par_is_scenario => 1,
  par_run_code => ln_base_run_code) ;
  -- Register check pars
  REGISTER_CHECK_PARS( par_scenario_code => lr_scenario.ssc_code, par_run_code => ln_base_run_code, par_run_type => 'BASE') ;

  -- Register run in the scenario runs table
  P_SCENARIO_RUNS.INSERT_ROW( par_scr_ssc_code => lr_scenario.ssc_code, par_scr_srn_code => ln_base_run_code, par_scr_type => 'BASE') ;

  -- Step 2 Disable all checks besides the check indicated.
  UPDATE b_checks
  SET chk_active = 0
  WHERE chk_chs_code = lr_scenario.ssc_chs_code
  AND chk_code != lr_check.chk_code;

  -- Step 3 Run selected Iterator.
  -- NEXT_VALUE function selects appropriate iterator, which updates required check tables with next iterator value;
  -- Get Iterator id
  li_iterator_id := iterator_id.nextval;
  WHILE(NEXT_VALUE(lr_check.chk_type, lr_scenario.ssc_iterator_code, lr_check.chk_code, li_iterator_id) = 1)
  LOOP
    li_i := li_i + 1;
    checks.run_checks(lr_scenario.ssc_chs_code, 'Suite '||lc_suite_mnemo||' scenario '||lr_scenario.ssc_mnemo||' iteration number: '||li_i,
    par_is_scenario => 1, par_run_code => ln_run_code) ;

    REGISTER_CHECK_PARS( par_scenario_code => lr_scenario.ssc_code, par_run_code => ln_run_code, par_run_type => 'ITERATION') ;

    -- Register run in the scenario runs table
    P_SCENARIO_RUNS.INSERT_ROW( par_scr_ssc_code => lr_scenario.ssc_code, par_scr_srn_code => ln_run_code, par_scr_type => 'ITERATION') ;

    EXIT
  WHEN(li_i = 10000) ; -- TODO - Remove this failsafe - failsafe for endless loop for now
  END LOOP;

  -- Step 4 Reset Suite parameters.
  UPDATE b_checks
  SET chk_active = 1
  WHERE chk_chs_code = lr_scenario.ssc_chs_code;

  -- Step 4.1 Get base run parameters and reset the check to pre-iteration value
  RESTORE_PARS(ln_base_run_code, lr_check) ;

  -- Step 5 Save Scenario stats.
  FOR rRuns IN cRuns(lr_scenario.ssc_code)
  LOOP
    statistics.GATHER_RUN_STATS(rRuns.scr_srn_code);
  END LOOP;

END RUN_SCENARIO;
------------------------------------------------------------------------------
PROCEDURE REGISTER_CHECK_PARS(
    par_scenario_code b_suite_scenarios.ssc_code%type,
    par_run_code b_suite_runs.srn_code%type,
    par_run_type b_scenario_check_pars.scp_type%type)
IS

  CURSOR cChecks(p_suite_code NUMBER)
  IS
    SELECT * FROM b_checks WHERE chk_chs_code = p_suite_code AND chk_active = 1;
  rChecks cChecks%rowtype;

  lc_table     VARCHAR2(200) ;
  lc_par_value VARCHAR2(2000) ;
  ln_chs_code b_check_suits.chs_code%type;
  lc_prefix VARCHAR2(100) ;

BEGIN

  SELECT ssc_chs_code
  INTO ln_chs_code
  FROM b_suite_scenarios
  WHERE ssc_code = par_scenario_code;

  FOR rChecks IN cChecks(ln_chs_code)
  LOOP
    lc_table :=
    CASE rChecks.chk_type
    WHEN 'MAX' THEN
      'B_MINMAX_CHECK_PARS'
    WHEN 'MIN' THEN
      'B_MINMAX_CHECK_PARS'
    WHEN 'RPREDICT' THEN
      'B_RPREDICT_CHECK_PARS'
    WHEN 'ALLOWED_LOV' THEN
      'B_LOV_CHECK_PARS'
    WHEN 'FORBIDDEN_LOV' THEN
      'B_LOV_CHECK_PARS'
    END;

    FOR rTabCols IN csh.cTabCols(lc_table)
    LOOP
      lc_prefix := upper(csh.get_table_prefix(lc_table)) ;
      -- Skip primary and foreign key columns
      IF(rTabCols.column_name != lc_prefix||'_CODE' AND rTabCols.column_name != lc_prefix||'_CHK_CODE') THEN
        lc_par_value := GET_PAR_VALUE(lc_table, rTabCols.column_name, rTabCols.data_type, rChecks.chk_code) ;

        P_SCENARIO_CHECK_PARS.INSERT_ROW(par_scp_chk_mnemo => rChecks.chk_mnemo, par_scp_chk_type => rChecks.chk_type, par_scp_par_name =>
        rTabCols.column_name, par_scp_par_value => lc_par_value, par_scp_srn_code => par_run_code, par_scp_ssc_code => par_scenario_code,
        par_scp_type => par_run_type) ;
      END IF;
    END LOOP;
  END LOOP;

END;

END SCENARIO_RUNNER;

/
