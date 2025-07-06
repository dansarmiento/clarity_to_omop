/*
QA check for NULL concepts in CONDITION_OCCURRENCE table
Checks CONDITION_CONCEPT_ID and CONDITION_TYPE_CONCEPT_ID fields
Returns count of NULL values and flags as FATAL error if found
*/

WITH NULLCONCEPT_COUNT AS (
    -- Check for NULL CONDITION_CONCEPT_ID
    SELECT 
        'CONDITION_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    WHERE CONDITION_CONCEPT_ID IS NULL

    UNION ALL

    -- Check for NULL CONDITION_TYPE_CONCEPT_ID 
    SELECT
        'CONDITION_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    WHERE CONDITION_TYPE_CONCEPT_ID IS NULL
)

SELECT
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM NULLCONCEPT_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC,
    ERROR_TYPE;

/*
Column Descriptions:
- RUN_DATE: Date QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked
- QA_METRIC: Type of QA check performed
- METRIC_FIELD: Field being checked
- QA_ERRORS: Count of errors found
- ERROR_TYPE: Severity of error if found
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
1. CTE checks for NULL values in CONDITION_CONCEPT_ID and CONDITION_TYPE_CONCEPT_ID
2. Main query aggregates results and adds metadata
3. FATAL error type indicates records must be fixed/removed before proceeding
4. Compares raw vs clean table record counts

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/