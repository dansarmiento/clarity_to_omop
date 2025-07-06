/*******************************************************
 * Query to map source concepts to standard concepts
 * for conditions in the OMOP CDM
 *
 * This query finds valid mappings between source and 
 * standard concepts in the Condition domain
 *******************************************************/

SELECT 
    C2.CONCEPT_ID AS CONCEPT_ID,          -- Standard concept ID
    C1.CONCEPT_ID AS SOURCE_CONCEPT_ID     -- Source concept ID

FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C1
    
    -- Join to get concept relationships
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT_RELATIONSHIP AS CR
        ON C1.CONCEPT_ID = CR.CONCEPT_ID_1
        AND CR.RELATIONSHIP_ID = 'MAPS TO'
    
    -- Join to get standard concepts
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C2
        ON C2.CONCEPT_ID = CR.CONCEPT_ID_2

WHERE 
    -- Ensure target concept is a standard concept
    C2.STANDARD_CONCEPT = 'S'
    
    -- Ensure target concept is not invalid
    AND (
        C2.INVALID_REASON IS NULL
        OR C2.INVALID_REASON = ''
    )
    
    -- Limit to Condition domain
    AND C2.DOMAIN_ID = 'CONDITION'