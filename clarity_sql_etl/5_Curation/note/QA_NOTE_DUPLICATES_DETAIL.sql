/***************************************************************
 * Script: QA_NOTE_DUPLICATES_DETAIL.sql
 * Purpose: Identifies duplicate records in the NOTE_RAW table
 ***************************************************************/

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
     , 'FATAL' AS ERROR_TYPE
     , NT.NOTE_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NT 
    ON D.PERSON_ID = NT.PERSON_ID
    AND D.NOTE_DATE = NT.NOTE_DATE
    AND COALESCE(D.NOTE_DATETIME,'1900-01-01') = COALESCE(NT.NOTE_DATETIME,'1900-01-01')
    AND COALESCE(D.NOTE_TYPE_CONCEPT_ID, 0) = COALESCE(NT.NOTE_TYPE_CONCEPT_ID, 0)
    AND COALESCE(D.NOTE_CLASS_CONCEPT_ID, 0) = COALESCE(NT.NOTE_CLASS_CONCEPT_ID, 0) 
    AND COALESCE(D.NOTE_TITLE, '0') = COALESCE(NT.NOTE_TITLE, '0')
    AND COALESCE(D.NOTE_TEXT, '0') = COALESCE(NT.NOTE_TEXT, '0')
    AND COALESCE(D.ENCODING_CONCEPT_ID, 0) = COALESCE(NT.ENCODING_CONCEPT_ID, 0)
    AND COALESCE(D.LANGUAGE_CONCEPT_ID, 0) = COALESCE(NT.LANGUAGE_CONCEPT_ID, 0)
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(NT.PROVIDER_ID, 0)
    AND COALESCE(D.VISIT_OCCURRENCE_ID, 0) = COALESCE(NT.VISIT_OCCURRENCE_ID, 0)
    AND COALESCE(D.NOTE_SOURCE_VALUE, '0') = COALESCE(NT.NOTE_SOURCE_VALUE, '0');

/***************************************************************
 * Column Descriptions:
 * RUN_DATE - Date the QA check was executed
 * STANDARD_DATA_TABLE - Name of table being checked (NOTE)
 * QA_METRIC - Type of QA check (DUPLICATE)
 * METRIC_FIELD - Field being checked (RECORDS)
 * ERROR_TYPE - Severity of error (FATAL)
 * NOTE_ID - Unique identifier for the note record
 *
 * Logic:
 * 1. CTE finds groups of records that share the same values across all 
 *    relevant fields and have more than 1 record
 * 2. Main query joins back to NOTE_RAW to get the NOTE_IDs for all 
 *    duplicate records
 * 3. COALESCE is used to handle NULL values in the join conditions

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
 ***************************************************************/