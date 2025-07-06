---------------------------------------------------------------------
-- QA_DEVICE_CONCEPT_DUPLICATES_COUNT
-- Purpose: 
-- This query identifies and counts duplicate records in the DEVICE_EXPOSURE_RAW table.
---------------------------------------------------------------------
WITH TMP_DUPES AS (
    SELECT 
        PERSON_ID,
        DEVICE_CONCEPT_ID,
        DEVICE_EXPOSURE_START_DATE,
        DEVICE_EXPOSURE_START_DATETIME,
        DEVICE_EXPOSURE_END_DATE,
        DEVICE_EXPOSURE_END_DATETIME,
        DEVICE_TYPE_CONCEPT_ID,
        UNIQUE_DEVICE_ID,
        QUANTITY,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DEVICE_SOURCE_VALUE,
        DEVICE_SOURCE_CONCEPT_ID,
        COUNT(*) AS CNT
    FROM 
        CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS T1
    WHERE 
        T1.DEVICE_CONCEPT_ID != 0
        AND T1.DEVICE_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID != 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY 
        PERSON_ID,
        DEVICE_CONCEPT_ID,
        DEVICE_EXPOSURE_START_DATE,
        DEVICE_EXPOSURE_START_DATETIME,
        DEVICE_EXPOSURE_END_DATE,
        DEVICE_EXPOSURE_END_DATETIME,
        DEVICE_TYPE_CONCEPT_ID,
        UNIQUE_DEVICE_ID,
        QUANTITY,
        PROVIDER_ID,
        VISIT_OCCURRENCE_ID,
        DEVICE_SOURCE_VALUE,
        DEVICE_SOURCE_CONCEPT_ID
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM 
    TMP_DUPES;

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Name of the table being analyzed ('DEVICE_EXPOSURE')
- QA_METRIC: Type of quality check being performed ('DUPLICATE')
- METRIC_FIELD: Field being measured ('RECORDS')
- QA_ERRORS: Total number of duplicate records found
- ERROR_TYPE: Indicates severity of the error ('FATAL' if duplicates exist)
- TOTAL_RECORDS: Total number of records in the raw table
- TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
1. CTE (TMP_DUPES) identifies duplicate records by:
   - Excluding records with DEVICE_CONCEPT_ID = 0 or NULL
   - Excluding records with PERSON_ID = 0 or NULL
   - Grouping by all relevant fields
   - Counting instances where duplicates exist (COUNT > 1)

2. Main query:
   - Summarizes duplicate counts
   - Provides metadata about the QA check
   - Compares raw vs. clean table record counts
   
LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/