--------------------------------------------------------
--  Ref Constraints for Table B_RUN_STATS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."B_RUN_STATS" ADD CONSTRAINT "B_RUN_STATS_FK1" FOREIGN KEY ("RST_SRN_CODE")
	  REFERENCES "HUNDISILM"."B_SUITE_RUNS" ("SRN_CODE") ON DELETE CASCADE ENABLE;
