/**
 * Query to retrieve specific concept information from OMOP vocabulary
 * 
 * Returns:
 * - CONCEPT_ID: Unique identifier for the concept
 * - CONCEPT_CODE: The source code for the concept
 * - CONCEPT_NAME: The name/description of the concept with quotes removed
 *
 * Filters:
 * - Only SNOMED vocabulary concepts
 * - Only valid concepts (no invalid reason)
 * - Only concepts in the Condition domain
 */

SELECT 
    CONCEPT_ID,
    CONCEPT_CODE,
    -- Remove double quotes from concept names
    REPLACE(CONCEPT_NAME, '"', '') AS CONCEPT_NAME

FROM CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C

WHERE 
    -- Filter for SNOMED vocabulary only
    C.VOCABULARY_ID IN ('SNOMED')
    
    -- Only include valid concepts
    AND (
        C.INVALID_REASON IS NULL
        OR C.INVALID_REASON = ''
    )
    
    -- Only include condition domain concepts
    AND C.DOMAIN_ID = 'CONDITION'