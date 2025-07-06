/***************************************************************
 * Query: PULL_OBSERVATION_AMB_ICD
 * Description: Retrieves ambulatory ICD observation data by joining
 * visit occurrence data with diagnosis information.
 ***************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    PULL_VISIT_OCCURRENCE_AMB.PERSON_ID             AS PERSON_ID,
    PULL_VISIT_OCCURRENCE_AMB.VISIT_START_DATE      AS OBSERVATION_DATE,
    PULL_VISIT_OCCURRENCE_AMB.VISIT_START_DATETIME  AS OBSERVATION_DATETIME,
    NULL                                            AS VALUE_AS_NUMBER,
    PULL_PROVIDER_SOURCE_VALUE                      AS PROVIDER_SOURCE_VALUE,
    NULL                                            AS UNIT_SOURCE_VALUE,
    NULL                                            AS QUALIFIER_SOURCE_VALUE,
    NULL                                            AS VALUE_SOURCE_VALUE,

    -- Additional Fields for Stage
    PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID          AS PULL_CSN_ID,
    T_DIAGNOSIS_OBSERVATION.ICD10_CODE              AS PULL_ICD10_CODE,
    T_DIAGNOSIS_OBSERVATION.ICD9_CODE               AS PULL_ICD9_CODE,
    T_DIAGNOSIS_OBSERVATION.DX_ID                   AS PULL_DX_ID

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_AMB AS PULL_VISIT_OCCURRENCE_AMB

    -- Join with patient encounter diagnosis
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC_DX AS PAT_ENC_DX
        ON PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID = PAT_ENC_DX.PAT_ENC_CSN_ID

    -- Join with diagnosis observation lookup
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_DIAGNOSIS_OBSERVATION AS T_DIAGNOSIS_OBSERVATION
        ON PAT_ENC_DX.DX_ID = T_DIAGNOSIS_OBSERVATION.DX_ID;