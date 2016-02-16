--------------------------------------------------------
--  DDL for Trigger APP_CHECKS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."APP_CHECKS#PRIMARY_KEY" 
   before insert on "B_APP_CHECKS" 
   for each row 
begin  
   if inserting then 
      if :NEW."ACK_CODE" is null then 
         select APP_CHECKS#ACK_CODE.nextval into :NEW."ACK_CODE" from dual; 
      end if; 
   end if; 
end;
/
ALTER TRIGGER "HUNDISILM"."APP_CHECKS#PRIMARY_KEY" ENABLE;
