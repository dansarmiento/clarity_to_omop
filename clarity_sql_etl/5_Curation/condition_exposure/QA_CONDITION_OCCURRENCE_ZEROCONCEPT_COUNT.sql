/*******************************************************
 QA_CONDITION_OCCURRENCE_ZEROCONCEPT_COUNT
 Checks for zero concept IDs in CONDITION_OCCURRENCE table
*******************************************************/

WITH ZEROCONCEPT_COUNT AS (
    -- Check for zero condition concept IDs
    SELECT 
        'CONDITION_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    WHERE (CONDITION_CONCEPT_ID = 0)

    UNION ALL

    -- Check for zero condition type concept IDs 
    SELECT 
        'CONDITION_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    WHERE (CONDITION_TYPE_CONCEPT_ID = 0)
)

SELECT
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM ZEROCONCEPT_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC, 
    ERROR_TYPE;

/*******************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked
- QA_METRIC: Type of QA check being performed
- METRIC_FIELD: Field being checked
- QA_ERRORS: Count of records failing the check
- ERROR_TYPE: Severity of error (WARNING/ERROR)
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

LOGIC:
1. CTE checks for zero values in concept ID fields
2. Main query aggregates results and adds metadata
3. Compares raw vs clean record counts
4. Returns WARNING if zero concepts found

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************/