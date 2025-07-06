/*******************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_POS_DUP_PROVIDER_ID_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,PROCEDURE_CONCEPT_ID
        ,PROCEDURE_DATETIME
        ,MODIFIER_CONCEPT_ID
        ,QUANTITY
        ,VISIT_OCCURRENCE_ID
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
        ,VISIT_OCCURRENCE_ID
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE
    ,'POSSIBLE_DUPLICATE' AS QA_METRIC
    ,'PROVIDER_ID'  AS METRIC_FIELD
    ,COALESCE(SUM(CNT),0) AS QA_ERRORS
    ,CASE WHEN SUM(CNT) IS NOT NULL THEN 'FOLLOW_UP' ELSE NULL END AS ERROR_TYPE
    ,(SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS
    ,(SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*******************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being analyzed
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being checked for duplicates
- QA_ERRORS: Count of duplicate records found
- ERROR_TYPE: Indicates if follow-up is needed
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

LOGIC:
1. Creates temporary table of duplicate procedures based on key fields
2. Counts instances where same procedure occurs multiple times
3. Returns summary statistics of potential duplicates

LEGAL WARNING:
This code is provided "AS IS" without warranty of any kind.
Use at your own risk. The author and organization assume no 
liability for the use or misuse of this code.
********************************************************/