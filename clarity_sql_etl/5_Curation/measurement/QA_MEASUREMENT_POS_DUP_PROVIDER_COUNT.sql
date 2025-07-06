---------------------------------------------------------------------
-- -- QA_MEASUREMENT_DUPLICATES_COUNT_PROVIDER
-- Purpose: 
-- This query identifies and counts duplicate measurements in the MEASUREMENT_RAW table.
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        MEASUREMENT_CONCEPT_ID,
        MEASUREMENT_DATETIME,
        VALUE_AS_NUMBER,
        VALUE_AS_CONCEPT_ID,
        UNIT_CONCEPT_ID,
        RANGE_LOW,
        RANGE_HIGH,
        VISIT_OCCURRENCE_ID,
        MEASUREMENT_SOURCE_VALUE,
        VALUE_SOURCE_VALUE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS T1
    WHERE T1.MEASUREMENT_CONCEPT_ID <> 0
        AND T1.MEASUREMENT_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID <> 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY 
        PERSON_ID,
        MEASUREMENT_CONCEPT_ID,
        MEASUREMENT_DATETIME,
        VALUE_AS_NUMBER,
        VALUE_AS_CONCEPT_ID,
        UNIT_CONCEPT_ID,
        RANGE_LOW,
        RANGE_HIGH,
        VISIT_OCCURRENCE_ID,
        MEASUREMENT_SOURCE_VALUE,
        VALUE_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    'POSSIBLE_DUPLICATE' AS QA_METRIC,
    'PROVIDER_ID' AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL THEN 'FOLLOW_UP' 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*


Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Indicates the table being analyzed (MEASUREMENT)
- QA_METRIC: Type of quality check being performed (POSSIBLE_DUPLICATE)
- METRIC_FIELD: Field being analyzed for duplicates (PROVIDER_ID)
- QA_ERRORS: Total count of duplicate records found
- ERROR_TYPE: Indicates if follow-up is needed based on duplicate findings
- TOTAL_RECORDS: Total number of records in MEASUREMENT_RAW table
- TOTAL_RECORDS_CLEAN: Total number of records in cleaned MEASUREMENT table

Logic:
1. Creates a CTE (TMP_DUPES) that:
   - Groups records by multiple fields to identify exact duplicates
   - Counts instances where multiple identical records exist
   - Filters out records with invalid MEASUREMENT_CONCEPT_ID and PERSON_ID
2. Main query summarizes duplicate counts and adds metadata columns
3. Compares raw vs. cleaned table record counts


LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/