/*********************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_DATEVDATETIME_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

/*
This query performs quality assurance checks on the PROCEDURE_OCCURRENCE table
by comparing PROCEDURE_DATE against PROCEDURE_DATETIME fields.
*/

WITH DATEVDATETIME_COUNT AS (
    SELECT 
        'PROCEDURE_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (PROCEDURE_DATE <> CAST(PROCEDURE_DATETIME AS DATE)) THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS T1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM DATEVDATETIME_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Field being evaluated
- QA_ERRORS: Count of records with discrepancies
- ERROR_TYPE: Severity of the error found
- TOTAL_RECORDS: Count of records in the raw table
- TOTAL_RECORDS_CLEAN: Count of records in the clean table

LOGIC:
1. Creates a CTE to count mismatches between PROCEDURE_DATE and PROCEDURE_DATETIME
2. Joins results with record counts from both raw and clean tables
3. Returns summary of QA check results

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code 
remains with you. In no event shall the author be liable for any 
damages whatsoever arising out of the use of or inability to use 
this code.
*/