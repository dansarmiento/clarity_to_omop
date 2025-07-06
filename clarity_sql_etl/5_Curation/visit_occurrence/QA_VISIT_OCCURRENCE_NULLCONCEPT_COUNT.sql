/*********************************************************
Script Name: QA_VISIT_OCCURRENCE_NULLCONCEPT_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Quality assurance check for null concepts in VISIT_OCCURRENCE table
**********************************************************/

WITH NULLCONCEPT_COUNT AS (
    SELECT 
        'VISIT_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    WHERE (VISIT_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM NULLCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being checked for nulls
QA_ERRORS: Count of records with null values
ERROR_TYPE: Severity of the error (FATAL in this case)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
------
1. Checks for null values in VISIT_CONCEPT_ID field
2. Counts occurrences of null values
3. Compares raw and clean table record counts
4. Returns error details if null values are found

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
Use of this code is at your own risk and responsibility.
*********************************************************/