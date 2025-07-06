/*********************************************************
Script Name: QA_VISIT_DETAIL_NULLFK_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Quality assurance check for null foreign keys in VISIT_DETAIL table
**********************************************************/

WITH NULLFK_COUNT AS (
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE (PERSON_ID IS NULL)

    UNION ALL
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE (VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_DETAIL' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL) AS TOTAL_RECORDS_CLEAN
FROM NULLFK_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being evaluated for null values
QA_ERRORS: Count of records with null values
ERROR_TYPE: Severity of the error (WARNING/EXPECTED)
TOTAL_RECORDS: Total number of records in raw table
TOTAL_RECORDS_CLEAN: Total number of records in clean table

Logic:
------
1. Checks for null values in foreign key fields (PERSON_ID, VISIT_OCCURRENCE_ID)
2. Counts occurrences of null values
3. Compares raw and clean table record counts
4. Flags warnings for unexpected null values

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Use at your own risk.
*********************************************************/