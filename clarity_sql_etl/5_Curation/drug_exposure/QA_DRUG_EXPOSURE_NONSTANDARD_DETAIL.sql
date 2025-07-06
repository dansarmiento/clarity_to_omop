/*
QA_DRUG_EXPOSURE_NONSTANDARD_DETAIL
This query identifies non-standard or invalid concept IDs in the DRUG_EXPOSURE table
*/

WITH NONSTANDARD_DETAIL AS (
    -- Check for non-standard DRUG_CONCEPT_ID
    SELECT 
        'DRUG_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DE
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON DE.DRUG_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'DRUG' 
        AND upper(C.VOCABULARY_ID) IN ('RXNORM', 'CVX')
    WHERE DRUG_CONCEPT_ID <> 0 
        AND DRUG_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard DRUG_TYPE_CONCEPT_ID
    SELECT 
        'DRUG_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DE
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON DE.DRUG_TYPE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT' 
        AND upper(C.VOCABULARY_ID) = 'TYPE CONCEPT'
    WHERE DRUG_TYPE_CONCEPT_ID <> 0 
        AND DRUG_TYPE_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard ROUTE_CONCEPT_ID
    SELECT 
        'ROUTE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DE
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON DE.ROUTE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'ROUTE' 
        AND upper(C.VOCABULARY_ID) = 'SNOMED'
    WHERE ROUTE_CONCEPT_ID <> 0 
        AND ROUTE_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard DRUG_SOURCE_CONCEPT_ID
    SELECT 
        'DRUG_SOURCE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DE
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON DE.DRUG_SOURCE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'DRUG' 
        AND upper(C.VOCABULARY_ID) IN ('RXNORM', 'CVX')
    WHERE DRUG_SOURCE_CONCEPT_ID <> 0 
        AND C.CONCEPT_ID IS NULL
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NONSTANDARD_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked (DRUG_EXPOSURE)
- QA_METRIC: Type of quality check being performed (NON-STANDARD)
- METRIC_FIELD: The specific field being checked for quality issues
- ERROR_TYPE: Type of error found (INVALID DATA)
- CDT_ID: The DRUG_EXPOSURE_ID of the record with the issue

LOGIC:
1. The query checks four different concept ID fields in the DRUG_EXPOSURE table:
   - DRUG_CONCEPT_ID: Must be standard RxNorm or CVX concepts
   - DRUG_TYPE_CONCEPT_ID: Must be standard Type Concepts
   - ROUTE_CONCEPT_ID: Must be standard SNOMED concepts
   - DRUG_SOURCE_CONCEPT_ID: Must exist in RxNorm or CVX vocabularies

2. For each field, it joins to the CONCEPT table to verify:
   - The concept exists in the correct domain
   - The concept is from the correct vocabulary
   - The concept is marked as standard (where applicable)

3. Records are flagged if they:
   - Have non-zero, non-null concept IDs
   - Fail to meet the standardization criteria
   - Are not marked as "EXPECTED" errors

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/