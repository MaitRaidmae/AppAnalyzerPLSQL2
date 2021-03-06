--------------------------------------------------------
--  DDL for Trigger UT_LIB_TEARDOWNS_UP_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."UT_LIB_TEARDOWNS_UP_TRG" 
BEFORE UPDATE ON UT_LIB_TEARDOWNS
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
ALTER TRIGGER "HUNDISILM"."UT_LIB_TEARDOWNS_UP_TRG" ENABLE;
