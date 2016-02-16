--------------------------------------------------------
--  DDL for Trigger APP_CONTROLLERS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."APP_CONTROLLERS#PRIMARY_KEY" 
   before insert on "HUNDISILM"."B_APP_CONTROLLERS" 
   for each row 
begin  
   if inserting then 
      if :NEW."ACO_CODE" is null then 
         select APP_CONTORLLERS#ACO_CODE.nextval into :NEW."ACO_CODE" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "HUNDISILM"."APP_CONTROLLERS#PRIMARY_KEY" ENABLE;
