--------------------------------------------------------
--  DDL for View ALL_UT_METADATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."ALL_UT_METADATA" ("NAME", "VALUE") AS 
  SELECT
    "NAME" AS "NAME"
   ,"VALUE" AS "VALUE"
  FROM
    "UT_METADATA"
  WITH READ ONLY;

   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_METADATA"."NAME" IS 'Metadata name';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_METADATA"."VALUE" IS 'Metadata value';
   COMMENT ON TABLE "HUNDISILM"."ALL_UT_METADATA"  IS 'Unit Test - Metadata';
