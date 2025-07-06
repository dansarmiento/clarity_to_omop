/*******************************************************************************
* Script Name: QA_OBSERVATION_NULLFK_COUNT.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Validates foreign key relationships in OBSERVATION_RAW table
*******************************************************************************/

WITH NULLFK_COUNT AS (
    -- Check for null VISIT_OCCURRENCE_ID (Warning level)
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD, 
        'NULL FK' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for null PERSON_ID (Fatal level)
    SELECT 
        'PERSON_ID' AS METRIC_FIELD, 
        'NULL FK' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (PERSON_ID IS NULL)
)

-- Final result set with QA metrics
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'OBSERVATION' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION) AS TOTAL_RECORDS_CLEAN
FROM NULLFK_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being validated
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Field being validated
* - QA_ERRORS: Count of validation errors found
* - ERROR_TYPE: Severity of the error (WARNING or FATAL)
* - TOTAL_RECORDS: Total number of records in the raw table
* - TOTAL_RECORDS_CLEAN: Total number of records in the clean table
*
* Logic:
* 1. Checks for null values in foreign key fields
* 2. VISIT_OCCURRENCE_ID nulls are considered warnings
* 3. PERSON_ID nulls are considered fatal errors
* 4. Compares raw vs clean table record counts
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind.
* The entire risk of use or results from the use of this code remains with you.
*******************************************************************************/