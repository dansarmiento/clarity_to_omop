/*******************************************************
Script Name: QA_VISIT_OCCURRENCE_END_BEFORE_START_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************/

---------------------------------------------------------------------
-- Counts records where visit end date is before start date
---------------------------------------------------------------------

WITH END_BEFORE_START_COUNT AS (
SELECT 
    'VISIT_END_DATETIME' AS METRIC_FIELD,
    'END_BEFORE_START' AS QA_METRIC, 
    'INVALID DATA' AS ERROR_TYPE,
    COUNT(*) AS CNT
FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW
WHERE VISIT_END_DATETIME < VISIT_START_DATETIME
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    'END_BEFORE_START' AS QA_METRIC,
    'VISIT_END_DATETIME' AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM END_BEFORE_START_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************
Column Descriptions:
- RUN_DATE: Date QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked
- QA_METRIC: Type of QA check performed
- METRIC_FIELD: Field being validated
- QA_ERRORS: Count of records failing validation
- ERROR_TYPE: Description of error found
- TOTAL_RECORDS: Total count in raw table
- TOTAL_RECORDS_CLEAN: Total count in clean table

Logic:
1. Identifies records where visit end date/time is before start date/time
2. Counts total errors found
3. Returns summary metrics including error counts and total record counts

Legal Warning:
This code is provided as-is without warranty of any kind, either
express or implied, including any implied warranties of fitness for a
particular purpose, merchantability, or non-infringement.

Use at your own risk.
********************************************************/