--------------------------------------------------------
--  DDL for Trigger RPREDICT_CHECK#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."RPREDICT_CHECK#PRIMARY_KEY" 
   before insert on "HUNDISILM"."B_RPREDICT_CHECK_PARS" 
   for each row 
begin  
   if inserting then 
      if :NEW."RCP_CODE" is null then 
         select RPREDICT_CHECK_PARS#RCP_CODE.nextval into :NEW."RCP_CODE" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "HUNDISILM"."RPREDICT_CHECK#PRIMARY_KEY" ENABLE;
