--------------------------------------------------------
--  Constraints for Table UT_TEST_IMPL
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."UT_TEST_IMPL" MODIFY ("UT_ID" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_TEST_IMPL" MODIFY ("NAME" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_TEST_IMPL" ADD CONSTRAINT "UT_TEST_IMPL_PK" PRIMARY KEY ("UTI_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "HUNDISILM"."UT_TEST_IMPL" ADD CONSTRAINT "UT_TEST_IMPL_UK1" UNIQUE ("UT_ID", "NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "HUNDISILM"."UT_TEST_IMPL" ADD CONSTRAINT "UT_DYN_QUERY_CHECK" CHECK ("DYNAMIC_VALUE_QUERY" IS NULL OR "LIB_DYN_QUERY_ID" IS NULL) ENABLE;
  ALTER TABLE "HUNDISILM"."UT_TEST_IMPL" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_TEST_IMPL" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_TEST_IMPL" MODIFY ("UPDATED_ON" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_TEST_IMPL" MODIFY ("UPDATED_BY" NOT NULL ENABLE);
