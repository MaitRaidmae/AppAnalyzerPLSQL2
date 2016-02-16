--------------------------------------------------------
--  Ref Constraints for Table B_SCENARIO_CHECKS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."B_SCENARIO_CHECKS" ADD CONSTRAINT "B_SCENARIO_CHECKS_FK1" FOREIGN KEY ("SCC_APL_CODE")
	  REFERENCES "HUNDISILM"."B_APPLICATIONS" ("APL_CODE") ON DELETE CASCADE ENABLE;
  ALTER TABLE "HUNDISILM"."B_SCENARIO_CHECKS" ADD CONSTRAINT "B_SCENARIO_CHECKS_FK2" FOREIGN KEY ("SCC_CHK_CODE")
	  REFERENCES "HUNDISILM"."B_CHECKS" ("CHK_CODE") ON DELETE CASCADE ENABLE;
  ALTER TABLE "HUNDISILM"."B_SCENARIO_CHECKS" ADD CONSTRAINT "B_SCENARIO_CHECKS_FK3" FOREIGN KEY ("SCC_SRN_CODE")
	  REFERENCES "HUNDISILM"."B_SUITE_RUNS" ("SRN_CODE") ON DELETE CASCADE ENABLE;
