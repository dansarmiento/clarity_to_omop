/*******************************************************************************
* Script Name: PULL_VISIT_OCCURRENCE_HSP
* Description: Retrieves hospital visit occurrence data with associated patient,
*              provider, and facility information.
* 
* Tables Used:
*   - PAT_ENC_HSP - Hospital encounter data
*   - ZC_PAT_CLASS - Patient class lookup
*   - ZC_PAT_STATUS - Patient status lookup
*   - ZC_ADM_SOURCE - Admission source lookup
*   - ZC_DISCH_DISP - Discharge disposition lookup
*   - ZC_ED_DISPOSITION - Emergency department disposition lookup
*   - HSP_ACCOUNT - Hospital account information
*   - PATIENT_DRIVER - Patient demographic information
*******************************************************************************/

SELECT DISTINCT
    -- Stage Attributes
    PATIENT_DRIVER.PERSON_ID::NUMBER(28,0)                     AS PERSON_ID,
    CAST(PAT_ENC_HSP.HOSP_ADMSN_TIME AS DATE)                  AS VISIT_START_DATE,
    PAT_ENC_HSP.HOSP_ADMSN_TIME                                AS VISIT_START_DATETIME,
    CAST(PAT_ENC_HSP.HOSP_DISCH_TIME AS DATE)                  AS VISIT_END_DATE,
    PAT_ENC_HSP.HOSP_DISCH_TIME                                AS VISIT_END_DATETIME,
    ZC_PAT_CLASS.NAME                                          AS VISIT_SOURCE_VALUE,
    CAST(PAT_ENC_HSP.ADMIT_SOURCE_C AS VARCHAR(10)) || ':' || 
        LEFT(ZC_ADM_SOURCE.NAME, 45)                           AS ADMITTED_FROM_SOURCE_VALUE,
    CAST(PAT_ENC_HSP.DISCH_DISP_C AS VARCHAR(10)) || ':' || 
        LEFT(ZC_DISCH_DISP.NAME, 45)                           AS DISCHARGED_TO_SOURCE_VALUE,

    -- Additional Attributes
    COALESCE(HSP_ACCOUNT.ATTENDING_PROV_ID, 
             HSP_ACCOUNT.REFERRING_PROV_ID)                    AS PULL_PROVIDER_SOURCE_VALUE,
    PAT_ENC_HSP.HOSPITAL_AREA_ID                               AS PULL_CARE_SITE_ID,
    PAT_ENC_HSP.ADT_PAT_CLASS_C                                AS PULL_VISIT_SOURCE_CODE,
    PAT_ENC_HSP.ADMIT_SOURCE_C                                 AS PULL_ADMIT_SOURCE_CODE,
    PAT_ENC_HSP.DISCH_DISP_C                                   AS PULL_DISCHARGE_SOURCE_CODE,
    PAT_ENC_HSP.HSP_ACCOUNT_ID                                 AS PULL_HSP_ACCOUNT_ID,

    -- Pull Attributes
    PATIENT_DRIVER.EHR_PATIENT_ID                              AS PULL_PAT_ID,
    PATIENT_DRIVER.MRN_CPI                                     AS PULL_MRN_CPI,
    PAT_ENC_HSP.PAT_ENC_CSN_ID                                 AS PULL_CSN_ID

FROM CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC_HSP AS PAT_ENC_HSP
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_PAT_CLASS AS ZC_PAT_CLASS
        ON PAT_ENC_HSP.ADT_PAT_CLASS_C = ZC_PAT_CLASS.ADT_PAT_CLASS_C
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_PAT_STATUS AS ZC_PAT_STATUS
        ON PAT_ENC_HSP.ADT_PATIENT_STAT_C = ZC_PAT_STATUS.ADT_PATIENT_STAT_C
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_ADM_SOURCE AS ZC_ADM_SOURCE
        ON PAT_ENC_HSP.ADMIT_SOURCE_C = ZC_ADM_SOURCE.ADMIT_SOURCE_C
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_DISCH_DISP AS ZC_DISCH_DISP
        ON PAT_ENC_HSP.DISCH_DISP_C = ZC_DISCH_DISP.DISCH_DISP_C
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_ED_DISPOSITION AS ZC_ED_DISPOSITION
        ON PAT_ENC_HSP.ED_DISPOSITION_C = ZC_ED_DISPOSITION.ED_DISPOSITION_C
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.HSP_ACCOUNT AS HSP_ACCOUNT
        ON PAT_ENC_HSP.HSP_ACCOUNT_ID = HSP_ACCOUNT.HSP_ACCOUNT_ID
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS PATIENT_DRIVER
        ON PAT_ENC_HSP.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID

WHERE HOSP_DISCH_TIME IS NOT NULL;