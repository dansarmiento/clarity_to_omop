---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_INGREDIENTCLASS_COUNT
-- PURPOSE:
-- This query performs quality assurance checks on drug exposure data,
-- specifically validating that drug concepts are properly classified
-- as ingredients in the OMOP vocabulary.
---------------------------------------------------------------------

WITH INGREDIENTCLASS_COUNT AS (
    SELECT 
        'DRUG_CONCEPT_ID' AS METRIC_FIELD,
        'INGREDIENT CLASS' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
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
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM INGREDIENTCLASS_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed (DRUG_EXPOSURE)
QA_METRIC: Type of quality check being performed (INGREDIENT CLASS)
METRIC_FIELD: Field being analyzed (DRUG_CONCEPT_ID)
QA_ERRORS: Count of records that failed the QA check
ERROR_TYPE: Type of error found (WARNING if errors exist, NULL if no errors)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. The CTE (INGREDIENTCLASS_COUNT) counts the number of records where:
   - DRUG_CONCEPT_ID in DRUG_EXPOSURE_RAW matches with CONCEPT table
   - The concept is classified as an 'INGREDIENT'

2. Main query:
   - Aggregates results from the CTE
   - Adds metadata (run date, table name)
   - Calculates total record counts for both raw and clean tables
   - Returns WARNING if any records are found with ingredient class issues

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.

*/