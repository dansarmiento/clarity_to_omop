/*******************************************************************************
* Script Name: QA_OBSERVATION_DATEVDATETIME_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: This script performs quality assurance checks on the OBSERVATION
* table by comparing OBSERVATION_DATE against OBSERVATION_DATETIME values.
*******************************************************************************/

WITH DATEVDATETIME_DETAIL AS (
    SELECT 
        'OBSERVATION_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS T1
    WHERE OBSERVATION_DATE <> CAST(OBSERVATION_DATETIME AS DATE)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'OBSERVATION' AS STANDARD_DATA_TABLE,
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
* ERROR_TYPE: Severity level of the identified issue
* CDT_ID: Observation ID of the record with discrepancy
*
* Logic:
* ------
* 1. Creates a CTE to identify records where OBSERVATION_DATE doesn't match
*    the date portion of OBSERVATION_DATETIME
* 2. Returns details of identified discrepancies with metadata about the QA check
*
* Legal Warning:
* -------------
* This code is provided "AS IS" without warranty of any kind, either expressed 
* or implied, including but not limited to the implied warranties of 
* merchantability and/or fitness for a particular purpose. The user assumes 
* all risk for any damages whatsoever resulting from the use of this code.
*******************************************************************************/