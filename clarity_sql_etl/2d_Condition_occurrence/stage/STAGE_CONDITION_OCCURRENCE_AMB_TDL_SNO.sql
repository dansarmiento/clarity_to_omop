/***************************************************************
 * Script: STAGE_CONDITION_OCCURRENCE_AMB_TDL_SNO
 * Description: Extracts and transforms ambulatory condition occurrences 
 * from TDL SNO source data into OMOP CDM format
 * 
 * Target Table: STAGE_CONDITION_OCCURRENCE
 ***************************************************************/

SELECT DISTINCT
    -- Standard OMOP CDM Fields
    PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO.PERSON_ID                     AS PERSON_ID,
    T_CONDITION_CONCEPT.CONCEPT_ID                                      AS CONDITION_CONCEPT_ID,
    PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO.CONDITION_START_DATE         AS CONDITION_START_DATE,
    PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO.CONDITION_START_DATETIME     AS CONDITION_START_DATETIME,
    PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO.CONDITION_END_DATE           AS CONDITION_END_DATE,
    PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO.CONDITION_END_DATETIME       AS CONDITION_END_DATETIME,
    32817                                                              AS CONDITION_TYPE_CONCEPT_ID,  -- EHR Chief Complaint
    NULL                                                               AS STOP_REASON,
    PROVIDER.PROVIDER_ID                                               AS PROVIDER_ID,
    VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID                               AS VISIT_OCCURRENCE_ID,
    NULL                                                               AS VISIT_DETAIL_ID,
    
    -- Source Values
    LEFT(COALESCE(PULL_CURRENT_ICD10_LIST, PULL_CURRENT_ICD9_LIST) 
         || ': ' || T_SNO_SOURCE.CONCEPT_NAME, 50)                     AS CONDITION_SOURCE_VALUE,
    T_CONDITION_CONCEPT.CONCEPT_ID                                     AS CONDITION_SOURCE_CONCEPT_ID,
    CONDITION_STATUS_SOURCE_VALUE                                      AS CONDITION_STATUS_SOURCE_VALUE,
    
    -- Condition Status
    CASE 
        WHEN CONDITION_STATUS_SOURCE_VALUE = 'PRIMARY_DX' THEN 32902   -- Primary diagnosis
        ELSE 32908                                                     -- Secondary diagnosis
    END                                                               AS CONDITION_STATUS_CONCEPT_ID,

    -- Custom Fields for Tracking
    'STAGE_CONDITION_OCCURRENCE_AMB_TDL_SNO'                          AS ETL_MODULE,
    VISIT_OCCURRENCE.phi_PAT_ID                                       AS STAGE_PAT_ID,
    VISIT_OCCURRENCE.phi_MRN_CPI                                      AS STAGE_MRN_CPI,
    VISIT_OCCURRENCE.phi_CSN_ID                                       AS STAGE_CSN_ID,
    PULL_DX_ID                                                        AS STAGE_DX_ID

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO AS PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO

    -- Join to get Visit Information
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO.PULL_CSN_ID = VISIT_OCCURRENCE.phi_CSN_ID

    -- Join to get Provider Information
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER
        ON PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO.PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE

    -- Concept Mapping Joins
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_SNO_SOURCE AS T_SNO_SOURCE
        ON PULL_CONDITION_OCCURRENCE_AMB_TDL_SNO.PULL_SNOMED_CODE = T_SNO_SOURCE.CONCEPT_CODE

    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_CONDITION_CONCEPT AS T_CONDITION_CONCEPT
        ON T_CONDITION_CONCEPT.SOURCE_CONCEPT_ID = T_SNO_SOURCE.CONCEPT_ID

-- Only include records with valid condition concepts
WHERE T_CONDITION_CONCEPT.CONCEPT_ID IS NOT NULL;