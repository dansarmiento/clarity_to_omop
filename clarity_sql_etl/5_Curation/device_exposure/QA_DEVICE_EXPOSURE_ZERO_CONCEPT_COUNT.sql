---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_ZERO_CONCEPT_COUNT
---------------------------------------------------------------------

WITH CTE_ERROR_COUNT AS (
    -- Check for zero concepts in DEVICE_CONCEPT_ID
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (DEVICE_CONCEPT_ID = 0)
    
    UNION ALL
    
    -- Check for zero concepts in DEVICE_TYPE_CONCEPT_ID
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (DEVICE_TYPE_CONCEPT_ID = 0)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM CTE_ERROR_COUNT
GROUP BY 
    STANDARD_DATA_TABLE, 
    METRIC_FIELD, 
    QA_METRIC, 
    ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Current date when the query is executed
STANDARD_DATA_TABLE: Name of the table being analyzed (DEVICE_EXPOSURE)
QA_METRIC: Type of quality check being performed (ZERO CONCEPT)
METRIC_FIELD: Field being analyzed for zero concepts
QA_ERRORS: Count of records with zero concepts
ERROR_TYPE: Type of error found (WARNING if errors exist, NULL if no errors)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. CTE_ERROR_COUNT checks for zero concepts in two fields:
   - DEVICE_CONCEPT_ID
   - DEVICE_TYPE_CONCEPT_ID

2. Main query:
   - Combines error counts from both checks
   - Adds current run date
   - Calculates total records in both raw and clean tables
   - Returns WARNING only if errors are found

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/