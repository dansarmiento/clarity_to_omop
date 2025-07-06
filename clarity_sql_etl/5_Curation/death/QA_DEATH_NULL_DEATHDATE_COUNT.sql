/***************************************************************
* QA_DEATH_NULL_DEATHDATE_COUNT
* 
* Checks for null death dates in DEATH_RAW table
****************************************************************/

WITH NULLDEATHDATE_COUNT AS (
    SELECT 
        'DEATH_DATE' AS METRIC_FIELD,
        'NULL DATE' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T1
    WHERE (DEATH_DATE IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEATH' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH) AS TOTAL_RECORDS_CLEAN
FROM NULLDEATHDATE_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC, 
    ERROR_TYPE

/***************************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date QA check was executed
- STANDARD_DATA_TABLE: Name of table being checked
- QA_METRIC: Type of QA check performed
- METRIC_FIELD: Field being checked
- QA_ERRORS: Count of records failing QA check
- ERROR_TYPE: Severity of error (FATAL in this case)
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

LOGIC:
1. CTE counts number of records with null death dates in DEATH_RAW
2. Main query:
   - Gets current date
   - Formats QA check results
   - Calculates total record counts for raw and clean tables
   - Groups results by metric details
3. FATAL error type indicates records that must be fixed

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
****************************************************************/