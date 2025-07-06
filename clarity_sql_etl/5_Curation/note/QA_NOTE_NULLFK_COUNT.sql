/*********************************************************
Script Name: QA_NOTE_NULLFK_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: Quality assurance check for NULL foreign keys in NOTE table
*********************************************************/

WITH NULLFK_COUNT AS (
    -- Check for NULL visit_occurrence_id (Warning)
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for NULL person_id (Fatal error) 
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT 
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    WHERE (PERSON_ID IS NULL)
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
FROM NULLFK_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
- RUN_DATE: Date QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Field being evaluated
- QA_ERRORS: Count of records failing the check
- ERROR_TYPE: Severity of error (WARNING or FATAL)
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
1. Checks for NULL foreign keys in NOTE_RAW table
2. VISIT_OCCURRENCE_ID nulls generate WARNING
3. PERSON_ID nulls generate FATAL error
4. Compares raw vs clean record counts

Legal Warning:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. In no event shall the authors be liable for any
damages whatsoever arising out of the use of this code.
*********************************************************/