--------------------------------------------------------
--  DDL for View V_APP_CHECKS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "HUNDISILM"."V_APP_CHECKS" ("ACK_APL_CODE", "CHK_MNEMO", "CHK_RESULT") AS 
  select ack_apl_code,
(select chk_mnemo from b_checks where ack_chk_code = chk_code) as chk_mnemo,
(SELECT CASE ack_value WHEN 0 THEN 'Passed' WHEN 1 THEN 'Failed' END FROM dual) AS chk_result
from b_app_checks;
