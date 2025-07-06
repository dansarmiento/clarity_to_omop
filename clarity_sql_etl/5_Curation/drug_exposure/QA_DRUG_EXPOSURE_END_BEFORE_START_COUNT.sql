---------------------------------------------------------------------
-- DRUG_EXPOSURE_END_BEFORE_START_COUNT
-- This query identifies records where drug exposure end dates occur before start dates
---------------------------------------------------------------------

WITH END_BEFORE_START_COUNT AS (
    SELECT 
        'DRUG_EXPOSURE_END_DATE' AS METRIC_FIELD,
        'END_BEFORE_START' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW
    WHERE DRUG_EXPOSURE_END_DATE < DRUG_EXPOSURE_START_DATE
        OR DRUG_EXPOSURE_END_DATETIME < DRUG_EXPOSURE_START_DATETIME
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
FROM END_BEFORE_START_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC,
    ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Current date when the query is executed
STANDARD_DATA_TABLE: Name of the table being analyzed (DRUG_EXPOSURE)
QA_METRIC: Type of quality check being performed (END_BEFORE_START)
METRIC_FIELD: Field being evaluated (DRUG_EXPOSURE_END_DATE)
QA_ERRORS: Count of records with invalid data
ERROR_TYPE: Description of the error type (INVALID DATA)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. CTE identifies records where:
   - DRUG_EXPOSURE_END_DATE is earlier than DRUG_EXPOSURE_START_DATE
   - DRUG_EXPOSURE_END_DATETIME is earlier than DRUG_EXPOSURE_START_DATETIME

2. Main query:
   - Aggregates error counts
   - Adds metadata about the analysis
   - Includes record counts from both raw and clean tables
   - Returns NULL for ERROR_TYPE if no errors are found

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/