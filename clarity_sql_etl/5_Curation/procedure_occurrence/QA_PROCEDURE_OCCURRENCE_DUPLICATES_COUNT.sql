/*******************************************************************************
* Script Name: QA_PROCEDURE_OCCURRENCE_DUPLICATES_COUNT.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Identifies and counts duplicate records in PROCEDURE_OCCURRENCE_RAW
*******************************************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,PROCEDURE_CONCEPT_ID
        ,PROCEDURE_DATE
        ,PROCEDURE_DATETIME
        ,PROCEDURE_TYPE_CONCEPT_ID
        ,MODIFIER_CONCEPT_ID
        ,QUANTITY
        ,PROVIDER_ID
        ,VISIT_OCCURRENCE_ID
        ,PROCEDURE_SOURCE_VALUE
        ,PROCEDURE_SOURCE_CONCEPT_ID
        ,MODIFIER_SOURCE_VALUE
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS T1
    WHERE T1.PROCEDURE_CONCEPT_ID <> 0
        AND T1.PROCEDURE_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID <> 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY PERSON_ID
        ,PROCEDURE_CONCEPT_ID
        ,PROCEDURE_DATE
        ,PROCEDURE_DATETIME
        ,PROCEDURE_TYPE_CONCEPT_ID
        ,MODIFIER_CONCEPT_ID
        ,QUANTITY
        ,PROVIDER_ID
        ,VISIT_OCCURRENCE_ID
        ,PROCEDURE_SOURCE_VALUE
        ,PROCEDURE_SOURCE_CONCEPT_ID
        ,MODIFIER_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE
    ,'DUPLICATE' AS QA_METRIC
    ,'RECORDS' AS METRIC_FIELD
    ,COALESCE(SUM(CNT),0) AS QA_ERRORS
    ,CASE WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' ELSE NULL END AS ERROR_TYPE
    ,(SELECT COUNT(*) AS NUM_ROWS 
      FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS
    ,(SELECT COUNT(*) AS NUM_ROWS 
      FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being analyzed
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Field being evaluated
* - QA_ERRORS: Number of duplicate records found
* - ERROR_TYPE: Severity of the error (FATAL if duplicates exist)
* - TOTAL_RECORDS: Total number of records in RAW table
* - TOTAL_RECORDS_CLEAN: Total number of records in clean table
*
* Logic:
* 1. Creates temporary table of duplicate records based on all fields
* 2. Counts total number of duplicate records
* 3. Compares raw vs clean table record counts
*
* Legal Warning:
* This code is provided as-is without any implied warranty.
* Use at your own risk. No guarantee of accuracy or completeness is given.
*******************************************************************************/