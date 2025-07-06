/***************************************************************
 * Query: Drug Concept Mapping
 * Purpose: Maps source drug concepts to standard drug concepts
 * 
 * Tables Used:
 * - CONCEPT (C1, C2): Contains concept definitions
 * - CONCEPT_RELATIONSHIP (CR): Contains relationships between concepts
 ***************************************************************/

SELECT 
    C2.CONCEPT_ID AS DRUG_CONCEPT_ID,              -- Standard drug concept ID
    C1.CONCEPT_ID AS DRUG_CONCEPT_SOURCE_CONCEPT_ID -- Source drug concept ID

FROM CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C1
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT_RELATIONSHIP AS CR
        ON C1.CONCEPT_ID = CR.CONCEPT_ID_1
        AND UPPER(CR.RELATIONSHIP_ID) = 'MAPS TO'  -- Only include 'Maps to' relationships
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C2
        ON C2.CONCEPT_ID = CR.CONCEPT_ID_2

WHERE C2.STANDARD_CONCEPT = 'S'                    -- Only include standard concepts
    AND (
        C2.INVALID_REASON IS NULL                 -- Exclude invalid concepts
        OR C2.INVALID_REASON = ''
    )
    AND UPPER(C2.DOMAIN_ID) = 'DRUG'              -- Only include drug domain concepts