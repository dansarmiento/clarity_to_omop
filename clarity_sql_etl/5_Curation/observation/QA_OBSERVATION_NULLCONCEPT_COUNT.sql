/*********************************************************
Script Name: QA_OBSERVATION_NULLCONCEPT_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script checks for null concept IDs in the OBSERVATION table
and reports counts of QA issues found.

Legal Warning: 
This code is provided as-is without any implied warranty.
Use at your own risk.
*********************************************************/

WITH NULLCONCEPT_COUNT AS (
    -- Check for null observation concept IDs
    SELECT 
        'OBSERVATION_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (OBSERVATION_CONCEPT_ID IS NULL)

    UNION ALL

    -- Check for null observation type concept IDs 
    SELECT 
        'OBSERVATION_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (OBSERVATION_TYPE_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'OBSERVATION' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION) AS TOTAL_RECORDS_CLEAN
FROM NULLCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
Column Descriptions:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked
- QA_METRIC: Type of QA check performed
- METRIC_FIELD: Field being checked
- QA_ERRORS: Count of errors found
- ERROR_TYPE: Severity of error (FATAL in this case)
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
1. CTE checks for null concept IDs in observation and observation type fields
2. Main query aggregates results and adds metadata
3. Compares raw vs clean record counts
*/