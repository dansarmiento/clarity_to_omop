/*******************************************************************************
* Script Name: QA_PROCEDURE_OCCURRENCE_POS_DUP_PROVIDER_ID_COUNT.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Identifies possible duplicate procedures in PROCEDURE_OCCURRENCE_RAW
*             based on key fields and provides QA metrics
*******************************************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,PROCEDURE_CONCEPT_ID
        ,PROCEDURE_DATETIME
        ,MODIFIER_CONCEPT_ID
        ,QUANTITY
        ,PROVIDER_ID
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS T1
    WHERE T1.PROCEDURE_CONCEPT_ID <> 0
        AND T1.PROCEDURE_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID <> 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY PERSON_ID
        ,PROCEDURE_CONCEPT_ID
        ,PROCEDURE_DATETIME
        ,MODIFIER_CONCEPT_ID
        ,QUANTITY
        ,PROVIDER_ID
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    , 'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE
    , 'POSSIBLE_DUPLICATE' AS QA_METRIC
    , 'VISIT_OCCURRENCE_ID'  AS METRIC_FIELD
    , COALESCE(SUM(CNT),0) AS QA_ERRORS
    , CASE WHEN SUM(CNT) IS NOT NULL THEN 'FOLLOW_UP' ELSE NULL END AS ERROR_TYPE
    , (SELECT COUNT(*) AS NUM_ROWS 
       FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS
    , (SELECT COUNT(*) AS NUM_ROWS 
       FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Date the QA check was performed
* STANDARD_DATA_TABLE: Name of the table being analyzed
* QA_METRIC: Type of quality check being performed
* METRIC_FIELD: Field being evaluated for duplicates
* QA_ERRORS: Count of potential duplicate records
* ERROR_TYPE: Indicates if follow-up is needed
* TOTAL_RECORDS: Total count of records in raw table
* TOTAL_RECORDS_CLEAN: Total count of records in clean table
*
* Logic:
* ------
* 1. Identifies duplicate procedures based on key fields:
*    - PERSON_ID
*    - PROCEDURE_CONCEPT_ID
*    - PROCEDURE_DATETIME
*    - MODIFIER_CONCEPT_ID
*    - QUANTITY
*    - PROVIDER_ID
* 2. Counts instances where exact matches occur more than once
* 3. Provides summary metrics for QA analysis
*
* Legal Warning:
* -------------
* This code is provided as-is without any implied warranty.
* Use at your own risk. No guarantee of accuracy or completeness is given or implied.
*******************************************************************************/