--------------------------------------------------------
--  DDL for Index UT_TEST_ARGUMENTS_IX
--------------------------------------------------------

  CREATE INDEX "HUNDISILM"."UT_TEST_ARGUMENTS_IX" ON "HUNDISILM"."UT_TEST_ARGUMENTS" ("UT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
