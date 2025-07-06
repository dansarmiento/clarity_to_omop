/*********************************************************
Script Name: QA_VISIT_DATEVDATETIME_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Purpose: Validates consistency between DATE and DATETIME fields
         in VISIT_OCCURRENCE_RAW table
**********************************************************/

WITH DATEVDATETIME_COUNT AS (
    SELECT 
        'VISIT_START_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (VISIT_START_DATE <> CAST(VISIT_START_DATETIME AS DATE)) 
            THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1

    UNION ALL

    SELECT 
        'VISIT_END_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (VISIT_END_DATE <> CAST(VISIT_END_DATETIME AS DATE)) 
            THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 
        THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM DATEVDATETIME_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being validated
QA_ERRORS: Count of records that failed the validation
ERROR_TYPE: Severity of the error (WARNING in this case)
TOTAL_RECORDS: Total number of records in the RAW table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. Compares DATE fields with their corresponding DATETIME fields
2. Counts instances where the date portion of DATETIME doesn't match DATE
3. Performs check for both start and end dates
4. Returns summary statistics and error counts

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. In no event shall the author be liable for any
damages whatsoever arising out of the use or inability to use
this code.
*********************************************************/