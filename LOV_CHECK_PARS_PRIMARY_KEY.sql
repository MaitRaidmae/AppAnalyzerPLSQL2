--------------------------------------------------------
--  DDL for Trigger LOV_CHECK_PARS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."LOV_CHECK_PARS#PRIMARY_KEY" 
   before insert on "HUNDISILM"."B_LOV_CHECK_PARS" 
   for each row 
begin  
   if inserting then 
      if :NEW."LCP_CODE" is null then 
         select LOV_CHECK_PARS#LCP_CODE.nextval into :NEW."LCP_CODE" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "HUNDISILM"."LOV_CHECK_PARS#PRIMARY_KEY" ENABLE;
