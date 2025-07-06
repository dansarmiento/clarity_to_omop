/*******************************************************************************
* Query: Drug Exposure Analysis with RxNorm Codes
* Description: Retrieves distinct medication IDs and their associated RxNorm 
*              classification details, focusing on valid drug concepts.
* Tables: 
*   - PULL_DRUG_EXPOSURE_AMB_RXNORM
*   - CONCEPT
*******************************************************************************/

SELECT DISTINCT 
    PULL_DRUG_EXPOSURE_AMB_RXNORM.PULL_MEDICATION_ID,
    PULL_RXNORM_CODES_LINE,
    C.CONCEPT_CODE,
    C.CONCEPT_CLASS_ID,
    C.THEORDER
FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_DRUG_EXPOSURE_AMB_RXNORM AS PULL_DRUG_EXPOSURE_AMB_RXNORM
    INNER JOIN (
        SELECT 
            CONCEPT_CODE,
            CONCEPT_CLASS_ID,
            -- Hierarchy order for different drug concept classes
            CASE
                -- Primary Classifications (0-99)
                WHEN UPPER(CONCEPT_CLASS_ID) = 'INGREDIENT'          THEN 10
                WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DRUG FORM'  THEN 20
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG FORM'   THEN 30
                WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DRUG COMP'  THEN 40
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG COMP'   THEN 42  -- Order not verified
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRAND NAME'          THEN 45  -- Order not verified
                WHEN UPPER(CONCEPT_CLASS_ID) = 'QUANT CLINICAL DRUG' THEN 50
                WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DRUG'       THEN 60
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG FORM'   THEN 70
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG'        THEN 80
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED PACK'        THEN 99

                -- Secondary Classifications (999)
                WHEN UPPER(CONCEPT_CLASS_ID) = 'QUANT BRANDED DRUG'  THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'DOSE FORM GROUP'     THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'DOSE FORM'          THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DOSE GROUP'  THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DOSE GROUP' THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'PRECISE INGREDIENT'  THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'QUANT BRANDED DRUG'  THEN 999
                ELSE 0
            END AS THEORDER
        FROM 
            CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS CONCEPT
        WHERE 
            UPPER(VOCABULARY_ID) IN ('RXNORM')
            AND (INVALID_REASON IS NULL OR INVALID_REASON = '')
            AND UPPER(DOMAIN_ID) = 'DRUG'
    ) C ON PULL_DRUG_EXPOSURE_AMB_RXNORM.PULL_RXNORM_CODE = CONCEPT_CODE;