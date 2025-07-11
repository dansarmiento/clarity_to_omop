/*******************************************************************************
* Script Name: PULL_CONDITION_OCCURRENCE_HOSP_ADM_SNO
* Description: Retrieves condition occurrence data for hospital admissions with
*              SNOMED codes
* 
* Tables Used:
*   - CARE_BRONZE_CLARITY_PROD.DBO.HSP_ACCT_ADMIT_DX
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_HSP
*   - CARE_BRONZE_CLARITY_PROD.DBO.HSP_ATND_PROV
*   - CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_SNO_CODE
*******************************************************************************/

SELECT DISTINCT
    -- Stage Attributes
    PULL_VISIT_OCCURRENCE_HSP.PERSON_ID               AS PERSON_ID,
    PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATE        AS CONDITION_START_DATE,
    PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATETIME    AS CONDITION_START_DATETIME,
    PULL_VISIT_OCCURRENCE_HSP.VISIT_END_DATE          AS CONDITION_END_DATE,
    PULL_VISIT_OCCURRENCE_HSP.VISIT_END_DATETIME      AS CONDITION_END_DATETIME,
    CASE 
        WHEN PULL_DISCHARGE_SOURCE_CODE = 20 THEN 'EXPIRED'
        ELSE 'DISCHARGED'
    END                                               AS STOP_REASON,
    'ADMISSION_DX'                                    AS CONDITION_STATUS_SOURCE_VALUE,
    PULL_PROVIDER_SOURCE_VALUE                        AS PROVIDER_SOURCE_VALUE,

    -- Additional Attributes (Non-OMOP fields)
    PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID             AS PULL_CSN_ID,
    PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATE        AS PULL_VISIT_DATE,
    T_SNO_CODE.DX_ID                                  AS PULL_DX_ID,
    T_SNO_CODE.DX_NAME                                AS PULL_DX_NAME,
    T_SNO_CODE.CURRENT_ICD9_LIST                      AS PULL_CURRENT_ICD9_LIST,
    T_SNO_CODE.CURRENT_ICD10_LIST                     AS PULL_CURRENT_ICD10_LIST,
    T_SNO_CODE.SNOMED_CODE                            AS PULL_SNOMED_CODE

FROM CARE_BRONZE_CLARITY_PROD.DBO.HSP_ACCT_ADMIT_DX AS HSP_ACCT_ADMIT_DX

    -- Join to get visit occurrence information
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_HSP AS PULL_VISIT_OCCURRENCE_HSP
        ON HSP_ACCT_ADMIT_DX.HSP_ACCOUNT_ID = PULL_VISIT_OCCURRENCE_HSP.PULL_HSP_ACCOUNT_ID

    -- Join to get attending provider information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.HSP_ATND_PROV AS HSP_ATND_PROV
        ON PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = HSP_ATND_PROV.PAT_ENC_CSN_ID
        AND VISIT_START_DATETIME BETWEEN ATTEND_FROM_DATE
            AND COALESCE(ATTEND_TO_DATE, GETDATE())

    -- Join to get SNOMED code information
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_SNO_CODE AS T_SNO_CODE
        ON HSP_ACCT_ADMIT_DX.ADMIT_DX_ID = T_SNO_CODE.DX_ID;