--------------------------------------------------------
--  DDL for Trigger MINMAX_ITERATORS#CODE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."MINMAX_ITERATORS#CODE" 
before insert on "B_MINMAX_ITERATORS"
for each row
begin
if inserting then
if :NEW."MMI_CODE" is null then
select MINMAX_ITERATORS#MMI_CODE.nextval into :NEW."MMI_CODE" from dual;
end if;
end if;
end;
/
ALTER TRIGGER "HUNDISILM"."MINMAX_ITERATORS#CODE" ENABLE;
