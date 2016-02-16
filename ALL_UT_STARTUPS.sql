--------------------------------------------------------
--  DDL for View ALL_UT_STARTUPS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."ALL_UT_STARTUPS" ("STARTUP_ID", "UT_ID", "UT_SID", "INDEX_NO", "STARTUP", "LIB_STARTUP_ID", "CREATED_ON", "CREATED_BY") AS 
  SELECT "STARTUP_ID",
    "UT_ID",
    "UT_SID",
    "INDEX_NO",
    "STARTUP",
    "LIB_STARTUP_ID",
    "CREATED_ON",
    "CREATED_BY"
  FROM ut_startups;

   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_STARTUPS"."STARTUP_ID" IS 'Startup Code Hook usage identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_STARTUPS"."UT_ID" IS 'Suite identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_STARTUPS"."INDEX_NO" IS 'Index within list of startups of Test';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_STARTUPS"."STARTUP" IS 'Code Hook property XML';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_STARTUPS"."LIB_STARTUP_ID" IS 'Library Startup Code Hook identifier when referencing library object';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_STARTUPS"."CREATED_ON" IS 'Creation timestamp';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_STARTUPS"."CREATED_BY" IS 'Created by user';
   COMMENT ON TABLE "HUNDISILM"."ALL_UT_STARTUPS"  IS 'Unit Test - Startup Code Hooks';
