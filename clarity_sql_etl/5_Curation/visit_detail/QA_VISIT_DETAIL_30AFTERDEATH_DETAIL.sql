/*******************************************************************************
Script Name: QA_VISIT_DETAIL_30AFTERDEATH_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies visit details that occurred more than 30 days 
after a patient's death date, which indicates potentially invalid data.

Logic:
1. Joins VISIT_DETAIL_RAW with DEATH_RAW on PERSON_ID
2. Identifies records where visit start date is > 30 days after death date
3. Returns details including run date, table name, QA metric, and error type
*******************************************************************************/

WITH VISIT30AFTERDEATH_DETAIL AS (
    SELECT 
        'VISIT_DETAIL_START_DATE' AS METRIC_FIELD, 
        '30AFTERDEATH' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
    WHERE DATEDIFF(DAY, DEATH_DATE, VISIT_DETAIL_START_DATE) > 30
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_DETAIL' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM VISIT30AFTERDEATH_DETAIL;

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Identifier for the specific quality check (30AFTERDEATH)
- METRIC_FIELD: Field being evaluated (VISIT_DETAIL_START_DATE)
- ERROR_TYPE: Classification of the error found (INVALID DATA)
- CDT_ID: Visit Detail ID of the problematic record

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either expressed 
or implied, including but not limited to the implied warranties of merchantability 
and/or fitness for a particular purpose. Use at your own risk.
*******************************************************************************/