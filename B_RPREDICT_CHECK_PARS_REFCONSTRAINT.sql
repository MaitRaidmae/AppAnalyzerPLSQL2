--------------------------------------------------------
--  Ref Constraints for Table B_RPREDICT_CHECK_PARS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."B_RPREDICT_CHECK_PARS" ADD CONSTRAINT "RPREDICT#CHECKS#CHK_CODE" FOREIGN KEY ("RCP_CHK_CODE")
	  REFERENCES "HUNDISILM"."B_CHECKS" ("CHK_CODE") ON DELETE CASCADE ENABLE;
