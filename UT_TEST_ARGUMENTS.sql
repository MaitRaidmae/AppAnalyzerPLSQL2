--------------------------------------------------------
--  DDL for Table UT_TEST_ARGUMENTS
--------------------------------------------------------

  CREATE TABLE "HUNDISILM"."UT_TEST_ARGUMENTS" 
   (	"ARG_ID" VARCHAR2(40 BYTE), 
	"UT_ID" VARCHAR2(40 BYTE), 
	"OWNER" VARCHAR2(30 BYTE), 
	"OBJECT_NAME" VARCHAR2(30 BYTE), 
	"PACKAGE_NAME" VARCHAR2(30 BYTE), 
	"OBJECT_ID" NUMBER, 
	"OVERLOAD" VARCHAR2(40 BYTE), 
	"ARGUMENT_NAME" VARCHAR2(30 BYTE), 
	"POSITION" NUMBER, 
	"SEQUENCE" NUMBER, 
	"DATA_LEVEL" NUMBER, 
	"DATA_TYPE" VARCHAR2(30 BYTE), 
	"DEFAULT_LENGTH" NUMBER, 
	"IN_OUT" VARCHAR2(9 BYTE), 
	"DATA_LENGTH" NUMBER, 
	"DATA_PRECISION" NUMBER, 
	"DATA_SCALE" NUMBER, 
	"RADIX" NUMBER, 
	"CHARACTER_SET_NAME" VARCHAR2(44 BYTE), 
	"TYPE_OWNER" VARCHAR2(30 BYTE), 
	"TYPE_NAME" VARCHAR2(30 BYTE), 
	"TYPE_SUBNAME" VARCHAR2(30 BYTE), 
	"TYPE_LINK" VARCHAR2(128 BYTE), 
	"PLS_TYPE" VARCHAR2(30 BYTE), 
	"CHAR_LENGTH" NUMBER, 
	"CHAR_USED" VARCHAR2(1 BYTE), 
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