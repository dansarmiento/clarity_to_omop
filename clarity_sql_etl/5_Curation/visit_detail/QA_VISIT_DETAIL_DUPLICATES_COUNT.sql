/*********************************************************
Script Name: QA_VISIT_DETAIL_DUPLICATES_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,VISIT_DETAIL_CONCEPT_ID
        ,VISIT_DETAIL_START_DATE
        ,VISIT_DETAIL_START_DATETIME
        ,VISIT_DETAIL_END_DATE
        ,VISIT_DETAIL_END_DATETIME
        ,VISIT_DETAIL_TYPE_CONCEPT_ID
        ,PROVIDER_ID
        ,CARE_SITE_ID
        ,VISIT_DETAIL_SOURCE_VALUE
        ,VISIT_DETAIL_SOURCE_CONCEPT_ID
        ,ADMITTED_FROM_CONCEPT_ID
        ,ADMITTED_FROM_SOURCE_VALUE
        ,DISCHARGED_TO_CONCEPT_ID
        ,DISCHARGED_TO_SOURCE_VALUE
        ,PRECEDING_VISIT_DETAIL_ID
        ,VISIT_OCCURRENCE_ID
        ,COUNT(*) AS COUNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    GROUP BY PERSON_ID
        ,VISIT_DETAIL_CONCEPT_ID
        ,VISIT_DETAIL_START_DATE
        ,VISIT_DETAIL_START_DATETIME
        ,VISIT_DETAIL_END_DATE
        ,VISIT_DETAIL_END_DATETIME
        ,VISIT_DETAIL_TYPE_CONCEPT_ID
        ,PROVIDER_ID
        ,CARE_SITE_ID
        ,VISIT_DETAIL_SOURCE_VALUE
        ,VISIT_DETAIL_SOURCE_CONCEPT_ID
        ,ADMITTED_FROM_CONCEPT_ID
        ,ADMITTED_FROM_SOURCE_VALUE
        ,DISCHARGED_TO_CONCEPT_ID
        ,DISCHARGED_TO_SOURCE_VALUE
        ,PRECEDING_VISIT_DETAIL_ID
        ,VISIT_OCCURRENCE_ID
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'VISIT_DETAIL' AS STANDARD_DATA_TABLE
    ,'DUPLICATE' AS QA_METRIC
    ,'RECORDS' AS METRIC_FIELD
    ,COALESCE(SUM(COUNT),0) AS QA_ERRORS
    ,CASE WHEN SUM(COUNT) IS NOT NULL THEN 'FATAL' ELSE NULL END AS ERROR_TYPE
    ,(SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW) AS TOTAL_RECORDS
    ,(SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

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
1. Creates temporary table of duplicate records by grouping on all fields
2. Counts instances where identical records appear more than once
3. Returns summary statistics about duplicate records

Legal Warning:
-------------
This code is provided as-is without any implied warranty.
Use at your own risk. No guarantee of accuracy or suitability
for any particular purpose is provided.
*********************************************************/