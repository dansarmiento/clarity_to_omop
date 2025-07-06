---------------------------------------------------------------------
-- QA_LOCATION_DUPLICATES_COUNT
---------------------------------------------------------------------
WITH TMP_DUPES AS (
    SELECT 
        LOCATION_ID,
        ADDRESS_1,
        ADDRESS_2,
        CITY,
        STATE,
        ZIP,
        COUNTY,
        LOCATION_SOURCE_VALUE,
        COUNT(*) AS CNT
    FROM 
        CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW AS T1
    GROUP BY  
        LOCATION_ID,
        ADDRESS_1,
        ADDRESS_2,
        CITY,
        STATE,
        ZIP,
        COUNTY,
        LOCATION_SOURCE_VALUE
    HAVING 
        COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'LOCATION' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS' AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL THEN 'FATAL' 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION) AS TOTAL_RECORDS_CLEAN
FROM 
    TMP_DUPES;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked (LOCATION)
QA_METRIC: Type of quality check being performed (DUPLICATE)
METRIC_FIELD: Field being measured (RECORDS)
QA_ERRORS: Total number of duplicate records found
ERROR_TYPE: Severity of the error (FATAL if duplicates exist, NULL if no duplicates)
TOTAL_RECORDS: Total count of records in the raw location table
TOTAL_RECORDS_CLEAN: Total count of records in the clean location table

LOGIC:
------
1. TMP_DUPES CTE identifies duplicate records by grouping on all relevant location fields
   and counting instances where multiple records share the same values
2. Main query aggregates the duplicate counts and provides QA metrics
3. FATAL error type is assigned if any duplicates are found
4. Includes comparison between raw and clean table record counts

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/