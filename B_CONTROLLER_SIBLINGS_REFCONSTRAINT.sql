--------------------------------------------------------
--  Ref Constraints for Table B_CONTROLLER_SIBLINGS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."B_CONTROLLER_SIBLINGS" ADD CONSTRAINT "B_CONTROLLER_SIBLINGS_FK1" FOREIGN KEY ("COS_ACO_CODE")
	  REFERENCES "HUNDISILM"."B_APP_CONTROLLERS" ("ACO_CODE") ON DELETE CASCADE ENABLE;
