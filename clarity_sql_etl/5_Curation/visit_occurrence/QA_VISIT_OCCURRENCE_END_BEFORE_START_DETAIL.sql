/*******************************************************************************
Script Name: QA_VISIT_OCCURRENCE_END_BEFORE_START_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies visit records where the end datetime is before 
the start datetime in the VISIT_OCCURRENCE_RAW table.

*******************************************************************************/
WITH END_BEFORE_START_DETAIL AS (
    SELECT 
        'VISIT_END_DATETIME' AS METRIC_FIELD, 
        'END_BEFORE_START' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE, 
        VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW
    WHERE VISIT_END_DATETIME < VISIT_START_DATETIME
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM END_BEFORE_START_DETAIL;

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being analyzed
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being evaluated
- ERROR_TYPE: Classification of the error found
- CDT_ID: Visit Occurrence ID of the problematic record

Logic:
1. Creates CTE to identify invalid visit records
2. Returns details including run date and standard data table information

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either expressed 
or implied, including but not limited to the implied warranties of merchantability 
and/or fitness for a particular purpose. Use at your own risk.
*******************************************************************************/