--------------------------------------------------------
--  Ref Constraints for Table UT_LOOKUP_DATATYPES
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."UT_LOOKUP_DATATYPES" ADD CONSTRAINT "UT_LOOKUP_DATATYPES_UT_LO_FK1" FOREIGN KEY ("CAT_ID")
	  REFERENCES "HUNDISILM"."UT_LOOKUP_CATEGORIES" ("ID") ON DELETE CASCADE ENABLE;
