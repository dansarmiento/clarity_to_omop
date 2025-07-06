---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_END_BEFORE_START_COUNT
---------------------------------------------------------------------

-- Common Table Expression to identify invalid date ranges
WITH END_BEFORE_START_COUNT AS (
    SELECT  
        'DEVICE_EXPOSURE_END_DATE' AS METRIC_FIELD,
        'END_BEFORE_START' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DE
    WHERE DE.DEVICE_EXPOSURE_END_DATETIME < DE.DEVICE_EXPOSURE_START_DATETIME
)

-- Main query to generate QA metrics
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 
        THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM END_BEFORE_START_COUNT
GROUP BY  
    METRIC_FIELD,
    QA_METRIC,
    ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being evaluated
QA_ERRORS: Count of records that failed the QA check
ERROR_TYPE: Description of the error type if errors exist
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. The CTE identifies records where the device exposure end date is earlier than 
   the start date (invalid date range)
2. The main query aggregates the results and adds metadata including:
   - Current run date
   - Table name
   - Error counts
   - Total record counts from both raw and clean tables
3. COALESCE is used to convert NULL error counts to 0
4. ERROR_TYPE is only populated when errors exist

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/