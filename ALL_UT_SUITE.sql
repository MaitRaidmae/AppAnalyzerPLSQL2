--------------------------------------------------------
--  DDL for View ALL_UT_SUITE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."ALL_UT_SUITE" ("UT_SID", "COVERAGE", "NAME", "CREATED_ON", "CREATED_BY") AS 
  SELECT
    "UT_SID" AS "UT_SID"
   ,DECODE("COVERAGE", 0, 'N', 'Y') AS "COVERAGE"
   ,"NAME" AS "NAME"
   ,"CREATED_ON" AS "CREATED_ON"
   ,"CREATED_BY" AS "CREATED_BY"
  FROM
    "UT_SUITE"
  WITH READ ONLY;

   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_SUITE"."UT_SID" IS 'Suite identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_SUITE"."COVERAGE" IS 'Collect coverage statistics - Y or N';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_SUITE"."NAME" IS 'Suite name';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_SUITE"."CREATED_ON" IS 'Creation timestamp';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_SUITE"."CREATED_BY" IS 'Created by user';
   COMMENT ON TABLE "HUNDISILM"."ALL_UT_SUITE"  IS 'Unit Test - Suite';
