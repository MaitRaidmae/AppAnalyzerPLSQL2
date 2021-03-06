--------------------------------------------------------
--  DDL for Table UT_TEST_COVERAGE_STATS
--------------------------------------------------------

  CREATE TABLE "HUNDISILM"."UT_TEST_COVERAGE_STATS" 
   (	"UTC_ID" VARCHAR2(40 BYTE), 
	"UTIR_ID" VARCHAR2(40 BYTE), 
	"UTI_ID" VARCHAR2(40 BYTE), 
	"UNIT_OWNER" VARCHAR2(30 BYTE), 
	"UNIT_NAME" VARCHAR2(30 BYTE), 
	"LINE" NUMBER, 
	"TOTAL_OCCUR" NUMBER, 
	"TOTAL_TIME" NUMBER, 
	"TEXT" VARCHAR2(4000 BYTE), 
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
