--------------------------------------------------------
--  DDL for View ALL_UT_SUITE_ITEM_RESULTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."ALL_UT_SUITE_ITEM_RESULTS" ("UTSR_ID", "UTR_ID", "UTR_NSID") AS 
  SELECT
    "UTSR_ID" AS "UTSR_ID"
   ,"UTR_ID" AS "UTR_ID"
   ,"UTR_NSID" AS "UTR_NSID"
  FROM
    "UT_SUITE_ITEM_RESULTS"
  WITH READ ONLY;

   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_SUITE_ITEM_RESULTS"."UTSR_ID" IS 'Suite Result identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_SUITE_ITEM_RESULTS"."UTR_ID" IS 'Test Result identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_SUITE_ITEM_RESULTS"."UTR_NSID" IS 'Nested Suite Result identifier';
   COMMENT ON TABLE "HUNDISILM"."ALL_UT_SUITE_ITEM_RESULTS"  IS 'Unit Test - Item Results within a Suite';
