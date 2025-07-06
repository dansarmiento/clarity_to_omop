/*********************************************************
Script Name: QA_VISIT_OCCURRENCE_ZEROCONCEPT_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Quality assurance check for zero concepts in VISIT_OCCURRENCE table
**********************************************************/

WITH ZEROCONCEPT_COUNT AS (
    SELECT 
        'VISIT_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    WHERE (VISIT_CONCEPT_ID = 0)
    
    UNION ALL
    
    SELECT 
        'VISIT_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    WHERE (VISIT_TYPE_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM ZEROCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being analyzed for zero concepts
QA_ERRORS: Count of records with zero concepts
ERROR_TYPE: Indication of error severity
TOTAL_RECORDS: Total number of records in raw table
TOTAL_RECORDS_CLEAN: Total number of records in clean table

LOGIC:
------
1. Counts occurrences of zero concepts in VISIT_CONCEPT_ID
2. Counts occurrences of zero concepts in VISIT_TYPE_CONCEPT_ID
3. Combines results with metadata about the analysis

LEGAL WARNING:
-------------
This code is provided as-is without any implied warranty.
Use at your own risk. No guarantee of accuracy or completeness
is expressed or implied.
*********************************************************/