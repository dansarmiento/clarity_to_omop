/***************************************************************
* Query Purpose: Retrieves distinct diagnosis information with 
* associated SNOMED codes and ICD mappings
*
* Tables Used:
* - CLARITY_EDG: Contains diagnosis information
* - EXTERNAL_CNCPT_MAP: Maps external concepts
* - CONCEPT_MAPPED: Contains concept mapping information
* - SNOMED_CONCEPT: Contains SNOMED terminology
*
***************************************************************/

SELECT DISTINCT 
    CLARITY_EDG.DX_ID,                                          -- Unique diagnosis identifier
    CLARITY_EDG.DX_NAME,                                        -- Diagnosis name
    REPLACE(SNOMED_CONCEPT.CONCEPT_ID, 'SNOMED#', '') AS SNOMED_code,  -- Cleaned SNOMED code
    SNOMED_CONCEPT.FULLY_SPECIFIED_NM,                          -- Full SNOMED description
    CLARITY_EDG.CURRENT_ICD9_LIST,                             -- Current ICD-9 codes
    CLARITY_EDG.CURRENT_ICD10_LIST                             -- Current ICD-10 codes

FROM CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_EDG AS CLARITY_EDG
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.EXTERNAL_CNCPT_MAP AS EXTERNAL_CNCPT_MAP
        ON CLARITY_EDG.DX_ID = EXTERNAL_CNCPT_MAP.ENTITY_VALUE_NUM
    
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CONCEPT_MAPPED AS CONCEPT_MAPPED
        ON EXTERNAL_CNCPT_MAP.MAPPING_ID = CONCEPT_MAPPED.MAPPING_ID
    
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.SNOMED_CONCEPT AS SNOMED_CONCEPT
        ON CONCEPT_MAPPED.CONCEPT_ID = SNOMED_CONCEPT.CONCEPT_ID

WHERE (
    EXTERNAL_CNCPT_MAP.ENTITY_INI = 'EDG'
    AND EXTERNAL_CNCPT_MAP.ENTITY_ITEM = 0.1
    )
    AND SNOMED_code IS NOT NULL;