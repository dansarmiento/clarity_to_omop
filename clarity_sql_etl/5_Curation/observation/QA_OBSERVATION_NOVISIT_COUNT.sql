/*********************************************************
Script Name: QA_OBSERVATION_NOVISIT_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Purpose: Identifies and counts OBSERVATION records without 
         corresponding VISIT_OCCURRENCE records
**********************************************************/

WITH NOVISIT_COUNT AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD, 
        'NO VISIT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON OBSERVATION.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
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
FROM NOVISIT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Description of the quality check performed
METRIC_FIELD: Field being evaluated
QA_ERRORS: Count of records failing the quality check
ERROR_TYPE: Severity of the quality issue
TOTAL_RECORDS: Total count of records in raw table
TOTAL_RECORDS_CLEAN: Total count of records in clean table

LOGIC:
------
1. Identifies OBSERVATION records without matching VISIT_OCCURRENCE
2. Counts these orphaned records
3. Provides comparison between raw and clean record counts

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the
code remains with you. In no event shall the author be liable
for any damages whatsoever arising out of the use of or inability
to use this code.
*********************************************************/