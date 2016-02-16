--------------------------------------------------------
--  DDL for Trigger CHECK_LOVS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."CHECK_LOVS#PRIMARY_KEY" 
   before insert on "HUNDISILM"."B_CHECK_LOVS" 
   for each row 
begin  
   if inserting then 
      if :NEW."CLV_CODE" is null then 
         select CHECK_LOVS#CLV_CODE.nextval into :NEW."CLV_CODE" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "HUNDISILM"."CHECK_LOVS#PRIMARY_KEY" ENABLE;
