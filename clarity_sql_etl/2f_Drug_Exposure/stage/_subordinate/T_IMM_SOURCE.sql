/***************************************************************
* Query: Retrieve Valid CVX Vaccine Concepts
* Purpose: Gets active vaccine concepts from the CVX vocabulary
* Source Table: CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT
****************************************************************/

SELECT 
    CONCEPT_ID,          -- Unique identifier for the concept
    CONCEPT_CODE,        -- Source code from the CVX vocabulary
    CONCEPT_CLASS_ID,    -- Classification of the concept
    CONCEPT_NAME         -- Human readable name of the concept

FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C

WHERE 
    UPPER(C.VOCABULARY_ID) IN ('CVX')           -- Limits to CVX vocabulary concepts
    AND (
        C.INVALID_REASON IS NULL                -- Includes only valid concepts
        OR C.INVALID_REASON = ''                -- that haven't been invalidated
    )
    AND UPPER(C.DOMAIN_ID) = 'DRUG'            -- Limits to drug domain concepts
;