-------------------------------------------------------------------
-- -- QA_DRUG_30AFTERDEATH_COUNT
-- Purpose: 
-- This query identifies drug exposure records that occur more than 30 days after a patient's death date,
-- which likely represents data quality issues.
-------------------------------------------------------------------

WITH DRUG30AFTERDEATH_COUNT AS (
    SELECT 
        'DRUG_EXPOSURE_START_DATE' AS METRIC_FIELD,
        '30AFTERDEATH' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        SUM(CASE 
            WHEN (DATEDIFF(DAY, DEATH_DATE, DRUG_EXPOSURE_START_DATE) > 30) THEN 1 
            ELSE 0 
        END) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
    WHERE DATEDIFF(DAY, DEATH_DATE, DRUG_EXPOSURE_START_DATE) > 30
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM DRUG30AFTERDEATH_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Name of the table being analyzed (DRUG_EXPOSURE)
- QA_METRIC: Quality check identifier (30AFTERDEATH)
- METRIC_FIELD: Field being checked (DRUG_EXPOSURE_START_DATE)
- QA_ERRORS: Count of records with drug exposure dates > 30 days after death
- ERROR_TYPE: Description of the error type (INVALID DATA)
- TOTAL_RECORDS: Total number of records in the raw table
- TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
1. CTE identifies drug exposure records where the start date is more than 30 days after death
2. Main query aggregates results and includes metadata about the QA check
3. INNER JOIN ensures only patients with death records are included
4. DATEDIFF calculates the days between death and drug exposure

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/