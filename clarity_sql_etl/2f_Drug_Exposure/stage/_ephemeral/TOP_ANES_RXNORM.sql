
--BEGIN cte__TOP_RXNORM_ANES
	SELECT DISTINCT PULL_MEDICATION_ID
		,PULL_RXNORM_CODES_LINE
		,C.CONCEPT_CODE
		,C.CONCEPT_CLASS_ID
		,C.THEORDER

    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_DRUG_EXPOSURE_ANES_RXNORM AS PULL_DRUG_EXPOSURE_ANES_RXNORM
    INNER JOIN (
        SELECT CONCEPT_CODE
            ,CONCEPT_CLASS_ID
            --CURRENTLY USED: CLINICAL PACK, BRANDED DRUG, CLINICAL DRUG, BRAND NAME, QUANT CLINICAL DRUG, INGREDIENT
            ,CASE
                WHEN UPPER(CONCEPT_CLASS_ID) = 'INGREDIENT'
                    THEN 10
                WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DRUG FORM'
                    THEN 20
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG FORM'
                    THEN 30
                WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DRUG COMP'
                    THEN 40
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG COMP' -- ORDER NOT VERIFIED
                    THEN 42
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRAND NAME' -- ORDER NOT VERIFIED
                    THEN 45
                WHEN UPPER(CONCEPT_CLASS_ID) = 'QUANT CLINICAL DRUG'
                    THEN 50
                WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DRUG'
                    THEN 60
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG FORM'
                    THEN 70
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DRUG'
                    THEN 80
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED PACK'
                    THEN 99
                        --DO NOT KNOW THE ORDER OF THESE
                WHEN UPPER(CONCEPT_CLASS_ID) = 'QUANT BRANDED DRUG'
                    THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'DOSE FORM GROUP'
                    THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'DOSE FORM'
                    THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'BRANDED DOSE GROUP'
                    THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'CLINICAL DOSE GROUP'
                    THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'PRECISE INGREDIENT'
                    THEN 999
                WHEN UPPER(CONCEPT_CLASS_ID) = 'QUANT BRANDED DRUG'
                    THEN 999
                ELSE 0
                END AS THEORDER

        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_CLARITY.CONCEPT_stg AS CONCEPT
        WHERE UPPER(VOCABULARY_ID) IN ('RXNORM')
            AND (
                INVALID_REASON IS NULL
                OR INVALID_REASON = ''
                )
            AND UPPER(DOMAIN_ID) = 'DRUG'
        ) C
        ON PULL_DRUG_EXPOSURE_ANES_RXNORM.PULL_RXNORM_CODE = CONCEPT_CODE
--    WHERE DRUG_EXPOSURE_CLARITYANES_RXNORM.RXNORM_TERM_TYPE_C <> 2 --2 - PRECISE INGREDIENT
--END cte__TOP_RXNORM_ANES
--