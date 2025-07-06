---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_POS_DUP_REFILLS_COUNT
-- Purpose: 
-- This query identifies potential duplicate drug exposure records based on identical values across multiple fields.
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        DRUG_CONCEPT_ID,
        DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE_END_DATETIME,
        VERBATIM_END_DATE,
        STOP_REASON,
        QUANTITY,
        DAYS_SUPPLY,
        SIG,
        LOT_NUMBER,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DRUG_SOURCE_VALUE,
        ROUTE_SOURCE_VALUE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1
    WHERE T1.DRUG_CONCEPT_ID != 0
        AND T1.DRUG_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID != 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY 
        PERSON_ID,
        DRUG_CONCEPT_ID,
        DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE_END_DATETIME,
        VERBATIM_END_DATE,
        STOP_REASON,
        QUANTITY,
        DAYS_SUPPLY,
        SIG,
        ROUTE_CONCEPT_ID,
        LOT_NUMBER,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DRUG_SOURCE_VALUE,
        ROUTE_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    'POSSIBLE_DUPLICATE' AS QA_METRIC,
    'REFILLS' AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL THEN 'FOLLOW_UP' 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Indicates the table being analyzed (DRUG_EXPOSURE)
- QA_METRIC: Type of quality check being performed (POSSIBLE_DUPLICATE)
- METRIC_FIELD: Specific field being analyzed (REFILLS)
- QA_ERRORS: Total count of potential duplicate records found
- ERROR_TYPE: Indicates if follow-up is needed based on findings
- TOTAL_RECORDS: Total number of records in the raw table
- TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
1. TMP_DUPES CTE:
   - Groups records by multiple fields to identify exact duplicates
   - Excludes records with invalid DRUG_CONCEPT_ID and PERSON_ID
   - Counts occurrences of each unique combination
   - Filters for combinations with more than one occurrence

2. Main Query:
   - Summarizes duplicate findings
   - Calculates total record counts for both raw and clean tables
   - Determines if follow-up is needed based on duplicate findings

Use Case:
- Quality assurance check for identifying potential duplicate drug exposure records
- Helps maintain data integrity by flagging possible duplicate refill entries

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/