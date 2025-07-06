/***************************************************************
* Query to retrieve specific procedure concepts from CPT4
*
* Purpose: Extracts procedure-related concepts from the CPT4 
*          vocabulary in the CONCEPT table
*
* Tables Referenced:
*   - CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT
*
* Columns Retrieved:
*   - CONCEPT_ID: Unique identifier for the concept
*   - CONCEPT_CODE: Source code from the vocabulary
*   - DOMAIN_ID: Domain the concept belongs to
*   - VOCABULARY_ID: Source vocabulary identifier
***************************************************************/

SELECT 
    CONCEPT_ID,
    CONCEPT_CODE,
    DOMAIN_ID,
    VOCABULARY_ID
FROM 
    CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
WHERE 
    UPPER(C.VOCABULARY_ID) IN ('CPT4')
    AND UPPER(C.DOMAIN_ID) = 'PROCEDURE';