/*********************************************************
Script Name: QA_SPECIMEN_DATEVDATETIME_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Purpose: Validates specimen dates against datetime values
**********************************************************/

WITH DATEVDATETIME_COUNT AS (
    SELECT 
        'SPECIMEN_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (SPECIMEN_DATE <> CAST(SPECIMEN_DATETIME AS DATE)) THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS T1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'SPECIMEN' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN) AS TOTAL_RECORDS_CLEAN
FROM DATEVDATETIME_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being validated
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being validated
QA_ERRORS: Count of records with validation errors
ERROR_TYPE: Classification of the error (WARNING/ERROR)
TOTAL_RECORDS: Total count of records in raw table
TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
------
1. Creates CTE to count mismatches between SPECIMEN_DATE and 
   SPECIMEN_DATETIME
2. Compares dates and returns warning if they don't match
3. Includes record counts from both raw and clean tables

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk of use or results from the use of this code
remains with the user. Use at your own risk.
*********************************************************/