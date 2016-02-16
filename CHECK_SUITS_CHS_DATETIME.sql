--------------------------------------------------------
--  DDL for Trigger CHECK_SUITS#CHS_DATETIME
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."CHECK_SUITS#CHS_DATETIME" 
BEFORE INSERT ON B_CHECK_SUITS for each row
BEGIN
  :NEW.CHS_DATETIME := systimestamp;
END;
/
ALTER TRIGGER "HUNDISILM"."CHECK_SUITS#CHS_DATETIME" ENABLE;
