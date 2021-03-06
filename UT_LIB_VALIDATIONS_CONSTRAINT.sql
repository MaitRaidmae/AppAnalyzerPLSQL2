--------------------------------------------------------
--  Constraints for Table UT_LIB_VALIDATIONS
--------------------------------------------------------

  ALTER TABLE "HUNDISILM"."UT_LIB_VALIDATIONS" MODIFY ("LIB_VALIDATION_ID" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LIB_VALIDATIONS" MODIFY ("LIB_VALIDATION_NAME" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LIB_VALIDATIONS" MODIFY ("LIB_VALIDATION_CLASS" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LIB_VALIDATIONS" MODIFY ("LIB_VALIDATION" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LIB_VALIDATIONS" MODIFY ("CREATED_ON" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LIB_VALIDATIONS" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LIB_VALIDATIONS" MODIFY ("UPDATED_ON" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LIB_VALIDATIONS" MODIFY ("UPDATED_BY" NOT NULL ENABLE);
  ALTER TABLE "HUNDISILM"."UT_LIB_VALIDATIONS" ADD CONSTRAINT "UT_LIB_VALIDATIONS_PK" PRIMARY KEY ("LIB_VALIDATION_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "USERS"  ENABLE;
  ALTER TABLE "HUNDISILM"."UT_LIB_VALIDATIONS" ADD CONSTRAINT "UT_LIB_VALIDATIONS_NAME" UNIQUE ("LIB_VALIDATION_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "USERS"  ENABLE;
