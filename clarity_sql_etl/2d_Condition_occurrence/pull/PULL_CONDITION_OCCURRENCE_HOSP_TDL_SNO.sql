/*******************************************************************************
* Script Name: PULL_CONDITION_OCCURRENCE_HOSP_TDL_SNO
* Description: Retrieves condition occurrence data for hospital visits with 
*              SNOMED codes and related diagnostic information
* 
* Tables Used:
* - T_TDL_DX
* - PULL_VISIT_OCCURRENCE_HSP
* - HSP_ATND_PROV
* - T_SNO_CODE
*******************************************************************************/

SELECT DISTINCT
    -- Stage Attributes
    -- Fields used for the Stage
    PULL_VISIT_OCCURRENCE_HSP.PERSON_ID                            AS PERSON_ID,
    T_TDL_DX.START_DATE::DATE                                      AS CONDITION_START_DATE,
    T_TDL_DX.START_DATE                                            AS CONDITION_START_DATETIME,
    T_TDL_DX.END_DATE::DATE                                        AS CONDITION_END_DATE,
    T_TDL_DX.END_DATE                                              AS CONDITION_END_DATETIME,
    CASE 
        WHEN PULL_DISCHARGE_SOURCE_CODE = 20 THEN 'EXPIRED'
        ELSE 'DISCHARGED'
    END                                                            AS STOP_REASON,
    CASE 
        WHEN T_TDL_DX.P_DX = 'Y' THEN 'PRIMARY_DX'
        ELSE 'SECONDARY_DX'
    END                                                            AS CONDITION_STATUS_SOURCE_VALUE,
    PULL_VISIT_OCCURRENCE_HSP.PULL_PROVIDER_SOURCE_VALUE           AS PROVIDER_SOURCE_VALUE,

    -- Additional Attributes
    -- Non-OMOP fields used for the Stage
    PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID                          AS PULL_CSN_ID,
    PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATE                     AS PULL_VISIT_DATE,
    T_SNO_CODE.DX_ID                                               AS PULL_DX_ID,
    T_SNO_CODE.DX_NAME                                             AS PULL_DX_NAME,
    T_SNO_CODE.CURRENT_ICD9_LIST                                   AS PULL_CURRENT_ICD9_LIST,
    T_SNO_CODE.CURRENT_ICD10_LIST                                  AS PULL_CURRENT_ICD10_LIST,
    T_SNO_CODE.SNOMED_CODE                                         AS PULL_SNOMED_CODE

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_TDL_DX AS T_TDL_DX

-- Join to get visit occurrence information
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_HSP AS PULL_VISIT_OCCURRENCE_HSP
    ON T_TDL_DX.PAT_ENC_CSN_ID = PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID

-- Join to get attending provider information
LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.HSP_ATND_PROV AS HSP_ATND_PROV
    ON PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = HSP_ATND_PROV.PAT_ENC_CSN_ID
    AND VISIT_START_DATETIME BETWEEN ATTEND_FROM_DATE 
        AND COALESCE(ATTEND_TO_DATE, GETDATE())

-- Join to get SNOMED codes and diagnostic information
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_SNO_CODE AS T_SNO_CODE
    ON T_TDL_DX.DX_ID = T_SNO_CODE.DX_ID;