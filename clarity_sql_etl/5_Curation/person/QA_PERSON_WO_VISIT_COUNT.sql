/*********************************************************
Script Name: QA_PERSON_WO_VISIT_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Identifies persons without associated visits in OMOP
**********************************************************/

WITH TMP_WO_VISIT AS (
    SELECT COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS PERSON_RAW
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE_RAW
        ON PERSON_RAW.person_ID = VISIT_OCCURRENCE_RAW.PERSON_ID
    WHERE VISIT_OCCURRENCE_RAW.PERSON_ID IS NULL
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    'WO_VISIT' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON) AS TOTAL_RECORDS_CLEAN
FROM TMP_WO_VISIT;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the primary table being checked
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being evaluated
QA_ERRORS: Number of records failing the quality check
ERROR_TYPE: Severity of the error (FATAL in this case)
TOTAL_RECORDS: Total number of records in the raw person table
TOTAL_RECORDS_CLEAN: Total number of records in the clean person table

Logic:
------
1. Creates temporary table counting persons without visits
2. Joins PERSON_RAW with VISIT_OCCURRENCE_RAW
3. Identifies records where no matching visit exists
4. Returns summary statistics and error counts

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
Use at your own risk. The author and organization assume no
responsibility for any issues arising from its use.
*********************************************************/