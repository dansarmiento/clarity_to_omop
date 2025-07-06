---------------------------------------------------------------------
-- QA_MEASUREMENT_DUPLICATES_COUNT
/*
 * This query identifies and counts duplicate records in the MEASUREMENT_RAW table
 * based on all relevant fields, comparing against the clean MEASUREMENT table.
 */
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        MEASUREMENT_CONCEPT_ID,
        MEASUREMENT_DATE,
        MEASUREMENT_DATETIME,
        MEASUREMENT_TYPE_CONCEPT_ID,
        OPERATOR_CONCEPT_ID,
        VALUE_AS_NUMBER,
        VALUE_AS_CONCEPT_ID,
        UNIT_CONCEPT_ID,
        RANGE_LOW,
        RANGE_HIGH,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        MEASUREMENT_SOURCE_VALUE,
        MEASUREMENT_SOURCE_CONCEPT_ID,
        UNIT_SOURCE_VALUE,
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
        MEASUREMENT_DATE,
        MEASUREMENT_DATETIME,
        MEASUREMENT_TYPE_CONCEPT_ID,
        OPERATOR_CONCEPT_ID,
        VALUE_AS_NUMBER,
        VALUE_AS_CONCEPT_ID,
        UNIT_CONCEPT_ID,
        RANGE_LOW,
        RANGE_HIGH,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        MEASUREMENT_SOURCE_VALUE,
        MEASUREMENT_SOURCE_CONCEPT_ID,
        UNIT_SOURCE_VALUE,
        VALUE_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/**
 * Column Descriptions:
 * ------------------
 * RUN_DATE: Current date when the QA check is performed
 * STANDARD_DATA_TABLE: Name of the table being analyzed (MEASUREMENT)
 * QA_METRIC: Type of quality check being performed (DUPLICATE)
 * METRIC_FIELD: Specific field or aspect being checked (RECORDS)
 * QA_ERRORS: Total number of duplicate records found
 * ERROR_TYPE: Severity of the error (FATAL if duplicates exist, NULL if none)
 * TOTAL_RECORDS: Total number of records in the raw table
 * TOTAL_RECORDS_CLEAN: Total number of records in the clean table
 *
 * Logic:
 * ------
 * 1. Creates a CTE (TMP_DUPES) that groups records by all relevant fields
 * 2. Identifies groups with more than one record (duplicates)
 * 3. Counts total duplicates and compares raw vs clean table record counts
 * 4. Only includes records with valid MEASUREMENT_CONCEPT_ID and PERSON_ID
 * 5. Returns summary statistics about duplicate records

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
 */