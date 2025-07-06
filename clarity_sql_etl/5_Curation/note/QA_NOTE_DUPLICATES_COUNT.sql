/*******************************************************
* QA_NOTE_DUPLICATES_COUNT
* Identifies duplicate records in the NOTE_RAW table
*******************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID
         , NOTE_DATE
         , NOTE_DATETIME 
         , NOTE_TYPE_CONCEPT_ID
         , NOTE_CLASS_CONCEPT_ID
         , NOTE_TITLE
         , NOTE_TEXT
         , ENCODING_CONCEPT_ID
         , LANGUAGE_CONCEPT_ID
         , PROVIDER_ID
         , VISIT_OCCURRENCE_ID
         , NOTE_SOURCE_VALUE
         , COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS T1
    GROUP BY PERSON_ID
           , NOTE_DATE
           , NOTE_DATETIME
           , NOTE_TYPE_CONCEPT_ID 
           , NOTE_CLASS_CONCEPT_ID
           , NOTE_TITLE
           , NOTE_TEXT
           , ENCODING_CONCEPT_ID
           , LANGUAGE_CONCEPT_ID
           , PROVIDER_ID
           , VISIT_OCCURRENCE_ID
           , NOTE_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
     , 'NOTE' AS STANDARD_DATA_TABLE  
     , 'DUPLICATE' AS QA_METRIC
     , 'RECORDS' AS METRIC_FIELD
     , COALESCE(SUM(CNT),0) AS QA_ERRORS
     , CASE WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' ELSE NULL END AS ERROR_TYPE
     , (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW) AS TOTAL_RECORDS
     , (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*******************************************************
* Column Descriptions:
* RUN_DATE - Date QA check was executed
* STANDARD_DATA_TABLE - Name of table being checked
* QA_METRIC - Type of QA check (duplicate records)
* METRIC_FIELD - Field being checked
* QA_ERRORS - Count of duplicate records found
* ERROR_TYPE - FATAL if duplicates found, NULL if no duplicates
* TOTAL_RECORDS - Total count of records in NOTE_RAW table
* TOTAL_RECORDS_CLEAN - Total count of records in NOTE table

* Logic:
* 1. CTE finds records that appear more than once in NOTE_RAW table
*    based on all fields except NOTE_ID
* 2. Main query returns QA metrics including:
*    - Count of duplicate records found
*    - Error type (FATAL if duplicates exist)
*    - Total record counts for raw and clean tables

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************/