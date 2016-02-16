--------------------------------------------------------
--  DDL for Trigger MINMAX_CHECK_PARS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."MINMAX_CHECK_PARS#PRIMARY_KEY" 
   before insert on "HUNDISILM"."B_MINMAX_CHECK_PARS" 
   for each row 
begin  
   if inserting then 
      if :NEW."MCP_CODE" is null then 
         select MINMAX_CHECK_PARS#MCP_CODE.nextval into :NEW."MCP_CODE" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "HUNDISILM"."MINMAX_CHECK_PARS#PRIMARY_KEY" ENABLE;
