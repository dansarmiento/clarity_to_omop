---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_DATEVDATETIME_DETAIL
-- PURPOSE:
-- This QA check identifies records where the date and datetime fields don't match,
-- which could indicate data quality issues in the temporal aspects of device exposure records.
---------------------------------------------------------------------
WITH DATEVDATETIME_DETAIL AS (
    -- Check for mismatches between start date and datetime
    SELECT 
        'DEVICE_EXPOSURE_START_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS T1
    WHERE DEVICE_EXPOSURE_START_DATE <> CAST(DEVICE_EXPOSURE_START_DATETIME AS DATE)

    UNION ALL

    -- Check for mismatches between end date and datetime
    SELECT 
        'DEVICE_EXPOSURE_END_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS T1
    WHERE DEVICE_EXPOSURE_END_DATE <> CAST(DEVICE_EXPOSURE_END_DATETIME AS DATE)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM DATEVDATETIME_DETAIL;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked (DEVICE_EXPOSURE)
QA_METRIC: Type of quality check being performed (DATEVDATETIME)
METRIC_FIELD: Specific field being checked (START_DATE or END_DATE)
ERROR_TYPE: Severity of the issue found (WARNING)
CDT_ID: DEVICE_EXPOSURE_ID of the record with the issue

LOGIC:
------
1. The CTE DATEVDATETIME_DETAIL checks for two types of date inconsistencies:
   a. Mismatches between DEVICE_EXPOSURE_START_DATE and the date portion of DEVICE_EXPOSURE_START_DATETIME
   b. Mismatches between DEVICE_EXPOSURE_END_DATE and the date portion of DEVICE_EXPOSURE_END_DATETIME

2. Results are combined using UNION ALL to capture all instances of both types of mismatches

3. The final query adds metadata including the run date and standard table name


LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/