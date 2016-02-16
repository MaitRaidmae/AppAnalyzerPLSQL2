--------------------------------------------------------
--  DDL for Package STATISTICS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "HUNDISILM"."STATISTICS" AUTHID DEFINER
AS

  PROCEDURE GATHER_RUN_STATS(
      par_srn_code b_suite_runs.srn_code%type);
  
  /* Checks whether the application is approved (i.e. no triggered checks)
  *  If par_iter_srn_code is indicated, the checks in iteration run override
  *  base runs checks.
  */
  FUNCTION IS_APPLICATION_APPROVED(
      par_apl_code b_applications.apl_code%type,
      par_srn_code b_suite_runs.srn_code%type,
      par_base_srn_code b_suite_runs.srn_code%type DEFAULT NULL)
    RETURN PLS_INTEGER;


END STATISTICS;

/
