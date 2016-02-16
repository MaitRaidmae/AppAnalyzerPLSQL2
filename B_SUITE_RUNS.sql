--------------------------------------------------------
--  DDL for Table B_SUITE_RUNS
--------------------------------------------------------

  CREATE TABLE "HUNDISILM"."B_SUITE_RUNS" 
   (	"SRN_CODE" NUMBER(*,0), 
	"SRN_CHS_CODE" NUMBER(*,0), 
	"SRN_DATE" TIMESTAMP (6), 
	"SRN_COMMENT" VARCHAR2(2000 BYTE), 
	"SRN_TYPE" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

   COMMENT ON COLUMN "HUNDISILM"."B_SUITE_RUNS"."SRN_CODE" IS 'Primary Key';
   COMMENT ON COLUMN "HUNDISILM"."B_SUITE_RUNS"."SRN_CHS_CODE" IS 'Check Suit Code';
   COMMENT ON COLUMN "HUNDISILM"."B_SUITE_RUNS"."SRN_DATE" IS 'Timestamp of the run';
   COMMENT ON COLUMN "HUNDISILM"."B_SUITE_RUNS"."SRN_COMMENT" IS 'Comment for the current run.';
   COMMENT ON COLUMN "HUNDISILM"."B_SUITE_RUNS"."SRN_TYPE" IS 'Either SCENARIO or OTHER';