/*********************************************************
* Script Name: QA_OBSERVATION_30AFTERDEATH_COUNT.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: This script identifies observations recorded more than 
* 30 days after a patient's death date in the OMOP database.
*********************************************************/

WITH OBSERVATION30AFTERDEATH_COUNT AS (
    SELECT 
        'OBSERVATION_DATE' AS METRIC_FIELD, 
        '30AFTERDEATH' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (DATEDIFF(DAY, DEATH_DATE, OBSERVATION_DATE) > 30) THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'OBSERVATION' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION) AS TOTAL_RECORDS_CLEAN
FROM OBSERVATION30AFTERDEATH_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being analyzed
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Field being evaluated
* - QA_ERRORS: Count of records failing the quality check
* - ERROR_TYPE: Description of the error type
* - TOTAL_RECORDS: Total number of records in raw table
* - TOTAL_RECORDS_CLEAN: Total number of records in clean table
*
* Logic:
* 1. Identifies observations recorded > 30 days after death
* 2. Counts invalid records through person_id matching
* 3. Compares raw and clean table record counts
*
* Legal Warning:
* This code is provided as-is without any implied warranty.
* Use at your own risk. No guarantee of accuracy or fitness
* for any particular purpose is provided.
*********************************************************/