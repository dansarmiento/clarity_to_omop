---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_DATEVDATETIME_COUNT
-- This query validates the consistency between DATE and DATETIME fields
-- in the DRUG_EXPOSURE table
---------------------------------------------------------------------

WITH DATEVDATETIME_COUNT AS (
    -- Check DRUG_EXPOSURE_START_DATE consistency
    SELECT 
        'DRUG_EXPOSURE_START_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (DRUG_EXPOSURE_START_DATE <> CAST(DRUG_EXPOSURE_START_DATETIME AS DATE)) 
            THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1

    UNION ALL

    -- Check DRUG_EXPOSURE_END_DATE consistency
    SELECT 
        'DRUG_EXPOSURE_END_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (DRUG_EXPOSURE_END_DATE <> CAST(DRUG_EXPOSURE_END_DATETIME AS DATE)) 
            THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 
        THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM DATEVDATETIME_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC,
    ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being validated
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being validated
QA_ERRORS: Number of inconsistencies found
ERROR_TYPE: Severity of the error (WARNING in this case)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. The CTE DATEVDATETIME_COUNT checks for inconsistencies between:
   - DRUG_EXPOSURE_START_DATE and DRUG_EXPOSURE_START_DATETIME
   - DRUG_EXPOSURE_END_DATE and DRUG_EXPOSURE_END_DATETIME

2. An inconsistency is counted when the DATE value doesn't match 
   the DATE portion of the corresponding DATETIME value

3. Results are aggregated to show:
   - Total number of inconsistencies per field
   - Error type (WARNING) when inconsistencies exist
   - Record counts for both raw and clean tables

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/