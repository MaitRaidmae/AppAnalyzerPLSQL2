--------------------------------------------------------
--  Ref Constraints for Table UT_TEST_ARGUMENTS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."UT_TEST_ARGUMENTS" ADD CONSTRAINT "UT_TEST_ARGUMENTS_FK" FOREIGN KEY ("UT_ID")
	  REFERENCES "HUNDISILM"."UT_TEST" ("UT_ID") ON DELETE CASCADE ENABLE;
