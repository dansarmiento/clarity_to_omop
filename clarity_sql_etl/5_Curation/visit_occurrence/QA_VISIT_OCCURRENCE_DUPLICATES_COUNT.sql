/*********************************************************
Script Name: QA_VISIT_OCCURRENCE_DUPLICATES_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

---------------------------------------------------------------------
-- Identify duplicate records in VISIT_OCCURRENCE_RAW
WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,VISIT_CONCEPT_ID
        ,VISIT_START_DATE
        ,VISIT_START_DATETIME
        ,VISIT_END_DATE
        ,VISIT_END_DATETIME
        ,VISIT_TYPE_CONCEPT_ID
        ,PROVIDER_ID
        ,CARE_SITE_ID
        ,phi_CSN_ID
        ,VISIT_SOURCE_CONCEPT_ID
        ,ADMITTED_FROM_CONCEPT_ID
        ,ADMITTED_FROM_SOURCE_VALUE
        ,DISCHARGED_TO_CONCEPT_ID
        ,DISCHARGED_TO_SOURCE_VALUE
        ,PRECEDING_VISIT_OCCURRENCE_ID
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    GROUP BY PERSON_ID
        ,VISIT_CONCEPT_ID
        ,VISIT_START_DATE
        ,VISIT_START_DATETIME
        ,VISIT_END_DATE
        ,VISIT_END_DATETIME
        ,VISIT_TYPE_CONCEPT_ID
        ,PROVIDER_ID
        ,CARE_SITE_ID
        ,phi_CSN_ID
        ,VISIT_SOURCE_CONCEPT_ID
        ,ADMITTED_FROM_CONCEPT_ID
        ,ADMITTED_FROM_SOURCE_VALUE
        ,DISCHARGED_TO_CONCEPT_ID
        ,DISCHARGED_TO_SOURCE_VALUE
        ,PRECEDING_VISIT_OCCURRENCE_ID
    HAVING COUNT(*) > 1
)

-- Generate QA metrics report
SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    , 'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE
    , 'DUPLICATE' AS QA_METRIC
    , 'RECORDS'  AS METRIC_FIELD
    , COALESCE(SUM(CNT),0) AS QA_ERRORS
    , CASE WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' ELSE NULL END AS ERROR_TYPE
    , (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW) AS TOTAL_RECORDS
    , (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being evaluated
QA_ERRORS: Number of duplicate records found
ERROR_TYPE: Severity of the error (FATAL if duplicates exist)
TOTAL_RECORDS: Total number of records in raw table
TOTAL_RECORDS_CLEAN: Total number of records in clean table

Logic:
------
1. Creates temporary result set identifying duplicate records
2. Groups by all relevant fields to find exact matches
3. Counts instances where multiple records share identical values
4. Generates summary report of duplicate records found

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. In no event shall the author be liable for any
damages whatsoever arising out of the use or inability to use
this code.
*********************************************************/