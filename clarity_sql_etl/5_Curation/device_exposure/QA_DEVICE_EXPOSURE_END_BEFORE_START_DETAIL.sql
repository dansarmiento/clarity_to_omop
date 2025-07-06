---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_END_BEFORE_START_DETAIL
-- This query identifies device exposure records where the end date is before the start date,
-- which represents invalid data.
---------------------------------------------------------------------

WITH END_BEFORE_START_DETAIL AS (
    SELECT 
        'DEVICE_EXPOSURE_END_DATE' AS METRIC_FIELD,
        'END_BEFORE_START' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DE
    WHERE DE.DEVICE_EXPOSURE_END_DATETIME < DE.DEVICE_EXPOSURE_START_DATETIME
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    ERROR_TYPE,
    CDT_ID
FROM END_BEFORE_START_DETAIL;

/*


Column Descriptions:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of the table being checked (DEVICE_EXPOSURE)
- QA_METRIC: Type of QA check being performed (END_BEFORE_START)
- METRIC_FIELD: Field being validated (DEVICE_EXPOSURE_END_DATE)
- ERROR_TYPE: Category of error found (INVALID DATA)
- CDT_ID: Device exposure ID with the error

Logic:
1. CTE identifies device exposure records where end_datetime < start_datetime
2. Main query adds metadata and formatting for QA reporting

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/