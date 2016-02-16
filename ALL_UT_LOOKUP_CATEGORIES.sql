--------------------------------------------------------
--  DDL for View ALL_UT_LOOKUP_CATEGORIES
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."ALL_UT_LOOKUP_CATEGORIES" ("ID", "NAME") AS 
  SELECT
    "ID" AS "ID"
   ,"NAME" AS "NAME"
  FROM
    "UT_LOOKUP_CATEGORIES"
  WITH READ ONLY;

   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_LOOKUP_CATEGORIES"."ID" IS 'Lookup Category identifier';
   COMMENT ON COLUMN "HUNDISILM"."ALL_UT_LOOKUP_CATEGORIES"."NAME" IS 'Category name';
   COMMENT ON TABLE "HUNDISILM"."ALL_UT_LOOKUP_CATEGORIES"  IS 'Unit Test - Lookup Categories';
