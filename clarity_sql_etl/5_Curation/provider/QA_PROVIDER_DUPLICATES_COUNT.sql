/*********************************************************
Script Name: QA_PROVIDER_DUPLICATES_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Identifies and counts duplicate provider records in PROVIDER_RAW table
*********************************************************/

WITH TMP_DUPES AS (
    SELECT PROVIDER_NAME
        ,NPI
        ,DEA
        ,SPECIALTY_CONCEPT_ID
        ,CARE_SITE_ID
        ,YEAR_OF_BIRTH
        ,GENDER_CONCEPT_ID
        ,PROVIDER_SOURCE_VALUE
        ,SPECIALTY_SOURCE_VALUE
        ,SPECIALTY_SOURCE_CONCEPT_ID
        ,GENDER_SOURCE_VALUE
        ,GENDER_SOURCE_CONCEPT_ID
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    GROUP BY PROVIDER_NAME
        ,NPI
        ,DEA
        ,SPECIALTY_CONCEPT_ID
        ,CARE_SITE_ID
        ,YEAR_OF_BIRTH
        ,GENDER_CONCEPT_ID
        ,PROVIDER_SOURCE_VALUE
        ,SPECIALTY_SOURCE_VALUE
        ,SPECIALTY_SOURCE_CONCEPT_ID
        ,GENDER_SOURCE_VALUE
        ,GENDER_SOURCE_CONCEPT_ID
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'PROVIDER' AS STANDARD_DATA_TABLE
    ,'DUPLICATE' AS QA_METRIC
    ,'RECORDS' AS METRIC_FIELD
    ,COALESCE(SUM(CNT),0) AS QA_ERRORS
    ,CASE WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' ELSE NULL END AS ERROR_TYPE
    ,(SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW) AS TOTAL_RECORDS
    ,(SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being evaluated
QA_ERRORS: Number of duplicate records found
ERROR_TYPE: Severity of the error (FATAL if duplicates exist)
TOTAL_RECORDS: Total number of records in PROVIDER_RAW
TOTAL_RECORDS_CLEAN: Total number of records in PROVIDER table

LOGIC:
------
1. CTE identifies duplicate records by grouping on all relevant provider fields
2. Main query summarizes duplicate counts and adds metadata
3. Compares raw vs. clean table record counts

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code
remains with you. Use at your own risk.
*********************************************************/