---------------------------------------------------------------------
-- QA_MEASUREMENT_NOVISIT_COUNT
---------------------------------------------------------------------

WITH NOVISIT_COUNT AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NO VISIT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON MEASUREMENT.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
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
FROM NOVISIT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Current date when the QA check is performed
STANDARD_DATA_TABLE: Name of the table being analyzed (MEASUREMENT)
QA_METRIC: Type of quality check being performed (NO VISIT)
METRIC_FIELD: Field being checked (VISIT_OCCURRENCE_ID)
QA_ERRORS: Count of records that failed the QA check
ERROR_TYPE: Severity of the error (WARNING in this case)
TOTAL_RECORDS: Total number of records in the raw measurement table
TOTAL_RECORDS_CLEAN: Total number of records in the clean measurement table

LOGIC:
------
1. The CTE (NOVISIT_COUNT) identifies measurements that don't have a corresponding
   visit record by performing a LEFT JOIN with VISIT_OCCURRENCE_RAW table
2. The main query aggregates the results and adds additional metadata:
   - Adds current run date
   - Identifies the table being checked
   - Calculates total error count
   - Includes record counts from both raw and clean tables
3. WARNING is only shown if errors are found (CNT > 0)

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/