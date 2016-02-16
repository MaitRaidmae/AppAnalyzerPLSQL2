--------------------------------------------------------
--  DDL for Trigger TABLE_CLOV_PARS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."TABLE_CLOV_PARS#PRIMARY_KEY" 
   before insert on "HUNDISILM"."B_TABLE_COL_LOV_PARS" 
   for each row 
begin  
   if inserting then 
      if :NEW."TLP_CODE" is null then 
         select TABLE_CLOV_PARS#TLP_CODE.nextval into :NEW."TLP_CODE" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "HUNDISILM"."TABLE_CLOV_PARS#PRIMARY_KEY" ENABLE;
