--------------------------------------------------------
--  DDL for Trigger RUN_STATS#CODE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."RUN_STATS#CODE" 
before insert on "B_RUN_STATS"
for each row
begin
if inserting then
if :NEW."RST_CODE" is null then
select RUN_STATS#RST_CODE.nextval into :NEW."RST_CODE" from dual;
end if;
end if;
end;
/
ALTER TRIGGER "HUNDISILM"."RUN_STATS#CODE" ENABLE;
