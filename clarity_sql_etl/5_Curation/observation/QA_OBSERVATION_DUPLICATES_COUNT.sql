/*******************************************************************************
Script Name: QA_OBSERVATION_DUPLICATES_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script identifies and counts duplicate records in the OBSERVATION_RAW 
table based on specific column combinations.

********************************************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,OBSERVATION_CONCEPT_ID
        ,OBSERVATION_DATE
        ,OBSERVATION_DATETIME
        ,OBSERVATION_TYPE_CONCEPT_ID
        ,VALUE_AS_NUMBER
        ,VALUE_AS_STRING
        ,VALUE_AS_CONCEPT_ID
        ,QUALIFIER_CONCEPT_ID
        ,UNIT_CONCEPT_ID
        ,PROVIDER_ID
        ,VISIT_OCCURRENCE_ID
        ,OBSERVATION_SOURCE_VALUE
        ,OBSERVATION_SOURCE_CONCEPT_ID
        ,UNIT_SOURCE_VALUE
        ,QUALIFIER_SOURCE_VALUE
        ,src_VALUE_ID
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS T1
    WHERE T1.OBSERVATION_CONCEPT_ID <> 0
        AND T1.OBSERVATION_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID <> 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY PERSON_ID
        ,OBSERVATION_CONCEPT_ID
        ,OBSERVATION_DATE
        ,OBSERVATION_DATETIME
        ,OBSERVATION_TYPE_CONCEPT_ID
        ,VALUE_AS_NUMBER
        ,VALUE_AS_STRING
        ,VALUE_AS_CONCEPT_ID
        ,QUALIFIER_CONCEPT_ID
        ,UNIT_CONCEPT_ID
        ,PROVIDER_ID
        ,VISIT_OCCURRENCE_ID
        ,OBSERVATION_SOURCE_VALUE
        ,OBSERVATION_SOURCE_CONCEPT_ID
        ,UNIT_SOURCE_VALUE
        ,QUALIFIER_SOURCE_VALUE
        ,src_VALUE_ID
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    , 'OBSERVATION' AS STANDARD_DATA_TABLE
    , 'DUPLICATE' AS QA_METRIC
    , 'RECORDS'  AS METRIC_FIELD
    , COALESCE(SUM(CNT),0) AS QA_ERRORS
    , CASE WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' ELSE NULL END AS ERROR_TYPE
    , (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW) AS TOTAL_RECORDS
    , (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*******************************************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being measured
QA_ERRORS: Number of duplicate records found
ERROR_TYPE: Severity of the error
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
------
1. Creates a CTE to identify duplicate records based on all relevant columns
2. Counts instances where exact matches occur more than once
3. Returns summary statistics about the duplicates found

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind, either express or 
implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/