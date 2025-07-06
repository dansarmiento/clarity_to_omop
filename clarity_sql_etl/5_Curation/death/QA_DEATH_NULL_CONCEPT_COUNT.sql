/*
QA_DEATH_NULL_CONCEPT_COUNT
This query checks for null concept IDs in the DEATH_RAW table and reports metrics
*/

WITH NULLCONCEPT_COUNT AS (
    SELECT 
        'DEATH_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T1 
    WHERE (DEATH_TYPE_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEATH' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH) AS TOTAL_RECORDS_CLEAN
FROM NULLCONCEPT_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC, 
    ERROR_TYPE;

/*
Column Descriptions:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked (DEATH)
- QA_METRIC: Type of QA check being performed (NULL CONCEPT)
- METRIC_FIELD: Field being checked (DEATH_TYPE_CONCEPT_ID) 
- QA_ERRORS: Count of records failing the QA check
- ERROR_TYPE: Severity of error (FATAL if errors found, NULL if no errors)
- TOTAL_RECORDS: Total count of records in DEATH_RAW table
- TOTAL_RECORDS_CLEAN: Total count of records in final DEATH table

Logic:
1. CTE counts records in DEATH_RAW where DEATH_TYPE_CONCEPT_ID is null
2. Main query aggregates results and adds metadata columns
3. Compares raw vs clean table record counts
4. Returns FATAL error if any null concepts found

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/