/*
QA Check: NOTE_DATE vs NOTE_DATETIME Comparison
This query checks for mismatches between NOTE_DATE and NOTE_DATETIME fields
*/

WITH DATEVDATETIME_COUNT AS (
    SELECT 
        'NOTE_DATE' AS METRIC_FIELD,
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (NOTE_DATE <> CAST(NOTE_DATETIME AS DATE)) THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS T1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'NOTE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE) AS TOTAL_RECORDS_CLEAN
FROM DATEVDATETIME_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC,
    ERROR_TYPE;

/*
Column Descriptions:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of QA check being performed
- METRIC_FIELD: Field being validated
- QA_ERRORS: Count of records that failed validation
- ERROR_TYPE: Severity level of the error (WARNING in this case)
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
1. CTE counts mismatches between NOTE_DATE and NOTE_DATETIME fields
2. Main query formats results and adds metadata
3. WARNING is only populated if errors exist
4. Includes record counts from both raw and clean tables for comparison

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/