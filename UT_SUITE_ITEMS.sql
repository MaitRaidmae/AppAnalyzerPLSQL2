--------------------------------------------------------
--  DDL for Table UT_SUITE_ITEMS
--------------------------------------------------------

  CREATE TABLE "HUNDISILM"."UT_SUITE_ITEMS" 
   (	"UT_SID" VARCHAR2(40 BYTE), 
	"UT_ID" VARCHAR2(40 BYTE), 
	"UT_NSID" VARCHAR2(40 BYTE), 
	"RUN_START" VARCHAR2(1 BYTE), 
	"RUN_TEAR" VARCHAR2(1 BYTE), 
	"SEQUENCE" NUMBER, 
	"CREATED_ON" TIMESTAMP (6), 
	"CREATED_BY" VARCHAR2(120 BYTE), 
	"UPDATED_ON" TIMESTAMP (6), 
	"UPDATED_BY" VARCHAR2(120 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
