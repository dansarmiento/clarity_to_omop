---------------------------------------------------------------------
-- DRUG_EXPOSURE_DATEVDATETIME_DETAIL
---------------------------------------------------------------------

WITH DATEVDATETIME_DETAIL AS (
    -- Check for mismatches between START_DATE and START_DATETIME
    SELECT 
        'DRUG_EXPOSURE_START_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1
    WHERE DRUG_EXPOSURE_START_DATE <> CAST(DRUG_EXPOSURE_START_DATETIME AS DATE)

    UNION ALL

    -- Check for mismatches between END_DATE and END_DATETIME
    SELECT 
        'DRUG_EXPOSURE_END_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1
    WHERE DRUG_EXPOSURE_END_DATE <> CAST(DRUG_EXPOSURE_END_DATETIME AS DATE)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM DATEVDATETIME_DETAIL;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: The date when the QA check was performed
STANDARD_DATA_TABLE: The name of the table being checked (DRUG_EXPOSURE)
QA_METRIC: The type of quality check being performed (DATEVDATETIME)
METRIC_FIELD: The specific field being checked (START_DATE or END_DATE)
ERROR_TYPE: The severity of the issue found (WARNING)
CDT_ID: The DRUG_EXPOSURE_ID of the record with the discrepancy

LOGIC:
------
1. The CTE 'DATEVDATETIME_DETAIL' performs two checks:
   a. Compares DRUG_EXPOSURE_START_DATE with the date portion of DRUG_EXPOSURE_START_DATETIME
   b. Compares DRUG_EXPOSURE_END_DATE with the date portion of DRUG_EXPOSURE_END_DATETIME

2. Records are flagged when there's a mismatch between the DATE and DATETIME fields

3. Results are combined using UNION ALL and include metadata about the QA check

PURPOSE:
--------
This query identifies inconsistencies between DATE and DATETIME fields in the 
DRUG_EXPOSURE table, which could indicate data quality issues or transformation problems.

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/