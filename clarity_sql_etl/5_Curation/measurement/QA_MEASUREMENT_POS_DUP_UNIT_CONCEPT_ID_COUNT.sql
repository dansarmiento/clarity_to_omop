---------------------------------------------------------------------
-- QA_MEASUREMENT_DUPLICATES_COUNT_UNIT_CONCEPT_ID
---------------------------------------------------------------------

-- Identify duplicate measurements based on key fields
WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        MEASUREMENT_CONCEPT_ID,
        MEASUREMENT_DATETIME,
        VALUE_AS_NUMBER,
        VALUE_AS_CONCEPT_ID,
        RANGE_LOW,
        RANGE_HIGH,
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
        RANGE_LOW,
        RANGE_HIGH,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        MEASUREMENT_SOURCE_VALUE,
        VALUE_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

-- Calculate QA metrics for duplicate measurements
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    'POSSIBLE_DUPLICATE' AS QA_METRIC,
    'UNIT_CONCEPT_ID' AS METRIC_FIELD,
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
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed (MEASUREMENT)
QA_METRIC: Type of quality check being performed (POSSIBLE_DUPLICATE)
METRIC_FIELD: Specific field being checked (UNIT_CONCEPT_ID)
QA_ERRORS: Total number of duplicate records found
ERROR_TYPE: Indicates if follow-up is needed based on findings
TOTAL_RECORDS: Total number of records in the raw measurement table
TOTAL_RECORDS_CLEAN: Total number of records in the clean measurement table

LOGIC:
------
1. The CTE (TMP_DUPES) identifies duplicate measurements by grouping records
   based on multiple fields and counting occurrences > 1
2. Only includes records with valid MEASUREMENT_CONCEPT_ID and PERSON_ID
3. Main query summarizes the duplicate counts and provides QA metrics
4. Compares raw vs clean table record counts
5. Flags records for follow-up if duplicates are found

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/