/*******************************************************************************
* Script Name: QA_VISIT_DETAIL_END_BEFORE_START_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
*******************************************************************************/

WITH END_BEFORE_START_DETAIL AS (
    SELECT 
        'VISIT_DETAIL_END_DATETIME' AS METRIC_FIELD, 
        'END_BEFORE_START' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE, 
        VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW
    WHERE VISIT_DETAIL_END_DATETIME < VISIT_DETAIL_START_DATETIME
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_DETAIL' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM END_BEFORE_START_DETAIL;

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Date when the QA check was performed
* STANDARD_DATA_TABLE: Name of the table being analyzed
* QA_METRIC: Type of quality check being performed
* METRIC_FIELD: Specific field being evaluated
* ERROR_TYPE: Classification of the error found
* CDT_ID: Visit Detail ID from the source table
*
* Logic:
* ------
* This script identifies records in the VISIT_DETAIL_RAW table where the 
* end datetime is earlier than the start datetime, which is logically impossible.
* These records are flagged as invalid data for further investigation and
* correction.
*
* Legal Warning:
* -------------
* This code is provided "AS IS" without warranty of any kind, either expressed
* or implied, including but not limited to the implied warranties of
* merchantability and/or fitness for a particular purpose. The user assumes
* all risk for any damages whatsoever resulting from the use or misuse of
* this code.
*******************************************************************************/