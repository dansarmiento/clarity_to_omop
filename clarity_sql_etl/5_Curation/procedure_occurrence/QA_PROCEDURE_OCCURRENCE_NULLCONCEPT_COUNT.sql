/***************************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_NULLCONCEPT_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Quality assurance check for null concepts in PROCEDURE_OCCURRENCE table
****************************************************************/

WITH NULLCONCEPT_COUNT AS (
    -- Check for null PROCEDURE_CONCEPT_ID
    SELECT 
        'PROCEDURE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (PROCEDURE_CONCEPT_ID IS NULL)

    UNION ALL

    -- Check for null PROCEDURE_TYPE_CONCEPT_ID
    SELECT 
        'PROCEDURE_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (PROCEDURE_TYPE_CONCEPT_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM NULLCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/***************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being checked
- QA_ERRORS: Count of errors found
- ERROR_TYPE: Classification of error severity
- TOTAL_RECORDS: Total number of records in raw table
- TOTAL_RECORDS_CLEAN: Total number of records in clean table

Logic:
1. Checks for null values in PROCEDURE_CONCEPT_ID
2. Checks for null values in PROCEDURE_TYPE_CONCEPT_ID
3. Aggregates results and provides comparison between raw and clean tables

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either express 
or implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
****************************************************************/