/***************************************************************
* Query to map source concepts to standard concepts
* using 'Maps to Value' relationships in the OMOP CDM
*
* Returns:
* - CONCEPT_ID: The standard concept ID
* - SOURCE_CONCEPT_ID: The source concept ID
***************************************************************/

SELECT 
    C2.CONCEPT_ID AS CONCEPT_ID,          -- Standard concept ID
    C1.CONCEPT_ID AS SOURCE_CONCEPT_ID    -- Source concept ID

FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C1
    
    -- Join to get relationship mappings
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT_RELATIONSHIP AS CR
        ON C1.CONCEPT_ID = CR.CONCEPT_ID_1
        AND UPPER(CR.RELATIONSHIP_ID) = 'MAPS TO VALUE'
    
    -- Join to get standard concept details
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C2
        ON C2.CONCEPT_ID = CR.CONCEPT_ID_2

WHERE 
    C2.STANDARD_CONCEPT = 'S'                     -- Ensure target is a standard concept
    AND (
        C2.INVALID_REASON IS NULL                 -- Only include valid concepts
        OR C2.INVALID_REASON = ''
    )
    -- AND UPPER(C2.DOMAIN_ID) = 'OBSERVATION'    