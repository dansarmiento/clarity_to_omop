/*******************************************************************************
* Query to retrieve valid ICD9/10 observation concepts
* 
* This query selects concept details for valid ICD9-CM and ICD10-CM codes
* that are classified as observations in the OMOP CDM.
*
* Tables:
*   CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT
*
* Returns:
*   - CONCEPT_ID: Unique identifier for the concept
*   - CONCEPT_CODE: Source code for the concept
*   - CONCEPT_NAME: Human-readable name for the concept
*******************************************************************************/

SELECT 
    CONCEPT_ID,
    CONCEPT_CODE,
    CONCEPT_NAME
FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
WHERE 
    UPPER(C.VOCABULARY_ID) IN ('ICD9CM', 'ICD10CM')
    AND (
        C.INVALID_REASON IS NULL
        OR C.INVALID_REASON = ''
    )
    AND UPPER(C.DOMAIN_ID) = 'OBSERVATION';