--------------------------------------------------------
--  DDL for Trigger SCENARIO_CHECKS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."SCENARIO_CHECKS#PRIMARY_KEY" 
before insert on "B_SCENARIO_CHECKS"
for each row
begin
if inserting then
if :NEW."SCC_CODE" is null then
select SCENARIO_CHECKS#SCC_CODE.nextval into :NEW."SCC_CODE" from dual;
end if;
end if;
end;
/
ALTER TRIGGER "HUNDISILM"."SCENARIO_CHECKS#PRIMARY_KEY" ENABLE;
