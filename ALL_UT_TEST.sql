--------------------------------------------------------
--  DDL for View ALL_UT_TEST
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."ALL_UT_TEST" ("UT_ID", "NAME", "OBJECT_NAME", "OBJECT_TYPE", "OBJECT_OWNER", "OBJECT_CALL", "CONNECTION_NAME", "COVERAGE", "CREATED_ON", "CREATED_BY") AS 
  SELECT
    "UT_ID" AS "UT_ID"
   ,"NAME" AS "NAME"
   ,"OBJECT_NAME" AS "OBJECT_NAME"
   ,"OBJECT_TYPE" AS "OBJECT_TYPE"
   ,"OBJECT_OWNER" AS "OBJECT_OWNER"
   ,"OBJECT_CALL" AS "OBJECT_CALL"
   ,"CONNECTION_NAME" AS "CONNECTION_NAME"
   ,DECODE("COVERAGE", 0, 'N', 'Y') AS "COVERAGE"
   ,"CREATED_ON" AS "CREATED_ON"
   ,"CREATED_BY" AS "CREATED_BY"
  FROM
    "UT_TEST"
  WITH READ ONLY;

   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST"."UT_ID" IS 'Test identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST"."NAME" IS 'Test name';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST"."OBJECT_NAME" IS 'Database object name';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST"."OBJECT_TYPE" IS 'Database object type';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST"."OBJECT_OWNER" IS 'Database object owner';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST"."OBJECT_CALL" IS 'Database object callable interface';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST"."CONNECTION_NAME" IS 'Name of connection used to import test';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST"."COVERAGE" IS 'Collect coverage statistics - Y or N';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST"."CREATED_ON" IS 'Creation timestamp';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_TEST"."CREATED_BY" IS 'Created by user';
   COMMENT ON TABLE "HUNDISILM"."ALL_UT_TEST"  IS 'Unit Test - Tests';
