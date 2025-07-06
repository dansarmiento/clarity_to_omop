---------------------------------------------------------------------
-- QA_MEASUREMENT_DATEVDATETIME_COUNT
---------------------------------------------------------------------

WITH DATEVDATETIME_COUNT AS (
    SELECT 
        'MEASUREMENT_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (MEASUREMENT_DATE <> CAST(MEASUREMENT_DATETIME AS DATE)) THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS T1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT) AS TOTAL_RECORDS_CLEAN
FROM DATEVDATETIME_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Current date when the query is executed
STANDARD_DATA_TABLE: Name of the table being analyzed (MEASUREMENT)
QA_METRIC: Type of quality check being performed (DATEVDATETIME)
METRIC_FIELD: Field being analyzed (MEASUREMENT_DATE)
QA_ERRORS: Count of records where measurement_date doesn't match measurement_datetime
ERROR_TYPE: Indicates 'WARNING' if errors are found, NULL if no errors
TOTAL_RECORDS: Total number of records in the raw measurement table
TOTAL_RECORDS_CLEAN: Total number of records in the clean measurement table

LOGIC:
------
1. CTE (DATEVDATETIME_COUNT) counts instances where MEASUREMENT_DATE 
   doesn't match the date portion of MEASUREMENT_DATETIME
2. Main query aggregates results and adds metadata including:
   - Current run date
   - Table information
   - Error counts
   - Total record counts from both raw and clean tables
3. WARNING is only shown when errors are found (CNT > 0)

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/