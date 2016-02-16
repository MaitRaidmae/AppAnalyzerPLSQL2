--------------------------------------------------------
--  Ref Constraints for Table B_MINMAX_CHECK_PARS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."B_MINMAX_CHECK_PARS" ADD CONSTRAINT "B_MINMAX_CHECK_PARS_FK1" FOREIGN KEY ("MCP_CHK_CODE")
	  REFERENCES "HUNDISILM"."B_CHECKS" ("CHK_CODE") ON DELETE CASCADE ENABLE;
