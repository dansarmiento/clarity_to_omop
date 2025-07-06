/*********************************************************************
* Script Name: QA_VISIT_30AFTERDEATH_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
*
* Description: Identifies visits that occurred more than 30 days after 
* a patient's recorded death date
*********************************************************************/

WITH VISIT30AFTERDEATH_DETAIL AS (
SELECT 
    'VISIT_START_DATE' AS METRIC_FIELD,
    '30AFTERDEATH' AS QA_METRIC, 
    'INVALID DATA' AS ERROR_TYPE,
    VISIT_OCCURRENCE_ID AS CDT_ID
FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
    ON T1.PERSON_ID = T2.PERSON_ID
WHERE DATEDIFF(DAY, DEATH_DATE, VISIT_START_DATE) > 30
)

SELECT 
    CAST(GETDATE()AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    ERROR_TYPE,
    CDT_ID
FROM VISIT30AFTERDEATH_DETAIL;

/*********************************************************************
* Column Descriptions:
* RUN_DATE - Date the QA check was executed
* STANDARD_DATA_TABLE - Source table being validated
* QA_METRIC - Name of quality check being performed
* METRIC_FIELD - Specific field being validated
* ERROR_TYPE - Category of error found
* CDT_ID - Visit occurrence ID with error
*
* Logic:
* 1. Joins visit occurrence data with death data by person
* 2. Identifies visits occurring >30 days after death date
* 3. Returns details about invalid visit records
*
* Legal Warning:
* This code is provided as-is with no implied warranty.
* Use at your own risk. No guarantee of fitness for any purpose.
* Test thoroughly before using in production.
*********************************************************************/