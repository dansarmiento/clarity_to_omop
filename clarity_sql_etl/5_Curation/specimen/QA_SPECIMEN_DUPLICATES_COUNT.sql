/*********************************************************
 * Script Name: QA_SPECIMEN_DUPLICATES_COUNT.sql
 * Author: Roger J Carlson - Corewell Health
 * Date: June 2025
 * 
 * Purpose: Identifies and counts duplicate records in the SPECIMEN_RAW table
 *********************************************************/

WITH TMP_DUPES AS (
    SELECT    PERSON_ID
            , SPECIMEN_CONCEPT_ID
            , SPECIMEN_TYPE_CONCEPT_ID
            , SPECIMEN_DATE
            , SPECIMEN_DATETIME
            , QUANTITY
            , UNIT_CONCEPT_ID
            , ANATOMIC_SITE_CONCEPT_ID
            , DISEASE_STATUS_CONCEPT_ID
            , SPECIMEN_SOURCE_ID
            , SPECIMEN_SOURCE_VALUE
            , UNIT_SOURCE_VALUE
            , ANATOMIC_SITE_SOURCE_VALUE
            , DISEASE_STATUS_SOURCE_VALUE
            , COUNT(*) AS CNT

    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS T1
    GROUP BY  PERSON_ID
            , SPECIMEN_CONCEPT_ID
            , SPECIMEN_TYPE_CONCEPT_ID
            , SPECIMEN_DATE
            , SPECIMEN_DATETIME
            , QUANTITY
            , UNIT_CONCEPT_ID
            , ANATOMIC_SITE_CONCEPT_ID
            , DISEASE_STATUS_CONCEPT_ID
            , SPECIMEN_SOURCE_ID
            , SPECIMEN_SOURCE_VALUE
            , UNIT_SOURCE_VALUE
            , ANATOMIC_SITE_SOURCE_VALUE
            , DISEASE_STATUS_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    , 'SPECIMEN' AS STANDARD_DATA_TABLE
    , 'DUPLICATE' AS QA_METRIC
    , 'RECORDS'  AS METRIC_FIELD
    , COALESCE(SUM(CNT),0) AS QA_ERRORS
    , CASE WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' ELSE NULL END AS ERROR_TYPE
    , (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW) AS TOTAL_RECORDS
    , (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*********************************************************
 * Column Descriptions:
 * RUN_DATE - Date the query was executed
 * STANDARD_DATA_TABLE - Name of the table being analyzed
 * QA_METRIC - Type of quality check being performed
 * METRIC_FIELD - Field being evaluated
 * QA_ERRORS - Count of duplicate records found
 * ERROR_TYPE - Severity of the error (FATAL if duplicates exist)
 * TOTAL_RECORDS - Total count of records in SPECIMEN_RAW
 * TOTAL_RECORDS_CLEAN - Total count of records in SPECIMEN
 *
 * Logic:
 * 1. Creates temporary result set of duplicate records
 * 2. Groups by all relevant fields to identify exact duplicates
 * 3. Counts instances where identical records appear more than once
 * 4. Returns summary statistics including error counts and totals
 *
 * Legal Warning:
 * This code is provided as-is without any implied warranty.
 * Use at your own risk. The author and organization assume no
 * liability for the use or misuse of this code.
 *********************************************************/