/***************************************************************
Script Name: QA_PERSON_DUPLICATES_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script identifies and counts duplicate records in the PERSON_RAW table
            based on matching demographic and identifying information.
****************************************************************/

WITH TMP_DUPES AS (
    SELECT
        GENDER_CONCEPT_ID,
        YEAR_OF_BIRTH,
        MONTH_OF_BIRTH,
        DAY_OF_BIRTH,
        BIRTH_DATETIME,
        RACE_CONCEPT_ID,
        ETHNICITY_CONCEPT_ID,
        LOCATION_ID,
        PROVIDER_ID,
        CARE_SITE_ID,
        PERSON_SOURCE_VALUE,
        GENDER_SOURCE_VALUE,
        GENDER_SOURCE_CONCEPT_ID,
        RACE_SOURCE_VALUE,
        RACE_SOURCE_CONCEPT_ID,
        ETHNICITY_SOURCE_VALUE,
        ETHNICITY_SOURCE_CONCEPT_ID,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    GROUP BY  
        GENDER_CONCEPT_ID,
        YEAR_OF_BIRTH,
        MONTH_OF_BIRTH,
        DAY_OF_BIRTH,
        BIRTH_DATETIME,
        RACE_CONCEPT_ID,
        ETHNICITY_CONCEPT_ID,
        LOCATION_ID,
        PROVIDER_ID,
        CARE_SITE_ID,
        PERSON_SOURCE_VALUE,
        GENDER_SOURCE_VALUE,
        GENDER_SOURCE_CONCEPT_ID,
        RACE_SOURCE_VALUE,
        RACE_SOURCE_CONCEPT_ID,
        ETHNICITY_SOURCE_VALUE,
        ETHNICITY_SOURCE_CONCEPT_ID
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/***************************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being evaluated
QA_ERRORS: Number of duplicate records found
ERROR_TYPE: Severity of the error (FATAL if duplicates exist)
TOTAL_RECORDS: Total number of records in PERSON_RAW table
TOTAL_RECORDS_CLEAN: Total number of records in cleaned PERSON table

Logic:
------
1. Creates temporary result set (TMP_DUPES) identifying records with identical 
   demographic and identifying information
2. Groups by all relevant fields to find exact matches
3. Counts instances where multiple records share identical information
4. Returns summary statistics about duplicate records found

Legal Warning:
-------------
This code is provided as-is without any implied warranty. 
Use at your own risk. The author and organization assume no liability 
for any issues arising from the use of this code.
****************************************************************/