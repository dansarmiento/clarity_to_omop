/***************************************************************
* Query: Concept Mapping for Standard Conditions
* Description: Retrieves mappings between source and standard 
*              condition concepts from the OMOP vocabulary
* 
* Tables Used:
*   - CONCEPT (C1, C2)
*   - CONCEPT_RELATIONSHIP (CR)
****************************************************************/

SELECT 
    C2.CONCEPT_ID AS CONCEPT_ID,          -- Standard concept identifier
    C1.CONCEPT_ID AS SOURCE_CONCEPT_ID    -- Source concept identifier

FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C1
    
    -- Join to get relationship mappings
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT_RELATIONSHIP AS CR
        ON C1.CONCEPT_ID = CR.CONCEPT_ID_1
        AND UPPER(CR.RELATIONSHIP_ID) = 'MAPS TO'
    
    -- Join to get standard concept details
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C2
        ON C2.CONCEPT_ID = CR.CONCEPT_ID_2

WHERE 
    -- Ensure target concept is a standard concept
    UPPER(C2.STANDARD_CONCEPT) = 'S'
    
    -- Exclude invalid concepts
    AND (
        C2.INVALID_REASON IS NULL
        OR C2.INVALID_REASON = ''
    )
    
    -- Filter for condition domain
    AND UPPER(C2.DOMAIN_ID) = 'CONDITION';