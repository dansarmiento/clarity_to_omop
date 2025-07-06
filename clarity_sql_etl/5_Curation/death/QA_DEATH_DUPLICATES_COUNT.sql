/*******************************************************************************
* QA_DEATH_DUPLICATES_COUNT
* This query identifies and counts duplicate records in the DEATH_RAW table
*******************************************************************************/

WITH TMP_DUPES AS (
    SELECT  
        PERSON_ID,
        DEATH_DATE,
        DEATH_DATETIME,
        DEATH_TYPE_CONCEPT_ID,
        CAUSE_CONCEPT_ID,
        CAUSE_SOURCE_VALUE,
        CAUSE_SOURCE_CONCEPT_ID,
        COUNT(*) AS CNT
    FROM 
        CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T1
    GROUP BY  
        PERSON_ID,
        DEATH_DATE,
        DEATH_DATETIME,
        DEATH_TYPE_CONCEPT_ID,
        CAUSE_CONCEPT_ID,
        CAUSE_SOURCE_VALUE,
        CAUSE_SOURCE_CONCEPT_ID
    HAVING 
        COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEATH' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH) AS TOTAL_RECORDS_CLEAN
FROM 
    TMP_DUPES;

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Current date when the QA check is performed
* STANDARD_DATA_TABLE: Name of the table being checked (DEATH)
* QA_METRIC: Type of quality check being performed (DUPLICATE)
* METRIC_FIELD: Field being measured (RECORDS)
* QA_ERRORS: Total number of duplicate records found
* ERROR_TYPE: Indicates severity of the error (FATAL if duplicates exist)
* TOTAL_RECORDS: Total number of records in the raw table
* TOTAL_RECORDS_CLEAN: Total number of records in the clean table
*
* Logic:
* ------
* 1. TMP_DUPES CTE identifies duplicate records by grouping on all relevant
*    fields and counting occurrences > 1
* 2. Main query aggregates the results and provides QA metrics
* 3. Duplicates are considered FATAL errors
* 4. Includes comparison between raw and clean table record counts

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/