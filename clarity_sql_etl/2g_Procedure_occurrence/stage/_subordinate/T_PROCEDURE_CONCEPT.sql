/***************************************************************
 * Query: Source to Standard Procedure Concept Mapping
 * 
 * Description: 
 * This query maps source procedure concepts to their corresponding 
 * standard concepts in the OMOP CDM vocabulary.
 * 
 * Tables Used:
 * - CONCEPT (C1): Source concepts
 * - CONCEPT (C2): Standard concepts
 * - CONCEPT_RELATIONSHIP: Maps relationships between concepts
 *
 * Returns:
 * - CONCEPT_ID: Standard procedure concept ID
 * - SOURCE_CONCEPT_ID: Original source concept ID
 ***************************************************************/

SELECT 
    C2.CONCEPT_ID AS CONCEPT_ID,          -- Standard concept identifier
    C1.CONCEPT_ID AS SOURCE_CONCEPT_ID    -- Source concept identifier
FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C1
    
    -- Join to get mapping relationships
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT_RELATIONSHIP AS CR
        ON C1.CONCEPT_ID = CR.CONCEPT_ID_1
        AND UPPER(CR.RELATIONSHIP_ID) = 'MAPS TO'
    
    -- Join to get standard concepts
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C2 
        ON C2.CONCEPT_ID = CR.CONCEPT_ID_2
WHERE
    C2.STANDARD_CONCEPT = 'S'             -- Ensure target is a standard concept
    AND UPPER(C2.DOMAIN_ID) = 'PROCEDURE' -- Limit to procedure domain
;