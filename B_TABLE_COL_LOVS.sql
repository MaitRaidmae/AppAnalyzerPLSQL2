--------------------------------------------------------
--  DDL for Table B_TABLE_COL_LOVS
--------------------------------------------------------

  CREATE TABLE "HUNDISILM"."B_TABLE_COL_LOVS" 
   (	"TCL_CODE" NUMBER(*,0), 
	"TCL_NVALUE" NUMBER, 
	"TCL_CVALUE" VARCHAR2(2000 BYTE), 
	"TCL_DVALUE" TIMESTAMP (6)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "USERS" ;

   COMMENT ON COLUMN "HUNDISILM"."B_TABLE_COL_LOVS"."TCL_CODE" IS 'Primary key';
   COMMENT ON COLUMN "HUNDISILM"."B_TABLE_COL_LOVS"."TCL_NVALUE" IS 'Numeric LOV value';
   COMMENT ON COLUMN "HUNDISILM"."B_TABLE_COL_LOVS"."TCL_CVALUE" IS 'Character LOV value';
   COMMENT ON COLUMN "HUNDISILM"."B_TABLE_COL_LOVS"."TCL_DVALUE" IS 'TimeStamp value for LOV entry';
