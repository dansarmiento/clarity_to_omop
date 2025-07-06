/*
QA_CONDITION_OCCURRENCE_END_BEFORE_START_COUNT
Checks for invalid condition occurrence records where end date is before start date
*/

WITH END_BEFORE_START_COUNT AS (
    SELECT  
        'CONDITION_END_DATETIME' AS METRIC_FIELD,
        'END_BEFORE_START' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CO
    WHERE CONDITION_END_DATETIME < CONDITION_START_DATETIME
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 
        THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM END_BEFORE_START_COUNT
GROUP BY  
    METRIC_FIELD,
    QA_METRIC, 
    ERROR_TYPE

/*
Column Descriptions:
- RUN_DATE: Date QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked
- QA_METRIC: Type of QA check being performed
- METRIC_FIELD: Field being validated
- QA_ERRORS: Count of records failing validation
- ERROR_TYPE: Category of error found
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
1. CTE identifies records where condition end date is before start date
2. Main query returns:
   - Current run date
   - Table name
   - QA metric details
   - Count of invalid records
   - Error type if errors found
   - Total record counts for raw and clean tables
3. Results grouped by metric field, QA metric and error type

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/