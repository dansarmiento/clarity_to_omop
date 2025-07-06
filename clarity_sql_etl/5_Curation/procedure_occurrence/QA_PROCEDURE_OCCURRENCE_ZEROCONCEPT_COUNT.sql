/*********************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_ZEROCONCEPT_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: Quality assurance check for zero concepts in PROCEDURE_OCCURRENCE table
*********************************************************/

WITH ZEROCONCEPT_COUNT
AS (
    -- Check for zero concepts in PROCEDURE_CONCEPT_ID
    SELECT 'PROCEDURE_CONCEPT_ID' AS METRIC_FIELD, 
           'ZERO CONCEPT' AS QA_METRIC, 
           'WARNING' AS ERROR_TYPE, 
           COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (PROCEDURE_CONCEPT_ID = 0)

    UNION ALL

    -- Check for zero concepts in PROCEDURE_TYPE_CONCEPT_ID
    SELECT 'PROCEDURE_TYPE_CONCEPT_ID' AS METRIC_FIELD, 
           'ZERO CONCEPT' AS QA_METRIC, 
           'WARNING' AS ERROR_TYPE, 
           COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (PROCEDURE_TYPE_CONCEPT_ID = 0)

    UNION ALL

    -- Check for invalid MODIFIER_CONCEPT_ID (zero with non-null source value)
    SELECT 'MODIFIER_CONCEPT_ID' AS METRIC_FIELD, 
           'ZERO CONCEPT' AS QA_METRIC, 
           'WARNING' AS ERROR_TYPE, 
           COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (MODIFIER_CONCEPT_ID = 0 AND MODIFIER_SOURCE_VALUE IS NOT NULL)
)

-- Final result set
SELECT CAST(GETDATE() AS DATE) AS RUN_DATE,
       'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
       QA_METRIC AS QA_METRIC,
       METRIC_FIELD AS METRIC_FIELD,
       COALESCE(SUM(CNT),0) AS QA_ERRORS,
       CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
       (SELECT COUNT(*) AS NUM_ROWS 
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS,
       (SELECT COUNT(*) AS NUM_ROWS 
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM ZEROCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being analyzed
QA_ERRORS: Count of records failing the QA check
ERROR_TYPE: Severity of the error (WARNING in this case)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
------
1. Checks for zero concepts in PROCEDURE_CONCEPT_ID
2. Checks for zero concepts in PROCEDURE_TYPE_CONCEPT_ID
3. Checks for invalid MODIFIER_CONCEPT_ID (zero with non-null source value)
4. Aggregates results with relevant metadata

Legal Warning:
-------------
This code is provided as-is without any implied warranty.
Use at your own risk. No guarantee of accuracy or completeness is given or implied.
*********************************************************/