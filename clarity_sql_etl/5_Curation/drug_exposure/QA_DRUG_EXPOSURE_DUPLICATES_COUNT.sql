---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_DUPLICATES_COUNT
-- Purpose: This query identifies and counts duplicate records in the DRUG_EXPOSURE_RAW table.
---------------------------------------------------------------------

WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        DRUG_CONCEPT_ID,
        DRUG_EXPOSURE_START_DATE,
        DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE_END_DATE,
        DRUG_EXPOSURE_END_DATETIME,
        VERBATIM_END_DATE,
        DRUG_TYPE_CONCEPT_ID,
        STOP_REASON,
        REFILLS,
        QUANTITY,
        DAYS_SUPPLY,
        SIG,
        ROUTE_CONCEPT_ID,
        LOT_NUMBER,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DRUG_SOURCE_VALUE,
        DRUG_SOURCE_CONCEPT_ID,
        ROUTE_SOURCE_VALUE,
        DOSE_UNIT_SOURCE_VALUE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1
    WHERE T1.DRUG_CONCEPT_ID != 0
        AND T1.DRUG_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID != 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY 
        PERSON_ID,
        DRUG_CONCEPT_ID,
        DRUG_EXPOSURE_START_DATE,
        DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE_END_DATE,
        DRUG_EXPOSURE_END_DATETIME,
        VERBATIM_END_DATE,
        DRUG_TYPE_CONCEPT_ID,
        STOP_REASON,
        REFILLS,
        QUANTITY,
        DAYS_SUPPLY,
        SIG,
        ROUTE_CONCEPT_ID,
        LOT_NUMBER,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DRUG_SOURCE_VALUE,
        DRUG_SOURCE_CONCEPT_ID,
        ROUTE_SOURCE_VALUE,
        DOSE_UNIT_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Name of the table being analyzed (DRUG_EXPOSURE)
- QA_METRIC: Type of quality check being performed (DUPLICATE)
- METRIC_FIELD: Field being measured (RECORDS)
- QA_ERRORS: Total number of duplicate records found
- ERROR_TYPE: Indicates severity of the error (FATAL if duplicates exist)
- TOTAL_RECORDS: Total number of records in the raw table
- TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
1. TMP_DUPES CTE:
   - Groups records by all relevant fields
   - Counts occurrences of identical records
   - Filters for records with count > 1 (duplicates)
   - Excludes records with DRUG_CONCEPT_ID = 0 or null
   - Excludes records with PERSON_ID = 0 or null

2. Main Query:
   - Summarizes duplicate counts
   - Provides metadata about the QA check
   - Compares raw vs clean table record counts

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/