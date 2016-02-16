--------------------------------------------------------
--  DDL for Trigger CONTROLLER_SIBLINGS#CODE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."CONTROLLER_SIBLINGS#CODE" 
   before insert on "HUNDISILM"."B_CONTROLLER_SIBLINGS" 
   for each row 
begin  
   if inserting then 
      if :NEW."COS_CODE" is null then 
         select CONTROLLER_SIBLINGS#COS_CODE.nextval into :NEW."COS_CODE" from dual; 
      end if; 
   end if; 
end;
/
ALTER TRIGGER "HUNDISILM"."CONTROLLER_SIBLINGS#CODE" ENABLE;
