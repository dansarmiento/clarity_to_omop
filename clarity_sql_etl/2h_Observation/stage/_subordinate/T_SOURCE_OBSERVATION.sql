/*******************************************************************************
* Query to retrieve allergy-related concepts from SNOMED
* 
* This query selects specific concept details from the OMOP CONCEPT table
* filtering for valid SNOMED allergy observations
*
* Tables:
*   CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT
*
* Returns:
*   - CONCEPT_ID: Unique identifier for the concept
*   - CONCEPT_CODE: The source code for the concept
*   - CONCEPT_NAME: The descriptive name of the concept
*******************************************************************************/

SELECT 
    CONCEPT_ID,
    CONCEPT_CODE,
    CONCEPT_NAME
FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
WHERE 
    UPPER(C.VOCABULARY_ID) IN ('SNOMED')
    AND (
        C.INVALID_REASON IS NULL
        OR C.INVALID_REASON = ''
    )
    AND UPPER(C.DOMAIN_ID) = 'OBSERVATION'
    AND UPPER(CONCEPT_NAME) LIKE 'ALLERGY TO %'
    AND UPPER(CONCEPT_CLASS_ID) = 'CLINICAL FINDING';