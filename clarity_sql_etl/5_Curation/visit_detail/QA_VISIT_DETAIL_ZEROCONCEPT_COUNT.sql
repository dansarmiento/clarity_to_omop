/*********************************************************
Script Name: QA_VISIT_DETAIL_ZEROCONCEPT_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Quality assurance check for zero concepts in VISIT_DETAIL table
**********************************************************/

WITH ZEROCONCEPT_COUNT AS (
    SELECT 
        'VISIT_DETAIL_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE (VISIT_DETAIL_CONCEPT_ID = 0)
    
    UNION ALL
    
    SELECT 
        'VISIT_DETAIL_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE (VISIT_DETAIL_TYPE_CONCEPT_ID = 0)
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
FROM ZEROCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being checked
QA_ERRORS: Count of records failing the QA check
ERROR_TYPE: Severity of the error (WARNING/ERROR)
TOTAL_RECORDS: Total number of records in RAW table
TOTAL_RECORDS_CLEAN: Total number of records in clean table

LOGIC:
------
1. Checks for zero concepts in VISIT_DETAIL_CONCEPT_ID
2. Checks for zero concepts in VISIT_DETAIL_TYPE_CONCEPT_ID
3. Compares raw vs clean record counts
4. Flags zero concepts as warnings

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code
remains with you. In no event shall the author be liable for any
damages whatsoever arising out of the use of or inability to use
this code.
*********************************************************/