---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_INGREDIENTCLASS_DETAIL
-- Purpose:
-- This query performs quality assurance checks on drug exposure data, specifically validating
-- ingredient class information.
---------------------------------------------------------------------

WITH INGREDIENTCLASS_DETAIL AS (
    SELECT 
        'DRUG_CONCEPT_ID' AS METRIC_FIELD,
        'INGREDIENT CLASS' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS CONCEPT
        ON DRUG_EXPOSURE.DRUG_CONCEPT_ID = CONCEPT.CONCEPT_ID
    WHERE (UPPER(CONCEPT.CONCEPT_CLASS_ID) = 'INGREDIENT')
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM INGREDIENTCLASS_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*
Tables Used:
1. DRUG_EXPOSURE_RAW - Contains raw drug exposure data
2. CONCEPT - Contains standardized vocabulary concepts

Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Indicates the primary table being analyzed ('DRUG_EXPOSURE')
- QA_METRIC: Type of quality check being performed ('INGREDIENT CLASS')
- METRIC_FIELD: Field being validated ('DRUG_CONCEPT_ID')
- ERROR_TYPE: Classification of the issue found ('WARNING')
- CDT_ID: Drug exposure identifier (DRUG_EXPOSURE_ID)

Logic:
1. The CTE INGREDIENTCLASS_DETAIL identifies drug exposures where the concept class
   is specifically an 'INGREDIENT'
2. Main query filters for non-'EXPECTED' error types and returns QA results
3. Results include only warning cases where drug concepts are classified as ingredients

Notes:
- Uses LEFT JOIN to include all drug exposures, even if no matching concept is found
- All concept class IDs are compared in uppercase for consistency

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/