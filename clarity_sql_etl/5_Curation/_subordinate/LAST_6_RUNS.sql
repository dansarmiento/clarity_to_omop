--LAST_6_RUNS


SELECT distinct TOP 6 RUN_DATE from CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_LOG_HISTORY ORDER BY RUN_DATE DESC