/***************************************************************
* Script: QA_CONDITION_30AFTERDEATH_DETAIL
* Description: Identifies condition occurrences recorded more than 
*              30 days after a patient's death
* Tables Used: CONDITION_OCCURRENCE_RAW, DEATH_RAW
****************************************************************/
WITH CONDITION30AFTERDEATH_DETAIL AS (
    SELECT 
        'CONDITION_START_DATE' AS METRIC_FIELD,
        '30AFTERDEATH' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        CONDITION_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
    WHERE DATEDIFF(DAY, DEATH_DATE, CONDITION_START_DATE) > 30
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM CONDITION30AFTERDEATH_DETAIL;

/*
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the source table being validated
* - QA_METRIC: Identifier for the specific quality check
* - METRIC_FIELD: Field being validated
* - ERROR_TYPE: Category of the error found
* - CDT_ID: Condition occurrence ID with invalid data
*
* Logic:
* 1. Identifies conditions recorded more than 30 days after death
* 2. Joins condition occurrences with death records
* 3. Returns details of invalid records for review

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/