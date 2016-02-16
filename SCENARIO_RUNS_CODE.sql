--------------------------------------------------------
--  DDL for Trigger SCENARIO_RUNS#CODE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."SCENARIO_RUNS#CODE" 
before insert on "B_SCENARIO_RUNS"
for each row
begin
if inserting then
if :NEW."SCR_CODE" is null then
select SCENARIO_RUNS#SCR_CODE.nextval into :NEW."SCR_CODE" from dual;
end if;
end if;
end;
/
ALTER TRIGGER "HUNDISILM"."SCENARIO_RUNS#CODE" ENABLE;
