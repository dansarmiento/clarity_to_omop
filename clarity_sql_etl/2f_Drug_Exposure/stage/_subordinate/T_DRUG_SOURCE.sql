
--BEGIN cte__T_DRUG_SOURCE
/***************************************************************
* Query: Retrieve Valid RxNorm Drug Concepts
* 
* Description: This query retrieves active drug concepts from the 
* RxNorm vocabulary in the OMOP CDM concept table.
*
* Tables:
*   - CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT
*
* Filters:
*   - Vocabulary: RxNorm only
*   - Domain: Drug
*   - Status: Valid concepts only (not invalid/deprecated)
****************************************************************/

SELECT 
    CONCEPT_ID,          -- Unique identifier for the concept
    CONCEPT_CODE,        -- Source code from vocabulary
    CONCEPT_CLASS_ID,    -- Classification of the concept
    CONCEPT_NAME         -- Human readable name of the concept

FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C

WHERE 
    UPPER(C.VOCABULARY_ID) IN ('RXNORM')        -- Limit to RxNorm vocabulary
    AND (
        C.INVALID_REASON IS NULL                -- Include only valid concepts
        OR C.INVALID_REASON = ''                -- that are not deprecated
    )
    AND UPPER(C.DOMAIN_ID) = 'DRUG'            -- Limit to drug domain
;
--END cte__T_DRUG_SOURCE