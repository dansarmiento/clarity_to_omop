/*********************************************************
Script Name: QA_SPECIMEN_NULLCONCEPT_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Quality assurance check for null concepts in SPECIMEN table
*********************************************************/

WITH NULLCONCEPT_COUNT
AS (
    -- Check for null SPECIMEN_CONCEPT_ID
    SELECT 
        'SPECIMEN_CONCEPT_ID' AS METRIC_FIELD, 
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SPECIMEN
    WHERE (SPECIMEN_CONCEPT_ID IS NULL)

    UNION ALL

    -- Check for null ANATOMIC_SITE_CONCEPT_ID
    SELECT 
        'ANATOMIC_SITE_CONCEPT_ID' AS METRIC_FIELD, 
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SPECIMEN
    WHERE (ANATOMIC_SITE_CONCEPT_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'SPECIMEN' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN) AS TOTAL_RECORDS_CLEAN
FROM NULLCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being checked for nulls
QA_ERRORS: Count of records with null values
ERROR_TYPE: Severity of the error (FATAL in this case)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
------
1. Checks for null values in SPECIMEN_CONCEPT_ID and ANATOMIC_SITE_CONCEPT_ID
2. Counts occurrences of null values for each field
3. Compares raw and clean table record counts
4. Returns summary of QA metrics

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code
remains with you. Use at your own risk.
*********************************************************/