/*******************************************************************************
* Query to retrieve valid SNOMED condition concepts from OMOP Concept table
* 
* This query returns:
* - Concept IDs
* - Concept Codes
* - Concept Names (with double quotes removed)
*
* Filters:
* - Only SNOMED vocabulary
* - Only valid concepts (no invalid reason)
* - Only concepts in the Condition domain
*******************************************************************************/

SELECT 
    CONCEPT_ID,
    CONCEPT_CODE,
    REPLACE(CONCEPT_NAME, '"', '') AS CONCEPT_NAME
FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
WHERE 
    C.VOCABULARY_ID IN ('SNOMED')
    AND (
        C.INVALID_REASON IS NULL 
        OR C.INVALID_REASON = ''
    )
    AND UPPER(C.DOMAIN_ID) = 'CONDITION'