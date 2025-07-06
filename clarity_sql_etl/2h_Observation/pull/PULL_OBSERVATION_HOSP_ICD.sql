/*******************************************************************************
* Script Name: PULL_OBSERVATION_HOSP_ICD
* Description: Pulls hospital observation data with ICD codes
* 
* Tables Used:
*     - CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC_DX
*     - CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_HSP
*     - CARE_BRONZE_CLARITY_PROD.DBO.HSP_ATND_PROV
*     - CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_DIAGNOSIS_OBSERVATION
*******************************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    PULL_VISIT_OCCURRENCE_HSP.PERSON_ID                     AS PERSON_ID,
    PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATE             AS OBSERVATION_DATE,
    PULL_VISIT_OCCURRENCE_HSP.VISIT_START_DATETIME         AS OBSERVATION_DATETIME,
    NULL                                                    AS VALUE_AS_NUMBER,
    PULL_PROVIDER_SOURCE_VALUE                             AS PROVIDER_SOURCE_VALUE,
    NULL                                                    AS UNIT_SOURCE_VALUE,
    NULL                                                    AS QUALIFIER_SOURCE_VALUE,
    NULL                                                    AS VALUE_SOURCE_VALUE,

    -- Additional Fields for Stage
    PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID                  AS PULL_CSN_ID,
    T_DIAGNOSIS_OBSERVATION.ICD10_CODE                      AS PULL_ICD10_CODE,
    T_DIAGNOSIS_OBSERVATION.ICD9_CODE                       AS PULL_ICD9_CODE,
    T_DIAGNOSIS_OBSERVATION.DX_ID                          AS PULL_DX_ID

FROM CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC_DX AS PAT_ENC_DX

    -- Join to get visit occurrence information
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_HSP AS PULL_VISIT_OCCURRENCE_HSP
        ON PAT_ENC_DX.PAT_ENC_CSN_ID = PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID

    -- Join to get attending provider information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.HSP_ATND_PROV AS HSP_ATND_PROV
        ON PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = HSP_ATND_PROV.PAT_ENC_CSN_ID
        AND VISIT_END_DATETIME BETWEEN ATTEND_FROM_DATE
            AND COALESCE(ATTEND_TO_DATE, GETDATE())

    -- Join to get diagnosis observation information
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_DIAGNOSIS_OBSERVATION AS T_DIAGNOSIS_OBSERVATION
        ON PAT_ENC_DX.DX_ID = T_DIAGNOSIS_OBSERVATION.DX_ID;