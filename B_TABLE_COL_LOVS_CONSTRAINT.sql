--------------------------------------------------------
--  Constraints for Table B_TABLE_COL_LOVS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."B_TABLE_COL_LOVS" MODIFY ("TCL_CODE" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."B_TABLE_COL_LOVS" ADD CONSTRAINT "B_TABLE_COL_LOVS_PK" PRIMARY KEY ("TCL_CODE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "USERS"  ENABLE;
