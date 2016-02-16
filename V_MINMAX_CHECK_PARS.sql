--------------------------------------------------------
--  DDL for View V_MINMAX_CHECK_PARS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."V_MINMAX_CHECK_PARS" ("CHK_CODE", "Threshold Value", "Checked Field") AS 
  select mcp_chk_code as chk_code, mcp_threshold as "Threshold Value", mcp_check_field as "Checked Field" from b_minmax_check_pars;
