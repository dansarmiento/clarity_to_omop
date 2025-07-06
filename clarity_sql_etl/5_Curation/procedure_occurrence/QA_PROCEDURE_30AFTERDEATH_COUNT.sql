/*********************************************************
Script Name: QA_PROCEDURE_30AFTERDEATH_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: Identifies procedures recorded more than 30 days after death
**********************************************************/

WITH PROCEDURE30AFTERDEATH_COUNT AS (
SELECT 
    'PROCEDURE_DATE' AS METRIC_FIELD,
    '30AFTERDEATH' AS QA_METRIC, 
    'INVALID DATA' AS ERROR_TYPE,
    SUM(CASE WHEN (DATEDIFF(DAY, DEATH_DATE, PROCEDURE_DATE) > 30) THEN 1 ELSE 0 END) AS CNT
FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS T1
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
    ON T1.PERSON_ID = T2.PERSON_ID
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 
         THEN ERROR_TYPE 
         ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM PROCEDURE30AFTERDEATH_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of QA check being performed
- METRIC_FIELD: Field being evaluated
- QA_ERRORS: Count of records failing the QA check
- ERROR_TYPE: Description of the error found
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
1. Identifies procedures recorded >30 days after patient death
2. Joins procedure and death tables on person_id
3. Calculates days between death and procedure dates
4. Counts records where difference >30 days

Legal Warning:
This code is provided as-is without any implied warranty.
Use at your own risk. No guarantee of fitness for any 
particular purpose is provided.
*********************************************************/