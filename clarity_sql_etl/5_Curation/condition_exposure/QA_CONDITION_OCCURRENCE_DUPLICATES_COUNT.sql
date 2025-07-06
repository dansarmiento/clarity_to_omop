---------------------------------------------------------------------
-- QA_CONDITION_OCCURRENCE_DUPLICATES_COUNT
-- Purpose: This query identifies and counts duplicate records in the CONDITION_OCCURRENCE_RAW table.
---------------------------------------------------------------------
WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        CONDITION_CONCEPT_ID,
        CONDITION_START_DATE,
        CONDITION_START_DATETIME,
        CONDITION_END_DATE,
        CONDITION_END_DATETIME,
        CONDITION_TYPE_CONCEPT_ID,
        STOP_REASON,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        CONDITION_SOURCE_VALUE,
        CONDITION_SOURCE_CONCEPT_ID,
        CONDITION_STATUS_SOURCE_VALUE,
        CONDITION_STATUS_CONCEPT_ID,
        src_VALUE_ID,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS T1
    WHERE T1.CONDITION_CONCEPT_ID <> 0
        AND T1.CONDITION_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID <> 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY 
        PERSON_ID,
        CONDITION_CONCEPT_ID,
        CONDITION_START_DATE,
        CONDITION_START_DATETIME,
        CONDITION_END_DATE,
        CONDITION_END_DATETIME,
        CONDITION_TYPE_CONCEPT_ID,
        STOP_REASON,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        CONDITION_SOURCE_VALUE,
        CONDITION_SOURCE_CONCEPT_ID,
        CONDITION_STATUS_SOURCE_VALUE,
        CONDITION_STATUS_CONCEPT_ID,
        src_VALUE_ID
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Name of the table being analyzed
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Field being measured
- QA_ERRORS: Total number of duplicate records found
- ERROR_TYPE: Indicates severity of the error ('FATAL' if duplicates exist)
- TOTAL_RECORDS: Total count of records in the raw table
- TOTAL_RECORDS_CLEAN: Total count of records in the clean table

Logic:
1. CTE (TMP_DUPES) groups records by all relevant fields and counts occurrences
2. Only includes records where:
   - CONDITION_CONCEPT_ID is valid (not 0 or NULL)
   - PERSON_ID is valid (not 0 or NULL)
3. Identifies groups with more than one occurrence (duplicates)
4. Final select provides summary statistics of duplicate records found

Use Case:
- Quality assurance check for duplicate records in CONDITION_OCCURRENCE data
- Comparison of raw vs. clean record counts

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/