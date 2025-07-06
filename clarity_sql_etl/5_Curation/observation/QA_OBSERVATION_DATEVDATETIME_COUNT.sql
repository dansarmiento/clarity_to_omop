/*********************************************************
Script Name: QA_OBSERVATION_DATEVDATETIME_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

/*
Description: This script performs quality assurance checks on the OBSERVATION table
by comparing OBSERVATION_DATE against OBSERVATION_DATETIME fields
*/

WITH DATEVDATETIME_COUNT AS (
    SELECT 
        'OBSERVATION_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (OBSERVATION_DATE <> CAST(OBSERVATION_DATETIME AS DATE)) THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS T1
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
FROM DATEVDATETIME_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being analyzed
QA_ERRORS: Count of records with discrepancies
ERROR_TYPE: Classification of the error (WARNING in this case)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
------
1. Compares OBSERVATION_DATE with OBSERVATION_DATETIME cast as DATE
2. Counts instances where these dates don't match
3. Provides summary statistics including total record counts

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
Use of this code is at your own risk and responsibility.
No implied warranty for a particular purpose or functionality is provided.
*/