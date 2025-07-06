/*******************************************************
Script Name: QA_VISIT_DETAIL_END_BEFORE_START_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************/

WITH END_BEFORE_START_COUNT AS (
    SELECT 
        'VISIT_DETAIL_END_DATETIME' AS METRIC_FIELD,
        'END_BEFORE_START' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW
    WHERE VISIT_DETAIL_END_DATETIME < VISIT_DETAIL_START_DATETIME
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_DETAIL' AS STANDARD_DATA_TABLE,
    'END_BEFORE_START' AS QA_METRIC,
    'VISIT_DETAIL_END_DATETIME' AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 
        THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL) AS TOTAL_RECORDS_CLEAN
FROM END_BEFORE_START_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************
Column Descriptions:
- RUN_DATE: Date the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of QA check being performed
- METRIC_FIELD: Specific field being validated
- QA_ERRORS: Count of records failing validation
- ERROR_TYPE: Category of error found
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
This script checks for invalid visit detail records where the 
end datetime is before the start datetime. These represent
logically impossible scenarios that need to be investigated.

Legal Warning:
This code is provided as-is without any implied warranty.
Use at your own risk. No liability is assumed for any
damages or losses arising from the use of this code.
********************************************************/