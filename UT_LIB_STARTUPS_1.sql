--------------------------------------------------------
--  DDL for Trigger UT_LIB_STARTUPS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."UT_LIB_STARTUPS" 
BEFORE INSERT ON UT_LIB_STARTUPS
FOR EACH ROW 
BEGIN
  if (:NEW.LIB_STARTUP_ID is null or :NEW.LIB_STARTUP_ID = '') then
      SELECT  SYS_GUID() INTO :NEW.LIB_STARTUP_ID FROM DUAL;
  end if;
  if (:NEW.CREATED_ON is null or :NEW.CREATED_ON = '') then
      SELECT sysdate INTO :NEW.CREATED_ON FROM DUAL;
  end if;
  if (:NEW.CREATED_BY is null or :NEW.CREATED_BY = '') then
      SELECT user INTO :NEW.CREATED_BY FROM DUAL;
  end if;
  if (:NEW.UPDATED_ON is null or :NEW.UPDATED_ON = '') then
      SELECT sysdate INTO :NEW.UPDATED_ON FROM DUAL;
  end if;
  if (:NEW.UPDATED_BY is null or :NEW.UPDATED_BY = '') then
      SELECT user INTO :NEW.UPDATED_BY FROM DUAL;
  end if;
END;
/
ALTER TRIGGER "HUNDISILM"."UT_LIB_STARTUPS" ENABLE;
