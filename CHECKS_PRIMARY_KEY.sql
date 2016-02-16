--------------------------------------------------------
--  DDL for Trigger CHECKS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."CHECKS#PRIMARY_KEY" 
   before insert on "HUNDISILM"."B_CHECKS" 
   for each row 
begin  
   if inserting then 
      if :NEW."CHK_CODE" is null then 
         select CHECKS#CHK_CODE.nextval into :NEW."CHK_CODE" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "HUNDISILM"."CHECKS#PRIMARY_KEY" ENABLE;
