/*******************************************************************************
* Script Name: QA_PROCEDURE_OCCURRENCE_DATEVDATETIME_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: This script identifies discrepancies between PROCEDURE_DATE and 
* PROCEDURE_DATETIME fields in the PROCEDURE_OCCURRENCE_RAW table
*******************************************************************************/

WITH DATEVDATETIME_DETAIL AS (
    SELECT 
        'PROCEDURE_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS T1
    WHERE PROCEDURE_DATE <> CAST(PROCEDURE_DATETIME AS DATE)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM DATEVDATETIME_DETAIL;

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Date when the QA check was performed
* STANDARD_DATA_TABLE: Name of the table being analyzed
* QA_METRIC: Type of quality check being performed
* METRIC_FIELD: Field being evaluated
* ERROR_TYPE: Severity of the discrepancy
* CDT_ID: Procedure Occurrence ID with date discrepancy
*
* Logic:
* ------
* 1. Identifies records where PROCEDURE_DATE doesn't match the date portion of 
*    PROCEDURE_DATETIME
* 2. Returns details of mismatched records with appropriate warning flags
*
* Legal Warning:
* -------------
* This code is provided "AS IS" without warranty of any kind, either expressed 
* or implied, including but not limited to the implied warranties of 
* merchantability and/or fitness for a particular purpose. The user assumes all 
* risk for any damages whatsoever resulting from the use or misuse of this code.
*******************************************************************************/