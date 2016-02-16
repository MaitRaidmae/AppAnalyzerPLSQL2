--------------------------------------------------------
--  Ref Constraints for Table UT_LOOKUP_VALUES
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."UT_LOOKUP_VALUES" ADD CONSTRAINT "UT_LOOKUP_VALUES_UT_LOOKU_FK1" FOREIGN KEY ("DATA_ID")
	  REFERENCES "HUNDISILM"."UT_LOOKUP_DATATYPES" ("ID") ON DELETE CASCADE ENABLE;
