--------------------------------------------------------
--  Ref Constraints for Table B_SUITE_SCENARIOS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."B_SUITE_SCENARIOS" ADD CONSTRAINT "B_SUITE_SCENARIOS_FK1" FOREIGN KEY ("SSC_CHS_CODE")
	  REFERENCES "HUNDISILM"."B_CHECK_SUITS" ("CHS_CODE") ON DELETE CASCADE ENABLE;
