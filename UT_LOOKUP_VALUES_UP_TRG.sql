--------------------------------------------------------
--  DDL for Trigger UT_LOOKUP_VALUES_UP_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."UT_LOOKUP_VALUES_UP_TRG" 
BEFORE UPDATE ON UT_LOOKUP_VALUES
FOR EACH ROW 
BEGIN
  if (:NEW.UPDATED_ON is null or :NEW.UPDATED_ON = '') then
      SELECT sysdate INTO :NEW.UPDATED_ON FROM DUAL;
  end if;
  if (:NEW.UPDATED_BY is null or :NEW.UPDATED_BY = '') then
      SELECT user INTO :NEW.UPDATED_BY FROM DUAL;
  end if;
END;
/
ALTER TRIGGER "HUNDISILM"."UT_LOOKUP_VALUES_UP_TRG" ENABLE;
