---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_DATEVDATETIME_COUNT
---------------------------------------------------------------------

WITH DATEVDATETIME_COUNT AS (
    -- Check Device Exposure Start Date consistency
    SELECT 
        'DEVICE_EXPOSURE_START_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (DEVICE_EXPOSURE_START_DATE <> CAST(DEVICE_EXPOSURE_START_DATETIME AS DATE)) 
            THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS T1

    UNION ALL

    -- Check Device Exposure End Date consistency
    SELECT 
        'DEVICE_EXPOSURE_END_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (DEVICE_EXPOSURE_END_DATE <> CAST(DEVICE_EXPOSURE_END_DATETIME AS DATE)) 
            THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS T1
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
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
FROM DATEVDATETIME_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC,
    ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Current date when the QA check is performed
STANDARD_DATA_TABLE: Name of the table being analyzed (DEVICE_EXPOSURE)
QA_METRIC: Type of quality check being performed (DATEVDATETIME)
METRIC_FIELD: Specific field being checked
QA_ERRORS: Count of inconsistencies found
ERROR_TYPE: Type of error (WARNING in this case)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC EXPLANATION:
----------------
1. The code checks for inconsistencies between DATE and DATETIME fields in DEVICE_EXPOSURE_RAW
2. Two checks are performed:
   - DEVICE_EXPOSURE_START_DATE vs DEVICE_EXPOSURE_START_DATETIME
   - DEVICE_EXPOSURE_END_DATE vs DEVICE_EXPOSURE_END_DATETIME
3. Counts instances where the DATE value doesn't match the date portion of DATETIME
4. Results are aggregated and presented with relevant metadata

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/