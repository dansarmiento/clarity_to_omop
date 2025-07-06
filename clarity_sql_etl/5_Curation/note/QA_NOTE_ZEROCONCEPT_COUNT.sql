/*******************************************************
Script Name: QA_NOTE_ZEROCONCEPT_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: Quality assurance check for zero concept IDs in NOTE table
*******************************************************/

WITH ZEROCONCEPT_COUNT
AS (
    SELECT 
        'NOTE_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    WHERE (NOTE_TYPE_CONCEPT_ID = 0)

    UNION ALL

    SELECT 
        'NOTE_CLASS_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    WHERE (NOTE_CLASS_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'NOTE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE) AS TOTAL_RECORDS_CLEAN
FROM ZEROCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************
Column Descriptions:
- RUN_DATE: Date QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being evaluated
- QA_ERRORS: Count of records failing the check
- ERROR_TYPE: Severity level of the error
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
1. Checks NOTE_RAW table for records where concept IDs = 0
2. Counts occurrences of zero concepts for NOTE_TYPE and NOTE_CLASS
3. Returns summary metrics including error counts and totals

Legal Warning:
This code is provided as-is without any implied warranty.
Use at your own risk. No guarantee of fitness for any particular
purpose is provided.
*******************************************************/