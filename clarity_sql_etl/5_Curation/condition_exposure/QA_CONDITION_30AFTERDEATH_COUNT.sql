/***************************************************************
* Script: QA_CONDITION_30AFTERDEATH_COUNT
* Description: Identifies conditions recorded more than 30 days after death
* Tables Used: 
*   - CONDITION_OCCURRENCE_RAW
*   - DEATH_RAW

****************************************************************/

-- Common Table Expression to count invalid condition records
WITH CONDITION30AFTERDEATH_COUNT AS (
    SELECT 
        'CONDITION_START_DATE' AS METRIC_FIELD,
        '30AFTERDEATH' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (DATEDIFF(DAY, DEATH_DATE, CONDITION_START_DATE) > 30) THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
    WHERE DATEDIFF(DAY, DEATH_DATE, CONDITION_START_DATE) > 30
)

-- Final result set with QA metrics
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM CONDITION30AFTERDEATH_COUNT
GROUP BY 
    METRIC_FIELD,
    QA_METRIC,
    ERROR_TYPE;

/***************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being checked
* - QA_METRIC: Identifier for the specific QA check (30AFTERDEATH)
* - METRIC_FIELD: Field being evaluated (CONDITION_START_DATE)
* - QA_ERRORS: Count of records that failed the QA check
* - ERROR_TYPE: Description of the error type found
* - TOTAL_RECORDS: Total number of records in the raw table
* - TOTAL_RECORDS_CLEAN: Total number of records in the clean table

* Logic:
* 1. CTE identifies conditions recorded more than 30 days after death by:
*    - Joining CONDITION_OCCURRENCE_RAW with DEATH_RAW on PERSON_ID
*    - Calculating days between death and condition dates
*    - Counting records where difference is > 30 days
* 
* 2. Main query:
*    - Adds execution date and table information
*    - Calculates total error count
*    - Includes record counts from both raw and clean tables
*    - Groups results by metric information

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
****************************************************************/