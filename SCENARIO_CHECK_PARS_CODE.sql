--------------------------------------------------------
--  DDL for Trigger SCENARIO_CHECK_PARS#CODE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."SCENARIO_CHECK_PARS#CODE" 
before insert on "B_SCENARIO_CHECK_PARS"
for each row
begin
if inserting then
if :NEW."SCP_CODE" is null then
select SCENARIO_CHECK_PARS#SCP_CODE.nextval into :NEW."SCP_CODE" from dual;
end if;
end if;
end;
/
ALTER TRIGGER "HUNDISILM"."SCENARIO_CHECK_PARS#CODE" ENABLE;
