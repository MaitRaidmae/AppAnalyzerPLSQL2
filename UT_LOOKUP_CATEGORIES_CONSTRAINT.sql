--------------------------------------------------------
--  Constraints for Table UT_LOOKUP_CATEGORIES
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."UT_LOOKUP_CATEGORIES" MODIFY ("ID" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LOOKUP_CATEGORIES" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LOOKUP_CATEGORIES" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LOOKUP_CATEGORIES" MODIFY ("UPDATED_ON" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LOOKUP_CATEGORIES" MODIFY ("UPDATED_BY" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LOOKUP_CATEGORIES" ADD CONSTRAINT "UT_LOOKUP_CATEGORIES_PK" PRIMARY KEY ("ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "HUNDISILM"."UT_LOOKUP_CATEGORIES" ADD CONSTRAINT "UT_LOOKUP_CATEGORIES_UK1" UNIQUE ("NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;