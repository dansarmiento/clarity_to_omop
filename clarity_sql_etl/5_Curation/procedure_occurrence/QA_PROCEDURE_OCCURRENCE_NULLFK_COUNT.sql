/*********************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_NULLFK_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Quality assurance check for null foreign keys in PROCEDURE_OCCURRENCE table
**********************************************************/

WITH NULLFK_COUNT
AS (
    -- Check for null VISIT_OCCURRENCE_ID (Warning level)
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD, 
        'NULL FK' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for null PERSON_ID (Fatal level)
    SELECT 
        'PERSON_ID' AS METRIC_FIELD, 
        'NULL FK' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (PERSON_ID IS NULL)
)

-- Final result set with QA metrics
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM NULLFK_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being evaluated
QA_ERRORS: Count of errors found
ERROR_TYPE: Severity of the error (WARNING or FATAL)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. Checks for null foreign keys in PROCEDURE_OCCURRENCE_RAW table
2. VISIT_OCCURRENCE_ID nulls are flagged as warnings
3. PERSON_ID nulls are flagged as fatal errors
4. Compares raw and clean table record counts

LEGAL WARNING:
-------------
This code is provided as-is with no implied warranty.
Use at your own risk. No guarantee of fitness for any particular purpose.
**********************************************************/