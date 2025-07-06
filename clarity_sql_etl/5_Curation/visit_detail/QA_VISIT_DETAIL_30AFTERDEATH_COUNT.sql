/*********************************************************
Script Name: QA_VISIT_DETAIL_30AFTERDEATH_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Identifies visit details recorded more than 30 days after death
**********************************************************/

WITH VISIT30AFTERDEATH_COUNT AS (
    SELECT 
        'VISIT_DETAIL_START_DATE' AS METRIC_FIELD, 
        '30AFTERDEATH' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (DATEDIFF(DAY, DEATH_DATE, VISIT_DETAIL_START_DATE) > 30) 
            THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
)

SELECT 
    CAST(GETDATE()AS DATE) AS RUN_DATE,
    'VISIT_DETAIL' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 
        THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL) AS TOTAL_RECORDS_CLEAN
FROM VISIT30AFTERDEATH_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of QA check being performed
METRIC_FIELD: Field being evaluated
QA_ERRORS: Count of records failing the QA check
ERROR_TYPE: Description of the error type
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
------
1. Identifies visit details that occurred more than 30 days after a patient's death
2. Joins VISIT_DETAIL_RAW with DEATH_RAW on PERSON_ID
3. Calculates the difference between visit date and death date
4. Counts instances where this difference exceeds 30 days

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind, either express or implied,
including without limitation any implied warranties of condition, uninterrupted use,
merchantability, fitness for a particular purpose, or non-infringement.
Use at your own risk.
*********************************************************/