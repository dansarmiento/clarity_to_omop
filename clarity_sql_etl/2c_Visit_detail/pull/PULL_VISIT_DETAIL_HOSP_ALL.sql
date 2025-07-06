/*******************************************************************************
* Script Name: PULL_VISIT_DETAIL_HOSP_ALL
* Description: Retrieves detailed hospital visit information for patients
* 
* This query combines multiple tables to create a comprehensive view of hospital
* visits, including admission/discharge times, patient locations, and various
* administrative details.
*******************************************************************************/

SELECT DISTINCT 
    -- Stage Attributes
    PATIENT_DRIVER.PERSON_ID::NUMBER(28,0)                         AS PERSON_ID,
    CAST(COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, 
                  PAT_ENC.CHECKIN_TIME, 
                  PAT_ENC.APPT_TIME, 
                  PAT_ENC_HSP.CONTACT_DATE) AS DATE)              AS VISIT_DETAIL_START_DATE,
    COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, 
             PAT_ENC.CHECKIN_TIME, 
             PAT_ENC.APPT_TIME, 
             PAT_ENC_HSP.CONTACT_DATE)                            AS VISIT_DETAIL_START_DATETIME,
    
    -- Visit End Date Logic
    CASE
        WHEN COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, 
                      PAT_ENC_HSP.HOSP_DISCH_TIME, 
                      PAT_ENC.CHECKOUT_TIME) IS NOT NULL
             AND COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, 
                         PAT_ENC_HSP.HOSP_DISCH_TIME, 
                         PAT_ENC.CHECKOUT_TIME) >= 
                 COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, 
                         PAT_ENC.CHECKIN_TIME, 
                         PAT_ENC.APPT_TIME, 
                         PAT_ENC_HSP.CONTACT_DATE)
            THEN CAST(COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, 
                              PAT_ENC_HSP.HOSP_DISCH_TIME, 
                              PAT_ENC.CHECKOUT_TIME) AS DATE)
        WHEN COALESCE(PAT_ENC_HSP.HOSP_DISCH_TIME, 
                      PAT_ENC.CHECKOUT_TIME) >= 
             COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, 
                      PAT_ENC.CHECKIN_TIME, 
                      PAT_ENC.APPT_TIME, 
                      PAT_ENC_HSP.CONTACT_DATE)
            THEN CAST(COALESCE(PAT_ENC_HSP.HOSP_DISCH_TIME, 
                              PAT_ENC.CHECKOUT_TIME) AS DATE)
        ELSE NULL
    END                                                           AS VISIT_DETAIL_END_DATE,
    
    -- Visit End Datetime Logic
    CASE
        WHEN COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, 
                      PAT_ENC_HSP.HOSP_DISCH_TIME, 
                      PAT_ENC.CHECKOUT_TIME) IS NOT NULL
             AND COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, 
                         PAT_ENC_HSP.HOSP_DISCH_TIME, 
                         PAT_ENC.CHECKOUT_TIME) >= 
                 COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, 
                         PAT_ENC.CHECKIN_TIME, 
                         PAT_ENC.APPT_TIME, 
                         PAT_ENC_HSP.CONTACT_DATE)
            THEN CAST(COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, 
                              PAT_ENC_HSP.HOSP_DISCH_TIME, 
                              PAT_ENC.CHECKOUT_TIME) AS DATETIME)
        WHEN COALESCE(PAT_ENC_HSP.HOSP_DISCH_TIME, 
                      PAT_ENC.CHECKOUT_TIME) >= 
             COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, 
                      PAT_ENC.CHECKIN_TIME, 
                      PAT_ENC.APPT_TIME, 
                      PAT_ENC_HSP.CONTACT_DATE)
            THEN CAST(COALESCE(PAT_ENC_HSP.HOSP_DISCH_TIME, 
                              PAT_ENC.CHECKOUT_TIME) AS DATETIME)
        ELSE NULL
    END                                                           AS VISIT_DETAIL_END_DATETIME,
    
    -- Additional Visit Details
    LEFT(ZC_ADM_SOURCE.NAME, 50)                                  AS ADMITTED_FROM_SOURCE_VALUE,
    LEFT(ZC_DISCH_DISP.NAME, 50)                                 AS DISCHARGED_TO_SOURCE_VALUE,
    
    -- Visit Rankings
    RANK() OVER (
        PARTITION BY PAT_ENC_HSP.PAT_ENC_CSN_ID 
        ORDER BY CLARITY_ADT_A.SEQ_NUM_IN_ENC,
                 CLARITY_ADT_A.EFFECTIVE_TIME
    )                                                            AS VISIT_DETAIL_RANK,
    
    ROW_NUMBER() OVER (
        ORDER BY PAT_ENC_HSP.PAT_ENC_CSN_ID,
                 CLARITY_ADT_A.SEQ_NUM_IN_ENC,
                 CLARITY_ADT_A.EFFECTIVE_TIME
    )                                                            AS VISIT_DETAIL_ID,

    -- Patient Identifiers
    PATIENT_DRIVER.EHR_PATIENT_ID,
    PAT_ENC_HSP.PAT_ID,
    PAT_ENC_HSP.PAT_ENC_CSN_ID,
    
    -- Visit Classification Fields
    PAT_ENC_HSP.HOSP_ADMSN_TYPE_C,
    CLARITY_ADT_A.PAT_SERVICE_C,
    PAT_ENC_HSP.ADT_PAT_CLASS_C,
    ZC_PAT_CLASS.NAME                                            AS VISIT_SOURCE_VALUE,
    CLARITY_ADT_A.PAT_LVL_OF_CARE_C,

    -- Visit Detail Source Concept
    CASE
        WHEN CLARITY_ADT_A.PAT_LVL_OF_CARE_C = 6 THEN 9999  -- ICU
        ELSE PAT_ENC_HSP.ADT_PAT_CLASS_C
    END                                                         AS VISIT_DETAIL_SOURCE_CONCEPT,

    -- Visit Detail Source Value
    CASE
        WHEN CLARITY_PRC.PRC_NAME IS NOT NULL
            THEN CAST(CLARITY_DEP.DEPARTMENT_NAME || '_' || 
                     CLARITY_PRC.PRC_NAME AS VARCHAR)
        WHEN CLARITY_ADT_A.ROOM_ID IS NOT NULL
             AND ZC_PAT_SERVICE.NAME IS NOT NULL
            THEN CLARITY_DEP.DEPARTMENT_NAME || '_' || 
                 CLARITY_ADT_A.ROOM_ID || '_' || 
                 CLARITY_ADT_A.BED_ID || '_' || 
                 ZC_PAT_SERVICE.NAME
        ELSE CAST(CLARITY_DEP.DEPARTMENT_NAME AS VARCHAR)
    END                                                         AS VISIT_DETAIL_SOURCE_VALUE,

    -- Pull Attributes for Verification
    PATIENT_DRIVER.EHR_PATIENT_ID                              AS PULL_PAT_ID,
    PATIENT_DRIVER.MRN_CPI                                     AS PULL_MRN_CPI,
    PAT_ENC_HSP.PAT_ENC_CSN_ID                                AS PULL_CSN_ID,
    PAT_ENC_HSP.HOSPITAL_AREA_ID                              AS PULL_VISIT_DETAIL_CARE_SITE_ID,
    HSP_ACCOUNT.ATTENDING_PROV_ID                             AS PULL_VISIT_DETAIL_PROVIDER_ID,
    PAT_ENC_HSP.ADMIT_SOURCE_C                                AS PULL_ADMIT_SOURCE_CODE,
    PAT_ENC_HSP.DISCH_DISP_C                                 AS PULL_DISCH_DISP_CODE

FROM CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC_HSP AS PAT_ENC_HSP

    -- Join Conditions
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC AS PAT_ENC
        ON PAT_ENC_HSP.PAT_ENC_CSN_ID = PAT_ENC.PAT_ENC_CSN_ID

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_ADT AS CLARITY_ADT_A
        ON PAT_ENC_HSP.PAT_ENC_CSN_ID = CLARITY_ADT_A.PAT_ENC_CSN_ID
        AND CLARITY_ADT_A.EVENT_TYPE_C NOT IN (4, 5, 6)
        AND CLARITY_ADT_A.SEQ_NUM_IN_ENC IS NOT NULL

    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_ADT AS CLARITY_ADT_B
        ON CLARITY_ADT_A.PAT_ID = CLARITY_ADT_B.PAT_ID
        AND CLARITY_ADT_A.PAT_ENC_CSN_ID = CLARITY_ADT_B.PAT_ENC_CSN_ID
        AND CLARITY_ADT_B.EVENT_TYPE_C IN (2, 4)
        AND CLARITY_ADT_B.EVENT_ID IN (CLARITY_ADT_A.NEXT_OUT_EVENT_ID)

    -- Additional Lookup Tables
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

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_DEP AS CLARITY_DEP
        ON PAT_ENC_HSP.DEPARTMENT_ID = CLARITY_DEP.DEPARTMENT_ID

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_PRC AS CLARITY_PRC
        ON CLARITY_PRC.PRC_ID = PAT_ENC.APPT_PRC_ID

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_PAT_SERVICE AS ZC_PAT_SERVICE
        ON CLARITY_ADT_A.PAT_SERVICE_C = ZC_PAT_SERVICE.HOSP_SERV_C

    -- Join to AOU Participant List
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS PATIENT_DRIVER
        ON PAT_ENC_HSP.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID

WHERE HOSP_DISCH_TIME IS NOT NULL;