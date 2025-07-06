/*******************************************************************************
* Script: STAGE_DEATH_ALL
* Description: Retrieves and stages death-related information from source tables
* 
* Tables Referenced:
* - CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_DEATH_ALL
*
* Output Columns:
* - Standard OMOP Fields: PERSON_ID, DEATH_DATE, DEATH_DATETIME
* - Custom Fields: ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, 
*                 CAUSE_CONCEPT_ID, CAUSE_SOURCE_VALUE, CAUSE_SOURCE_CONCEPT_ID
*******************************************************************************/

SELECT DISTINCT
    -- Standard OMOP Fields
    PULL_DEATH_ALL.PERSON_ID         AS PERSON_ID,
    PULL_DEATH_ALL.DEATH_DATE        AS DEATH_DATE,
    PULL_DEATH_ALL.DEATH_DATETIME    AS DEATH_DATETIME,

    -- Non-OMOP Fields
    'STAGE_PERSON_ALL'               AS ETL_MODULE,
    PULL_DEATH_ALL.PULL_PAT_ID       AS STAGE_PAT_ID,
    PULL_DEATH_ALL.PULL_MRN_CPI      AS STAGE_MRN_CPI,
    
    -- Cause of Death Fields (Currently Nullified)
    NULL                             AS CAUSE_CONCEPT_ID,
    NULL                             AS CAUSE_SOURCE_VALUE,
    NULL                             AS CAUSE_SOURCE_CONCEPT_ID

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_DEATH_ALL AS PULL_DEATH_ALL

/* Note: Death Cause joins removed to prevent duplicates in OMOP 5.4
LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_DEATH_CAUSE_SOURCE AS T_DEATH_CAUSE_SOURCE
    ON PULL_DEATH_ALL.CAUSE_SNOMED_CODE = T_DEATH_CAUSE_SOURCE.CONCEPT_CODE
LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_DEATH_CAUSE_CONCEPT AS T_DEATH_CAUSE_CONCEPT
    ON T_DEATH_CAUSE_CONCEPT.SOURCE_CONCEPT_ID = T_DEATH_CAUSE_SOURCE.CONCEPT_ID
*/

WHERE 
    PULL_DEATH_ALL.DEATH_DATE IS NOT NULL;