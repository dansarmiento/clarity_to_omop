/*******************************************************************
* QA_MEASUREMENT_30AFTERDEATH_COUNT
* Checks for invalid measurement dates that occur more than 30 days after death
*******************************************************************/

WITH MEASUREMENT30AFTERDEATH_COUNT AS (
    SELECT 
        'MEASUREMENT_DATE' AS METRIC_FIELD,
        '30AFTERDEATH' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (DATEDIFF(DAY, DEATH_DATE, MEASUREMENT_DATE) > 30) THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT) AS TOTAL_RECORDS_CLEAN
FROM MEASUREMENT30AFTERDEATH_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC, 
    ERROR_TYPE;

/*******************************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of QA check being performed
- METRIC_FIELD: Field being validated
- QA_ERRORS: Count of records failing the QA check
- ERROR_TYPE: Description of the error found
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

LOGIC:
1. CTE identifies measurements taken >30 days after death date
2. Main query summarizes error counts and adds metadata
3. Joins MEASUREMENT_RAW to DEATH_RAW on PERSON_ID
4. Uses DATEDIFF to calculate days between death and measurement
5. Counts records where difference is >30 days

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************/