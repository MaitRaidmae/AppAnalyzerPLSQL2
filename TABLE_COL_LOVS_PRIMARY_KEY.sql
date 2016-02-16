--------------------------------------------------------
--  DDL for Trigger TABLE_COL_LOVS#PRIMARY_KEY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HUNDISILM"."TABLE_COL_LOVS#PRIMARY_KEY" 
   before insert on "HUNDISILM"."B_TABLE_COL_LOVS" 
   for each row 
begin  
   if inserting then 
      if :NEW."TCL_CODE" is null then 
         select TABLE_COL_LOVS#TCL_CODE.nextval into :NEW."TCL_CODE" from dual; 
      end if; 
   end if; 
end;

/
ALTER TRIGGER "HUNDISILM"."TABLE_COL_LOVS#PRIMARY_KEY" ENABLE;
