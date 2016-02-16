--------------------------------------------------------
--  Ref Constraints for Table PLSQL_PROFILER_DATA
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."PLSQL_PROFILER_DATA" ADD FOREIGN KEY ("RUNID", "UNIT_NUMBER")
	  REFERENCES "HUNDISILM"."PLSQL_PROFILER_UNITS" ("RUNID", "UNIT_NUMBER") ENABLE;
