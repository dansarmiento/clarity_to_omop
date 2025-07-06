---------------------------------------------------------------------
-- QA_MEASUREMENT_DUPLICATES_COUNT_LOW_HIGH
-- Identifies potential duplicate records in MEASUREMENT_RAW table
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        MEASUREMENT_CONCEPT_ID,
        MEASUREMENT_DATETIME,
        VALUE_AS_NUMBER,
        VALUE_AS_CONCEPT_ID, 
        UNIT_CONCEPT_ID,
        PROVIDER_ID,
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
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        MEASUREMENT_SOURCE_VALUE,
        VALUE_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    'POSSIBLE_DUPLICATE' AS QA_METRIC,
    'RANGE_LOW_HIGH' AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
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
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date QA check was executed
STANDARD_DATA_TABLE: Name of table being analyzed (MEASUREMENT)
QA_METRIC: Type of QA check being performed (POSSIBLE_DUPLICATE)
METRIC_FIELD: Specific field/range being checked (RANGE_LOW_HIGH) 
QA_ERRORS: Count of potential duplicate records found
ERROR_TYPE: Indicates if follow up needed based on errors found
TOTAL_RECORDS: Total count of records in raw table
TOTAL_RECORDS_CLEAN: Total count of records in clean table

LOGIC:
------
1. CTE identifies duplicate records by grouping on key measurement fields
2. Duplicates defined as records sharing same:
   - Person ID
   - Measurement concept
   - Datetime
   - Values
   - Units
   - Provider
   - Visit
   - Source values
3. Only includes valid measurement concepts and person IDs
4. Main query summarizes duplicate counts and compares raw vs clean tables

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/