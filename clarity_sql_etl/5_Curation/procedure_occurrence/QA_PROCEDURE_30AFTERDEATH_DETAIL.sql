/*******************************************************************************
Script Name: QA_PROCEDURE_30AFTERDEATH_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies procedures recorded more than 30 days after 
a patient's death date, which likely represents data quality issues.
********************************************************************************/

WITH PROCEDURE30AFTERDEATH_DETAIL AS (
    SELECT 
        'PROCEDURE_DATE' AS METRIC_FIELD, 
        '30AFTERDEATH' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS T1
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH_RAW AS T2
        ON T1.PERSON_ID = T2.PERSON_ID
    WHERE DATEDIFF(DAY, DEATH_DATE, PROCEDURE_DATE) > 30
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM PROCEDURE30AFTERDEATH_DETAIL;

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the source table being validated
- QA_METRIC: Identifier for the specific quality check
- METRIC_FIELD: Field being evaluated
- ERROR_TYPE: Classification of the data quality issue
- CDT_ID: Procedure occurrence identifier

Logic:
1. Identifies procedures with dates more than 30 days after patient death
2. Joins PROCEDURE_OCCURRENCE_RAW with DEATH_RAW on PERSON_ID
3. Uses DATEDIFF to calculate days between death and procedure dates
4. Returns details for procedures failing this validation check

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either expressed 
or implied, including but not limited to the implied warranties of merchantability 
and/or fitness for a particular purpose. Use at your own risk.
*******************************************************************************/