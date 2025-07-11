-------------------------------
--PULL_VISIT_DETAIL_HOSP_ALL
-------------------------------
{{ config(materialized='table', schema = 'OMOP_PULL',
        cluster_by = ['PAT_ENC_CSN_ID']) }}

SELECT DISTINCT 
-- ***STAGE ATTRIBUTES***
-- fields used for the Stage
    PATIENT_DRIVER.PERSON_ID::NUMBER(28,0)                                                                                      AS PERSON_ID
    , CAST(COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, PAT_ENC.CHECKIN_TIME, PAT_ENC.APPT_TIME, PAT_ENC_HSP.CONTACT_DATE) AS DATE)   AS VISIT_DETAIL_START_DATE
    , COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, PAT_ENC.CHECKIN_TIME, PAT_ENC.APPT_TIME, PAT_ENC_HSP.CONTACT_DATE)                 AS VISIT_DETAIL_START_DATETIME
    , CASE
        WHEN COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, PAT_ENC_HSP.HOSP_DISCH_TIME, PAT_ENC.CHECKOUT_TIME) IS NOT NULL
            AND COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, PAT_ENC_HSP.HOSP_DISCH_TIME, PAT_ENC.CHECKOUT_TIME) >= COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, PAT_ENC.CHECKIN_TIME, PAT_ENC.APPT_TIME, PAT_ENC_HSP.CONTACT_DATE)
            THEN CAST(COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, PAT_ENC_HSP.HOSP_DISCH_TIME, PAT_ENC.CHECKOUT_TIME) AS DATE)
        WHEN COALESCE(PAT_ENC_HSP.HOSP_DISCH_TIME, PAT_ENC.CHECKOUT_TIME) >= COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, PAT_ENC.CHECKIN_TIME, PAT_ENC.APPT_TIME, PAT_ENC_HSP.CONTACT_DATE)
            THEN CAST(COALESCE(PAT_ENC_HSP.HOSP_DISCH_TIME, PAT_ENC.CHECKOUT_TIME) AS DATE)
        ELSE NULL
        END                                                                                                                     AS VISIT_DETAIL_END_DATE
    , CASE
        WHEN COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, PAT_ENC_HSP.HOSP_DISCH_TIME, PAT_ENC.CHECKOUT_TIME) IS NOT NULL
            AND COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, PAT_ENC_HSP.HOSP_DISCH_TIME, PAT_ENC.CHECKOUT_TIME) >= COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, PAT_ENC.CHECKIN_TIME, PAT_ENC.APPT_TIME, PAT_ENC_HSP.CONTACT_DATE)
            THEN CAST(COALESCE(CLARITY_ADT_B.EFFECTIVE_TIME, PAT_ENC_HSP.HOSP_DISCH_TIME, PAT_ENC.CHECKOUT_TIME) AS DATETIME)
        WHEN COALESCE(PAT_ENC_HSP.HOSP_DISCH_TIME, PAT_ENC.CHECKOUT_TIME) >= COALESCE(CLARITY_ADT_A.EFFECTIVE_TIME, PAT_ENC.CHECKIN_TIME, PAT_ENC.APPT_TIME, PAT_ENC_HSP.CONTACT_DATE)
            THEN CAST(COALESCE(PAT_ENC_HSP.HOSP_DISCH_TIME, PAT_ENC.CHECKOUT_TIME) AS DATETIME)
        ELSE NULL
        END                                                                                                                     AS VISIT_DETAIL_END_DATETIME
    , LEFT(ZC_ADM_SOURCE_NAME, 50)                                                                                              AS ADMITTED_FROM_SOURCE_VALUE
    , LEFT(ZC_DISCH_DISP_NAME, 50)                                                                                              AS DISCHARGED_TO_SOURCE_VALUE
    , RANK() OVER (
        PARTITION BY PAT_ENC_HSP.PAT_ENC_CSN_ID ORDER BY CLARITY_ADT_A.SEQ_NUM_IN_ENC
            , CLARITY_ADT_A.EFFECTIVE_TIME
        )                                                           AS VISIT_DETAIL_RANK
    , ROW_NUMBER() OVER (
        ORDER BY PAT_ENC_HSP.PAT_ENC_CSN_ID
            , CLARITY_ADT_A.SEQ_NUM_IN_ENC
            , CLARITY_ADT_A.EFFECTIVE_TIME
        )                                                           AS VISIT_DETAIL_ID


	, PATIENT_DRIVER.EHR_PATIENT_ID
    , PAT_ENC_HSP.PAT_ID
    , PAT_ENC_HSP.PAT_ENC_CSN_ID
    
    , PAT_ENC_HSP.HOSP_ADMSN_TYPE_C
    , CLARITY_ADT_A.PAT_SERVICE_C
    , PAT_ENC_HSP.ADT_PAT_CLASS_C
    , ZC_PAT_CLASS_NAME                                             AS VISIT_SOURCE_VALUE
    , CLARITY_ADT_A.PAT_LVL_OF_CARE_C --used for VISIT_DETAIL_SOURCE_VALUE WHEN ICU

    --used for VISIT_DETAIL_SOURCE_CONCEPT
    , CASE
        WHEN CLARITY_ADT_A.PAT_LVL_OF_CARE_C = 6
            THEN 9999 -- ICU
        ELSE PAT_ENC_HSP.ADT_PAT_CLASS_C
        END                                                         AS VISIT_DETAIL_SOURCE_CONCEPT --used for VISIT_DETAIL_SOURCE_CONCEPT_ID WHEN ICU

    --used for VISIT_DETAIL_SOURCE_VALUE
    , CASE
        WHEN CLARITY_PRC.PRC_NAME IS NOT NULL
            THEN CAST(CLARITY_DEP.DEPARTMENT_NAME || '_' || CLARITY_PRC.PRC_NAME AS VARCHAR)
        WHEN CLARITY_ADT_A.ROOM_ID IS NOT NULL
            AND ZC_PAT_SERVICE_NAME IS NOT NULL
            THEN CLARITY_DEP.DEPARTMENT_NAME || '_' || CLARITY_ADT_A.ROOM_ID || '_' || CLARITY_ADT_A.BED_ID || '_' || ZC_PAT_SERVICE_NAME
        ELSE CAST(CLARITY_DEP.DEPARTMENT_NAME AS VARCHAR)
        END                                                         AS VISIT_DETAIL_SOURCE_VALUE

-- ***PULL attributes***
-- field names pulled from the source for verification purposes. May be duplicated above.
    ,PATIENT_DRIVER.EHR_PATIENT_ID                      		AS PULL_PAT_ID
    ,PATIENT_DRIVER.MRN_CPI                            			AS PULL_MRN_CPI
	,PAT_ENC_HSP.PAT_ENC_CSN_ID									AS PULL_CSN_ID
    ,PAT_ENC_HSP.HOSPITAL_AREA_ID                                   AS PULL_VISIT_DETAIL_CARE_SITE_ID
    ,HSP_ACCOUNT.ATTENDING_PROV_ID                                  AS PULL_VISIT_DETAIL_PROVIDER_ID
    ,PAT_ENC_HSP.ADMIT_SOURCE_C                                     AS PULL_ADMIT_SOURCE_CODE
    ,PAT_ENC_HSP.DISCH_DISP_C                                       AS PULL_DISCH_DISP_CODE

-- ***PULL attributes***
-- field names pulled from the source for verification purposes. May be duplicated above.
/* 
--ADMIT TIMES
    , PAT_ENC_HSP.HOSP_ADMSN_TIME
    , PAT_ENC_HSP.INP_ADM_DATE
    , PAT_ENC_HSP.EXP_ADMISSION_TIME
    , PAT_ENC_HSP.OP_ADM_DATE
    , PAT_ENC_HSP.EMER_ADM_DATE
    , PAT_ENC_HSP.INSTANT_OF_ENTRY_TM
    , CLARITY_ADT_A.EFFECTIVE_TIME                                  AS A_EFFECTIVE_TIME
    , PAT_ENC.CHECKIN_TIME
    , PAT_ENC.APPT_TIME
    , PAT_ENC_HSP.CONTACT_DATE
--DISCHARGE TIMES
    , PAT_ENC_HSP.HOSP_DISCH_TIME
    , PAT_ENC_HSP.ED_DISP_TIME
    , CLARITY_ADT_B.EFFECTIVE_TIME AS B_EFFECTIVE_TIME
    , PAT_ENC.CHECKOUT_TIME
    , PAT_ENC_HSP.HOSPITAL_AREA_ID
    , PAT_ENC_HSP.HSP_ACCOUNT_ID
    , PAT_ENC_HSP.INPATIENT_DATA_ID
    , PAT_ENC_HSP.IP_EPISODE_ID
    , PAT_ENC_HSP.ED_EPISODE_ID
    , PAT_ENC_HSP.ED_DISPOSITION_C
    , ZC_ED_DISPOSITION_NAME AS ED_DISPOSITION_NAME
    , PAT_ENC_HSP.ADMIT_SOURCE_C
    , ZC_ADM_SOURCE_NAME AS ADMIT_SOURCE_NAME
    , PAT_ENC_HSP.DISCH_DISP_C
    , ZC_DISCH_DISP_NAME  AS DISCH_DISP_NAME
    , PAT_ENC_HSP.BILL_ATTEND_PROV_ID
    , PAT_ENC_HSP.ADT_PATIENT_STAT_C
    , ZC_PAT_STATUS_NAME AS ADT_PATIENT_STAT_NAME
    , HSP_ACCOUNT.ATTENDING_PROV_ID
    , HSP_ACCOUNT.REFERRING_PROV_ID
    , HSP_ACCOUNT.ADM_DATE_TIME
    , HSP_ACCOUNT.DISCH_DATE_TIME
    , CLARITY_DEP.DEPARTMENT_NAME
    , CLARITY_PRC.PRC_NAME
    , CLARITY_ADT_A.ROOM_ID
    , CLARITY_ADT_A.BED_ID
    , ZC_PAT_SERVICE_NAME AS HOSP_SERV_NAME */
    

FROM  {{ ref('PAT_ENC_HSP_stg')}} AS PAT_ENC_HSP

    INNER JOIN  {{ ref('PAT_ENC_stg')}} AS PAT_ENC
        ON PAT_ENC_HSP.PAT_ENC_CSN_ID = PAT_ENC.PAT_ENC_CSN_ID

    LEFT JOIN  {{ ref('CLARITY_ADT_stg')}} AS CLARITY_ADT_A
        ON PAT_ENC_HSP.PAT_ENC_CSN_ID = CLARITY_ADT_A.PAT_ENC_CSN_ID
            AND CLARITY_ADT_A.EVENT_TYPE_C NOT IN (4, 5, 6)
            AND CLARITY_ADT_A.SEQ_NUM_IN_ENC IS NOT NULL

    INNER JOIN  {{ ref('CLARITY_ADT_stg')}} AS CLARITY_ADT_B
        ON CLARITY_ADT_A.PAT_ID = CLARITY_ADT_B.PAT_ID
            AND CLARITY_ADT_A.PAT_ENC_CSN_ID = CLARITY_ADT_B.PAT_ENC_CSN_ID
            AND CLARITY_ADT_B.EVENT_TYPE_C IN (2, 4)
            AND CLARITY_ADT_B.EVENT_ID IN (CLARITY_ADT_A.NEXT_OUT_EVENT_ID)

    LEFT JOIN  {{ ref('ZC_PAT_CLASS_stg')}} AS ZC_PAT_CLASS
        ON pat_enc_hsp.ADT_PAT_CLASS_C = ZC_PAT_CLASS.ADT_PAT_CLASS_C

    LEFT JOIN  {{ ref('ZC_PAT_STATUS_stg')}} AS ZC_PAT_STATUS
        ON pat_enc_hsp.ADT_PATIENT_STAT_C = ZC_PAT_STATUS.ADT_PATIENT_STAT_C

    LEFT JOIN  {{ref('ZC_ADM_SOURCE_stg')}} AS ZC_ADM_SOURCE
        ON pat_enc_hsp.ADMIT_SOURCE_C = ZC_ADM_SOURCE.ADMIT_SOURCE_C

    LEFT JOIN  {{ ref('ZC_DISCH_DISP_stg')}} AS ZC_DISCH_DISP
        ON pat_enc_hsp.DISCH_DISP_C = ZC_DISCH_DISP.DISCH_DISP_C

    LEFT JOIN  {{ ref('ZC_ED_DISPOSITION_stg')}} AS ZC_ED_DISPOSITION
        ON pat_enc_hsp.ED_DISPOSITION_C = ZC_ED_DISPOSITION.ED_DISPOSITION_C

    LEFT JOIN  {{ ref('HSP_ACCOUNT_stg')}} AS HSP_ACCOUNT
        ON PAT_ENC_HSP.HSP_ACCOUNT_ID = HSP_ACCOUNT.HSP_ACCOUNT_ID

    LEFT JOIN  {{ ref('CLARITY_DEP_stg')}} AS CLARITY_DEP
        ON PAT_ENC_HSP.DEPARTMENT_ID = CLARITY_DEP.DEPARTMENT_ID

    -- add when CLARITY_PRC available
    LEFT JOIN  {{ ref('CLARITY_PRC_stg')}} AS CLARITY_PRC
        ON CLARITY_PRC.PRC_ID = PAT_ENC.APPT_PRC_ID

    LEFT JOIN  {{ ref('ZC_PAT_SERVICE_stg')}} AS ZC_PAT_SERVICE
        ON CLARITY_ADT_A.PAT_SERVICE_C = ZC_PAT_SERVICE.HOSP_SERV_C

-- AOU list of participants
    INNER JOIN   {{ref('PATIENT_DRIVER')}} AS PATIENT_DRIVER
        ON PAT_ENC_HSP.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID

WHERE HOSP_DISCH_TIME IS NOT NULL
