--------------------------------------------------------
--  DDL for View ALL_UT_TEST_COVERAGE_STATS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS" ("UTC_ID", "UTIR_ID", "UTI_ID", "UNIT_OWNER", "UNIT_NAME", "LINE", "TOTAL_OCCUR", "TOTAL_TIME", "TEXT") AS 
  SELECT
    "UTC_ID" AS "UTC_ID"
   ,"UTIR_ID" AS "UTIR_ID"
   ,"UTI_ID" AS "UTI_ID"
   ,"UNIT_OWNER" AS "UNIT_OWNER"
   ,"UNIT_NAME" AS "UNIT_NAME"
   ,"LINE" AS "LINE"
   ,"TOTAL_OCCUR" AS "TOTAL_OCCUR"
   ,"TOTAL_TIME" AS "TOTAL_TIME"
   ,"TEXT" AS "TEXT"
  FROM
    "UT_TEST_COVERAGE_STATS"
  WITH READ ONLY;

   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS"."UTC_ID" IS 'Coverage Statistics identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS"."UTIR_ID" IS 'Test Implementation Results identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS"."UTI_ID" IS 'Test Implementation identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS"."UNIT_OWNER" IS 'Owner of callable database object';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS"."UNIT_NAME" IS 'Name of callable database object';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS"."LINE" IS 'Line number of executed code';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS"."TOTAL_OCCUR" IS 'Number of time line of code executed';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS"."TOTAL_TIME" IS 'Accumulated time elasped time line of code executed in milliseconds';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS"."TEXT" IS 'Text of executed line';
   COMMENT ON TABLE "HUNDISILM"."ALL_UT_TEST_COVERAGE_STATS"  IS 'Unit Test - Coverage Statistics';
