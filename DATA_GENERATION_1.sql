--------------------------------------------------------
--  DDL for Package Body DATA_GENERATION
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "HUNDISILM"."DATA_GENERATION" is

PROCEDURE GENERATE_APPLICATION_DATA(par_number in pls_integer := 0) IS

ln_i  pls_integer:=0;
lr_data b_applications%rowtype;
ln_education_choice pls_integer := 0;
lc_education varchar2(100);

BEGIN
  -- Clear the current data_table
  DELETE FROM b_applications;
  -- Generate new data
  while (ln_i < par_number)
  loop
    ln_education_choice := dbms_random.VALUE(0,3);
    lc_education := CASE ln_education_choice 
                      WHEN 0 THEN 'No education'
                      WHEN 1 THEN 'Primary education'
                      WHEN 2 THEN 'Secondary education'
                      WHEN 3 THEN 'Higher education'
                    END;
    
    -- Initiate record to be inserted                    
    lr_data.apl_code            := ln_i+1;
    lr_data.apl_name            := 'Jane Doe ' || to_Char(ln_i+1);
    lr_data.apl_income          := round(dbms_random.VALUE(100,4000),2);
    lr_data.apl_obligations     := round(dbms_random.VALUE(0,lr_data.apl_income),2); --Avoid generating larger than income values
    lr_data.apl_reserve         := lr_data.apl_income - lr_data.apl_obligations;
    lr_data.apl_debt_to_income  := round(lr_data.apl_obligations/lr_data.apl_income,2);
    lr_data.apl_age             := floor(dbms_random.VALUE(15,100));
    lr_data.apl_education       := lc_education;
    lr_data.apl_rejected        := 0;
    lr_data.apl_in_default      := dbms_random.VALUE(0,1);
    lr_data.apl_amount          := round(dbms_random.value(1000,15000),2);
    
    -- insert data into the b_application_data table
    P_APPLICATIONS.APPLICATION_DATA_INSERT(lr_data);
    -- increment loop iterator
    ln_i:=ln_i+1;
  END loop;
  
END GENERATE_APPLICATION_DATA;

end DATA_GENERATION;

/
