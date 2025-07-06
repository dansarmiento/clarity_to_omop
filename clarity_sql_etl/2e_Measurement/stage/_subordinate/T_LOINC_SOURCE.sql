/*******************************************************************************
* Query to retrieve valid LOINC lab test measurements from the CONCEPT table
*
* This query filters for:
* - Valid concepts (where INVALID_REASON is null or empty)
* - Measurements in the LOINC vocabulary
* - Concepts specifically classified as lab tests
*
* Returns: CONCEPT_ID and CONCEPT_CODE for matching records
*******************************************************************************/

SELECT 
    CONCEPT_ID,
    CONCEPT_CODE
FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
WHERE 
    (C.INVALID_REASON IS NULL OR C.INVALID_REASON = '')
    AND UPPER(C.DOMAIN_ID) = 'MEASUREMENT'
    AND UPPER(VOCABULARY_ID) = 'LOINC'
    AND UPPER(CONCEPT_CLASS_ID) = 'LAB TEST';