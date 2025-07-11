/*******************************************************************************
* Script Name: PULL_CONDITION_OCCURRENCE_HOSP_DISCH_SNO
* Description: Retrieves condition occurrence data for hospital discharges with
*              SNOMED codes
* 
* Tables Used:
*   - CARE_BRONZE_CLARITY_PROD.DBO.HSP_ACCT_DX_LIST
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
    
    -- Determine stop reason based on discharge code
    CASE 
        WHEN PULL_DISCHARGE_SOURCE_CODE = 20 THEN 'EXPIRED'
        ELSE 'DISCHARGED'
    END                                               AS STOP_REASON,
    
    -- Determine condition status
    CASE 
        WHEN HSP_ACCT_DX_LIST.LINE = 1 THEN 'PRIMARY_DISCHARGE_DX'
        WHEN HSP_ACCT_DX_LIST.FINAL_DX_SOI_C IN (3, 4) THEN 'SECONDARY_DISCHARGE_DX'
        ELSE 'DISCHARGE_DX'
    END                                              AS CONDITION_STATUS_SOURCE_VALUE,
    
    PULL_PROVIDER_SOURCE_VALUE                       AS PROVIDER_SOURCE_VALUE,

    -- Additional Attributes (Non-OMOP fields)
    PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID            AS PULL_CSN_ID,
    PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATE       AS PULL_VISIT_DATE,
    T_SNO_CODE.DX_ID                                 AS PULL_DX_ID,
    T_SNO_CODE.DX_NAME                               AS PULL_DX_NAME,
    T_SNO_CODE.CURRENT_ICD9_LIST                     AS PULL_CURRENT_ICD9_LIST,
    T_SNO_CODE.CURRENT_ICD10_LIST                    AS PULL_CURRENT_ICD10_LIST,
    T_SNO_CODE.SNOMED_CODE                           AS PULL_SNOMED_CODE

FROM CARE_BRONZE_CLARITY_PROD.DBO.HSP_ACCT_DX_LIST   AS HSP_ACCT_DX_LIST

    -- Join with visit occurrence data
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_HSP AS PULL_VISIT_OCCURRENCE_HSP
        ON HSP_ACCT_DX_LIST.HSP_ACCOUNT_ID = PULL_VISIT_OCCURRENCE_HSP.PULL_HSP_ACCOUNT_ID

    -- Join with attending provider data
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.HSP_ATND_PROV AS HSP_ATND_PROV
        ON PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = HSP_ATND_PROV.PAT_ENC_CSN_ID
        AND VISIT_START_DATETIME BETWEEN ATTEND_FROM_DATE
            AND COALESCE(ATTEND_TO_DATE, GETDATE())

    -- Join with SNOMED codes
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_SNO_CODE AS T_SNO_CODE
        ON HSP_ACCT_DX_LIST.DX_ID = T_SNO_CODE.DX_ID;