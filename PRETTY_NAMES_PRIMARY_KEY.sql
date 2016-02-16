--------------------------------------------------------
--  DDL for Trigger PRETTY_NAMES#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."PRETTY_NAMES#PRIMARY_KEY" 
   before insert on "HUNDISILM"."B_PRETTY_NAMES" 
   for each row 
begin  
   if inserting then 
      if :NEW."PRN_CODE" is null then 
         select PRETTY_NAMES#PRN_CODE.nextval into :NEW."PRN_CODE" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "HUNDISILM"."PRETTY_NAMES#PRIMARY_KEY" ENABLE;
