/*******************************************************************************
* Script Name: QA_CARE_SITE_DUPLICATES_COUNT
* Description: This query identifies and counts duplicate records in CARE_SITE_RAW
*              table based on specific columns combination.
* 
* Tables Used: CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW
*              CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE
*
* Output: Returns a single row with QA metrics
*******************************************************************************/

-- Temporary CTE to identify duplicate records
WITH TMP_DUPES AS (
    SELECT  PLACE_OF_SERVICE_CONCEPT_ID, 
            LOCATION_ID, 
            PLACE_OF_SERVICE_SOURCE_VALUE,
            CARE_SITE_NAME, 
            CARE_SITE_SOURCE_VALUE,
            COUNT(*) AS CNT
    FROM    CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW AS T1
    GROUP BY PLACE_OF_SERVICE_CONCEPT_ID, 
             LOCATION_ID, 
             PLACE_OF_SERVICE_SOURCE_VALUE,
             CARE_SITE_NAME, 
             CARE_SITE_SOURCE_VALUE
    HAVING  COUNT(*) > 1
)

-- Main query to generate QA metrics
SELECT 
    CAST(GETDATE() AS DATE)    AS RUN_DATE,
    'CARE_SITE'                AS STANDARD_DATA_TABLE,
    'DUPLICATE'                AS QA_METRIC,
    'RECORDS'                  AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0)     AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' 
        ELSE NULL 
    END                        AS ERROR_TYPE,
    (SELECT COUNT(*) 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW) 
                               AS TOTAL_RECORDS,
    (SELECT COUNT(*) 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE) 
                               AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Current date when the QA check is performed
* STANDARD_DATA_TABLE: Name of the table being checked
* QA_METRIC: Type of quality check being performed (DUPLICATE)
* METRIC_FIELD: Specifies what is being counted (RECORDS)
* QA_ERRORS: Number of duplicate records found
* ERROR_TYPE: Classification of error severity (FATAL if duplicates exist)
* TOTAL_RECORDS: Total count of records in the raw table
* TOTAL_RECORDS_CLEAN: Total count of records in the clean table
*
* Logic:
* ------
* 1. TMP_DUPES CTE:
*    - Groups records by key fields
*    - Identifies groups with more than one record (duplicates)
*    - Counts number of records in each duplicate group
*
* 2. Main Query:
*    - Aggregates duplicate counts
*    - Adds metadata about the QA check
*    - Compares raw vs clean table record counts
*    - Marks duplicates as FATAL errors

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/