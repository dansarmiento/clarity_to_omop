/*********************************************************
Script Name: QA_OBSERVATION_30AFTERDEATH_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: Identifies observation records with dates more than 
30 days after a patient's death date
**********************************************************/

WITH OBSERVATION30AFTERDEATH_DETAIL AS (
    SELECT 
        'OBSERVATION_DATE' AS METRIC_FIELD,
        '30AFTERDEATH' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
    WHERE DATEDIFF(DAY, DEATH_DATE, OBSERVATION_DATE) > 30
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'OBSERVATION' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    ERROR_TYPE,
    CDT_ID
FROM OBSERVATION30AFTERDEATH_DETAIL;

/*********************************************************
Column Descriptions:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Source table being validated
- QA_METRIC: Name of quality check being performed
- METRIC_FIELD: Specific field being validated
- ERROR_TYPE: Category of error found
- CDT_ID: Unique identifier for the invalid record

Logic:
1. Joins observation and death tables on person_id
2. Identifies observations recorded >30 days after death
3. Returns details about invalid records

Legal Warning:
This code is provided as-is without any implied warranty.
Use at your own risk. No liability is assumed for any
damages or losses arising from the use of this code.
*********************************************************/