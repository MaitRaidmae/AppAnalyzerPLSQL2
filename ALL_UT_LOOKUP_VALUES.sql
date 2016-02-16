--------------------------------------------------------
--  DDL for View ALL_UT_LOOKUP_VALUES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."ALL_UT_LOOKUP_VALUES" ("ID", "DATA_ID", "VALUE") AS 
  SELECT
    "ID" AS "ID"
   ,"DATA_ID" AS "DATA_ID"
   ,"VALUE" AS "VALUE"
  FROM
    "UT_LOOKUP_VALUES"
  WITH READ ONLY;

   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_LOOKUP_VALUES"."ID" IS 'Lookup Value identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_LOOKUP_VALUES"."DATA_ID" IS 'Datatype identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_LOOKUP_VALUES"."VALUE" IS 'Value property XML';
   COMMENT ON TABLE "HUNDISILM"."ALL_UT_LOOKUP_VALUES"  IS 'Unit Test - Lookup Value';
