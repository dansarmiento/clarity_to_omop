
/***************************************************************
* Query: Allergen Information Retrieval
* Description: Retrieves allergen IDs and names, creating a formatted
*              concept name while excluding specific "no allergy" indicators
* 
* Tables Referenced:
*   - CARE_BRONZE_CLARITY_PROD.DBO.CL_ELG
****************************************************************/

SELECT 
    A.ALLERGEN_ID,                           -- Unique identifier for allergen
    A.ALLERGEN_NAME,                         -- Name of the allergen
    CONCAT(
        'ALLERGY TO ',
        A.ALLERGEN_NAME
    ) AS CONCEPT_NAME                        -- Formatted allergen concept name
FROM 
    CARE_BRONZE_CLARITY_PROD.DBO.CL_ELG AS A
WHERE 
    UPPER(ALLERGEN_NAME) NOT IN (            -- Exclude standard "no allergy" indicators
        'NO KNOWN ALLERGIES',
        'NKA',
        'NKDA',
        'NONE'
    );
