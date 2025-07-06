/*******************************************************************************
Script Name: QA_PERSON_AGE_ERR_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

WITH AGE_ERR_COUNT AS (
    SELECT
        'UNDER18' AS AGE,
        SUM(CASE WHEN (DATEDIFF(YEAR, BIRTH_DATETIME, GETDATE())<18) THEN 1 ELSE 0 END) AS CNT
    FROM
        CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    UNION ALL
    SELECT
        'OVER120' AS AGE,
        SUM(CASE WHEN (DATEDIFF(YEAR, BIRTH_DATETIME, GETDATE())>120) THEN 1 ELSE 0 END) AS CNT
    FROM
        CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    'WRONG AGE:'|| AGE AS QA_METRIC,
    'BIRTH_DATETIME' AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <>0 THEN 'WARNING' ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON) AS TOTAL_RECORDS_CLEAN
FROM 
    AGE_ERR_COUNT
GROUP BY 
    AGE;

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Description of the age-related quality check
METRIC_FIELD: Field being evaluated
QA_ERRORS: Count of records failing the age criteria
ERROR_TYPE: Indicates 'WARNING' if errors are found
TOTAL_RECORDS: Total count of records in raw table
TOTAL_RECORDS_CLEAN: Total count of records in clean table

LOGIC:
------
1. Creates a CTE to count records with ages under 18 and over 120
2. Combines results with additional metadata
3. Groups results by age category

LEGAL WARNING:
-------------
This code is provided "AS IS" without warranty of any kind.
Use at your own risk. The author and organization assume no liability 
for the use or misuse of this code.
*******************************************************************************/