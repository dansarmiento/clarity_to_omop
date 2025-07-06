/*******************************************************
Script Name: QA_NOTE_NOVISIT_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************/

/*
This script checks for notes that do not have an associated visit_occurrence_id
in the VISIT_OCCURRENCE table and reports counts of these orphaned records.

Tables Used:
- NOTE_RAW - Contains raw clinical notes data
- VISIT_OCCURRENCE_RAW - Contains raw visit/encounter data
- NOTE - Contains cleaned/standardized notes
*/

WITH NOVISIT_COUNT AS (
  SELECT 
    'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
    'NO VISIT' AS QA_METRIC, 
    'WARNING' AS ERROR_TYPE,
    COUNT(*) AS CNT
  FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
  LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
    ON NOTE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
  WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
  CAST(GETDATE() AS DATE) AS RUN_DATE,
  'NOTE' AS STANDARD_DATA_TABLE,
  QA_METRIC AS QA_METRIC,
  METRIC_FIELD AS METRIC_FIELD,
  COALESCE(SUM(CNT),0) AS QA_ERRORS,
  CASE 
    WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
    ELSE NULL 
  END AS ERROR_TYPE,
  (SELECT COUNT(*) AS NUM_ROWS 
   FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW) AS TOTAL_RECORDS,
  (SELECT COUNT(*) AS NUM_ROWS 
   FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE) AS TOTAL_RECORDS_CLEAN
FROM NOVISIT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
Column Descriptions:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked
- QA_METRIC: Description of the quality check being performed
- METRIC_FIELD: Field being evaluated
- QA_ERRORS: Count of records failing the quality check
- ERROR_TYPE: Severity level of the error
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
1. Identifies notes without matching visit records using LEFT JOIN
2. Counts orphaned records
3. Returns summary metrics including error counts and totals

Legal Warning:
This code is provided as-is without warranty of any kind, either express or implied.
Use of this code is at your own risk. The author and organization accept no liability
for any damages or losses resulting from its use.
*/