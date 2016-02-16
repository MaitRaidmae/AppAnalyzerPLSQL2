--------------------------------------------------------
--  Ref Constraints for Table UT_TEST_RESULTS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."UT_TEST_RESULTS" ADD CONSTRAINT "UT_TEST_RESULTS_UT_TEST_FK1" FOREIGN KEY ("UT_ID")
	  REFERENCES "HUNDISILM"."UT_TEST" ("UT_ID") ON DELETE CASCADE ENABLE;
