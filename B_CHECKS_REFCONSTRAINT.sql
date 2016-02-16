--------------------------------------------------------
--  Ref Constraints for Table B_CHECKS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."B_CHECKS" ADD CONSTRAINT "CHECKS#CHECK_SUITES#CHS_CODE" FOREIGN KEY ("CHK_CHS_CODE")
	  REFERENCES "HUNDISILM"."B_CHECK_SUITS" ("CHS_CODE") ENABLE;
