--------------------------------------------------------
--  DDL for View ALL_UT_TEARDOWNS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."ALL_UT_TEARDOWNS" ("TEARDOWN_ID", "UT_ID", "UT_SID", "INDEX_NO", "TEARDOWN", "LIB_TEARDOWN_ID", "CREATED_ON", "CREATED_BY") AS 
  SELECT "TEARDOWN_ID",
    "UT_ID",
    "UT_SID",
    "INDEX_NO",
    "TEARDOWN",
    "LIB_TEARDOWN_ID",
    "CREATED_ON",
    "CREATED_BY"
  FROM UT_TEARDOWNS;

   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEARDOWNS"."TEARDOWN_ID" IS 'Teardown Code Hook usage identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEARDOWNS"."UT_ID" IS 'Suite identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEARDOWNS"."INDEX_NO" IS 'Index within list of teardowns of Test';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEARDOWNS"."TEARDOWN" IS 'Code Hook property XML';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEARDOWNS"."LIB_TEARDOWN_ID" IS 'Library Teardown Code Hook identifier when referencing library object';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEARDOWNS"."CREATED_ON" IS 'Creation timestamp';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEARDOWNS"."CREATED_BY" IS 'Created by user';
   COMMENT ON TABLE "HUNDISILM"."ALL_UT_TEARDOWNS"  IS 'Unit Test - Teardown Code Hooks';
