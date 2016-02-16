--------------------------------------------------------
--  DDL for Trigger UT_TEST_IMPL_VAL_RESULTS_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."UT_TEST_IMPL_VAL_RESULTS_TRG" 
BEFORE INSERT ON UT_TEST_IMPL_VAL_RESULTS
FOR EACH ROW 
BEGIN
  if (:NEW.UTIVR_ID is null or :NEW.UTIVR_ID = '') then 
      SELECT  SYS_GUID() INTO :NEW.UTIVR_ID FROM DUAL;
  end if;
  if (:NEW.STATUS is null or :NEW.STATUS = '') then 
      :NEW.STATUS := 'RUNNING';
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
ALTER TRIGGER "HUNDISILM"."UT_TEST_IMPL_VAL_RESULTS_TRG" ENABLE;
