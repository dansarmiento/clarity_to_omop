---------------------------------------------------------------------
-- QA_MEASUREMENT_NULLCONCEPT_COUNT
---------------------------------------------------------------------

WITH NULLCONCEPT_COUNT AS (
    -- Check for null MEASUREMENT_CONCEPT_ID
    SELECT 
        'MEASUREMENT_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    WHERE (MEASUREMENT_CONCEPT_ID IS NULL)

    UNION ALL

    -- Check for null OPERATOR_CONCEPT_ID
    SELECT 
        'OPERATOR_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    WHERE (OPERATOR_CONCEPT_ID IS NULL)
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
FROM NULLCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed (MEASUREMENT)
QA_METRIC: Type of quality check being performed (NULL CONCEPT)
METRIC_FIELD: Specific field being checked for nulls
QA_ERRORS: Count of records that failed the QA check
ERROR_TYPE: Severity of the error (FATAL if errors exist, NULL if no errors)
TOTAL_RECORDS: Total number of records in the raw measurement table
TOTAL_RECORDS_CLEAN: Total number of records in the clean measurement table

LOGIC:
------
1. The CTE (NULLCONCEPT_COUNT) checks for null values in two fields:
   - MEASUREMENT_CONCEPT_ID
   - OPERATOR_CONCEPT_ID

2. The main query:
   - Combines the null checks
   - Adds metadata about the QA run
   - Calculates total record counts for both raw and clean tables
   - Groups results by the field being checked

3. Error type is marked as FATAL, indicating these null values must be addressed

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/