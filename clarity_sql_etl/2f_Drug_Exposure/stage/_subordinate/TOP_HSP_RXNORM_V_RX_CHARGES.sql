

/*******************************************************************************
* Query: Medication Concept Classification
* Description: Retrieves distinct medication IDs and their associated RxNorm 
* classifications, joining drug exposure data with concept definitions.
* 
* Tables:
* - PULL_DRUG_EXPOSURE_HOSP_V_RX_CHARGES: Contains hospital drug exposure data
* - CONCEPT: OMOP vocabulary concept definitions
*******************************************************************************/

SELECT DISTINCT 
    PULL_MEDICATION_ID,
    PULL_RXNORM_CODES_LINE,
    C.CONCEPT_CODE,
    C.CONCEPT_CLASS_ID,
    C.THEORDER
FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_DRUG_EXPOSURE_HOSP_V_RX_CHARGES AS PULL_DRUG_EXPOSURE_HOSP_V_RX_CHARGES
INNER JOIN (
    SELECT 
        CONCEPT_CODE,
        CONCEPT_CLASS_ID,
        -- Assigns priority order to different medication concept classes
        CASE
            -- Highest priority classifications
            WHEN UPPER(CONCEPT_CLASS_ID) = 'INGREDIENT' THEN 10
            WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DRUG FORM' THEN 20
            WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG FORM' THEN 30
            WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DRUG COMP' THEN 40
            WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG COMP' THEN 42  -- Order not verified
            WHEN UPPER(CONCEPT_CLASS_ID) = 'BRAND NAME' THEN 45         -- Order not verified
            
            -- Mid-priority classifications
            WHEN UPPER(CONCEPT_CLASS_ID) = 'QUANT CLINICAL DRUG' THEN 50
            WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DRUG' THEN 60
            WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG FORM' THEN 70
            WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG' THEN 80
            WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED PACK' THEN 99
            
            -- Lowest priority classifications (order undefined)
            WHEN UPPER(CONCEPT_CLASS_ID) IN (
                'QUANT BRANDED DRUG',
                'DOSE FORM GROUP',
                'DOSE FORM',
                'BRANDED DOSE GROUP',
                'CLINICAL DOSE GROUP',
                'PRECISE INGREDIENT',
                'QUANT BRANDED DRUG'
            ) THEN 999
            
            ELSE 0
        END AS THEORDER
    FROM 
        CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS CONCEPT
    WHERE 
        UPPER(VOCABULARY_ID) IN ('RXNORM')
        AND (INVALID_REASON IS NULL OR INVALID_REASON = '')
        AND UPPER(DOMAIN_ID) = 'DRUG'
) C ON PULL_DRUG_EXPOSURE_HOSP_V_RX_CHARGES.PULL_RXNORM_CODE = CONCEPT_CODE;
