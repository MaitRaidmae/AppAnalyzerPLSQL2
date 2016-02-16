--------------------------------------------------------
--  DDL for Trigger SUIT_RUNS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."SUIT_RUNS#PRIMARY_KEY" 
   before insert on "HUNDISILM"."B_SUITE_RUNS" 
   for each row 
begin  
   if inserting then 
      if :NEW."SRN_CODE" is null then 
         select SUIT_RUNS#SRN_CODE.nextval into :NEW."SRN_CODE" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "HUNDISILM"."SUIT_RUNS#PRIMARY_KEY" ENABLE;
