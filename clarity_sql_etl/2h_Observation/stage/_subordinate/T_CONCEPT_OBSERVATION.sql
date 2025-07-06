/***************************************************************
 * Purpose: This query maps source concepts to standard concepts
 * in the Observation domain using the 'Maps To' relationship.
 * 
 * Tables Used:
 * - CONCEPT (C1, C2): Contains concept definitions
 * - CONCEPT_RELATIONSHIP (CR): Contains relationships between concepts
 *
 * Returns:
 * - CONCEPT_ID: Standard concept identifier
 * - SOURCE_CONCEPT_ID: Source concept identifier
 ***************************************************************/

SELECT 
    C2.CONCEPT_ID AS CONCEPT_ID,          -- Standard concept ID
    C1.CONCEPT_ID AS SOURCE_CONCEPT_ID    -- Source concept ID

FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C1
    
    -- Join to get relationship between concepts
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT_RELATIONSHIP AS CR
        ON C1.CONCEPT_ID = CR.CONCEPT_ID_1
        AND UPPER(CR.RELATIONSHIP_ID) = 'MAPS TO'
    
    -- Join to get standard concept details
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C2
        ON C2.CONCEPT_ID = CR.CONCEPT_ID_2

WHERE 
    C2.STANDARD_CONCEPT = 'S'             -- Must be a standard concept
    AND (
        C2.INVALID_REASON IS NULL         -- Must be currently valid
        OR C2.INVALID_REASON = ''
    )
    AND UPPER(C2.DOMAIN_ID) = 'OBSERVATION'  -- Must be in Observation domain