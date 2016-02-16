--------------------------------------------------------
--  DDL for Trigger CHECK_SUITS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."CHECK_SUITS#PRIMARY_KEY" 
   before insert on "B_CHECK_SUITS" 
   for each row 
begin  
   if inserting then 
      if :NEW."CHS_CODE" is null then 
         select CHECK_SUITS#CHS_CODE.nextval into :NEW."CHS_CODE" from dual; 
      end if; 
   end if; 
end;
/
ALTER TRIGGER "HUNDISILM"."CHECK_SUITS#PRIMARY_KEY" ENABLE;
