---------------------------------------------------------------------
-- QA_MEASUREMENT_NULLFK_COUNT
---------------------------------------------------------------------

WITH NULLFK_COUNT AS (
    -- Check for null VISIT_OCCURRENCE_ID
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for null PERSON_ID
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    WHERE (PERSON_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT) AS TOTAL_RECORDS_CLEAN
FROM NULLFK_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked (MEASUREMENT)
QA_METRIC: Type of quality check being performed (NULL FK)
METRIC_FIELD: Field being checked for null foreign keys
QA_ERRORS: Count of records with null foreign keys
ERROR_TYPE: Severity of the error (WARNING or FATAL)
TOTAL_RECORDS: Total number of records in the raw measurement table
TOTAL_RECORDS_CLEAN: Total number of records in the clean measurement table

LOGIC:
------
1. The CTE 'NULLFK_COUNT' checks for two types of null foreign keys:
   - VISIT_OCCURRENCE_ID (Warning level)
   - PERSON_ID (Fatal level)
2. The main query aggregates the results and adds metadata including:
   - Current date
   - Table name
   - Record counts for both raw and clean tables
3. ERROR_TYPE is only populated when errors are found (CNT > 0)

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/