/***************************************************************
 * Query: PULL_CONDITION_OCCURRENCE_AMB_SNO
 * Description: Retrieves condition occurrence data for ambulatory encounters
 * with SNOMED codes, excluding hospital encounters.
 ***************************************************************/

SELECT DISTINCT
    -- Stage Attributes (OMOP CDM fields)
    PULL_VISIT_OCCURRENCE_AMB.PERSON_ID                            AS PERSON_ID,
    PULL_VISIT_OCCURRENCE_AMB.VISIT_START_DATETIME::DATE           AS CONDITION_START_DATE,
    PULL_VISIT_OCCURRENCE_AMB.VISIT_START_DATETIME                 AS CONDITION_START_DATETIME,
    PULL_VISIT_OCCURRENCE_AMB.VISIT_END_DATETIME::DATE             AS CONDITION_END_DATE,
    PULL_VISIT_OCCURRENCE_AMB.VISIT_END_DATETIME                   AS CONDITION_END_DATETIME,
    PULL_VISIT_OCCURRENCE_AMB.PULL_PROVIDER_SOURCE_VALUE           AS PROVIDER_SOURCE_VALUE,

    -- Additional Attributes (Non-OMOP fields for staging)
    PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID                          AS PULL_CSN_ID,
    PULL_VISIT_OCCURRENCE_AMB.VISIT_START_DATE                     AS PULL_VISIT_DATE,
    T_SNO_CODE.DX_ID                                               AS PULL_DX_ID,
    T_SNO_CODE.DX_NAME                                             AS PULL_DX_NAME,
    T_SNO_CODE.CURRENT_ICD9_LIST                                   AS PULL_CURRENT_ICD9_LIST,
    T_SNO_CODE.CURRENT_ICD10_LIST                                  AS PULL_CURRENT_ICD10_LIST,
    T_SNO_CODE.SNOMED_CODE                                         AS PULL_SNOMED_CODE

FROM CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC_DX AS PAT_ENC_DX

-- Join with ambulatory visit occurrence data
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_AMB AS PULL_VISIT_OCCURRENCE_AMB
    ON PAT_ENC_DX.PAT_ENC_CSN_ID = PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID

-- Join with SNOMED code mapping table
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.T_SNO_CODE AS T_SNO_CODE
    ON PAT_ENC_DX.DX_ID = T_SNO_CODE.DX_ID

-- Filter out hospital encounters
WHERE PULL_VISIT_OCCURRENCE_AMB.PULL_ENC_TYPE_C <> 3;