/*-------------------------------------------------------------------
----QA_MEASUREMENT_30AFTERDEATH_DETAIL
-------------------------------------------------------------------*/

WITH MEASUREMENT30AFTERDEATH_DETAIL AS (
    SELECT 
        'MEASUREMENT_DATE' AS METRIC_FIELD,
        '30AFTERDEATH' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        MEASUREMENT_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
    WHERE DATEDIFF(DAY, DEATH_DATE, MEASUREMENT_DATE) > 30
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    ERROR_TYPE,
    CDT_ID
FROM MEASUREMENT30AFTERDEATH_DETAIL;

/*--------------------------------------------------------------------
Column Descriptions:
--------------------------------------------------------------------
RUN_DATE - Date the QA check was executed
STANDARD_DATA_TABLE - Source table being validated (MEASUREMENT)
QA_METRIC - Name of quality check being performed (30AFTERDEATH)
METRIC_FIELD - Field being validated (MEASUREMENT_DATE)
ERROR_TYPE - Category of error found (INVALID DATA)
CDT_ID - MEASUREMENT_ID of record failing validation

Logic:
- Identifies measurements recorded more than 30 days after a patient's death
- Joins MEASUREMENT_RAW to DEATH_RAW on PERSON_ID
- Calculates days between death date and measurement date
- Flags records where difference is > 30 days as invalid

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
--------------------------------------------------------------------*/