/*
QA_CONDITION_OCCURRENCE_DATEVDATETIME_DETAIL
This query identifies discrepancies between DATE and DATETIME fields in CONDITION_OCCURRENCE_RAW table
*/

WITH DATEVDATETIME_DETAIL AS (
    -- Check for mismatches between CONDITION_START_DATE and CONDITION_START_DATETIME
    SELECT 
        'CONDITION_START_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        CONDITION_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS T1
    WHERE CONDITION_START_DATE <> CAST(CONDITION_START_DATETIME AS DATE)

    UNION ALL

    -- Check for mismatches between CONDITION_END_DATE and CONDITION_END_DATETIME
    SELECT 
        'CONDITION_END_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        CONDITION_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS T1
    WHERE CONDITION_END_DATE <> CAST(CONDITION_END_DATETIME AS DATE)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM DATEVDATETIME_DETAIL;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked (CONDITION_OCCURRENCE)
QA_METRIC: Type of quality check being performed (DATEVDATETIME)
METRIC_FIELD: Specific field being checked (CONDITION_START_DATE or CONDITION_END_DATE)
ERROR_TYPE: Severity of the issue found (WARNING)
CDT_ID: CONDITION_OCCURRENCE_ID where the discrepancy was found

LOGIC:
------
1. The CTE DATEVDATETIME_DETAIL checks for two types of date mismatches:
   a. Where CONDITION_START_DATE doesn't match the date part of CONDITION_START_DATETIME
   b. Where CONDITION_END_DATE doesn't match the date part of CONDITION_END_DATETIME

2. Results are combined using UNION ALL and include metadata about the type of check

3. Final output includes the run date and standardized table name for tracking purposes

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/