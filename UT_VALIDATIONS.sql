--------------------------------------------------------
--  DDL for Table UT_VALIDATIONS
--------------------------------------------------------

  CREATE TABLE "HUNDISILM"."UT_VALIDATIONS" 
   (	"VALIDATION_ID" VARCHAR2(40 BYTE), 
	"UTI_ID" VARCHAR2(40 BYTE), 
	"INDEX_NO" NUMBER(*,0), 
	"VALIDATION" CLOB, 
	"LIB_VALIDATION_ID" VARCHAR2(40 BYTE), 
	"APPLY_VALIDATION" NUMBER(1,0) DEFAULT 1, 
	"CREATED_ON" TIMESTAMP (6), 
	"CREATED_BY" VARCHAR2(120 BYTE), 
	"UPDATED_ON" TIMESTAMP (6), 
	"UPDATED_BY" VARCHAR2(120 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "USERS" 
 LOB ("VALIDATION") STORE AS SECUREFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES ) ;
