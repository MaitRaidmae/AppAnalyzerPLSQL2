--------------------------------------------------------
--  Ref Constraints for Table UT_SUITE_RESULTS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."UT_SUITE_RESULTS" ADD CONSTRAINT "UT_SUITE_RESULTS_FK1" FOREIGN KEY ("UT_SID")
	  REFERENCES "HUNDISILM"."UT_SUITE" ("UT_SID") ON DELETE CASCADE ENABLE;
