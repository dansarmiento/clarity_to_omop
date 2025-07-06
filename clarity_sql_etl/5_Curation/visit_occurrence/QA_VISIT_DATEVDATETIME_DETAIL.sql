/*******************************************************************************
Script Name: QA_VISIT_DATEVDATETIME_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

---------------------------------------------------------------------
-- Identifies mismatches between DATE and DATETIME fields in VISIT_OCCURRENCE
---------------------------------------------------------------------

WITH DATEVDATETIME_DETAIL AS (
    SELECT 
        'VISIT_START_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    WHERE VISIT_START_DATE <> CAST(VISIT_START_DATETIME AS DATE)

    UNION ALL

    SELECT 
        'VISIT_END_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    WHERE VISIT_END_DATE <> CAST(VISIT_START_DATETIME AS DATE)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM DATEVDATETIME_DETAIL;

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being checked
ERROR_TYPE: Severity level of the identified issue
CDT_ID: Visit Occurrence ID where discrepancy was found

LOGIC:
------
1. Checks for mismatches between VISIT_START_DATE and VISIT_START_DATETIME
2. Checks for mismatches between VISIT_END_DATE and VISIT_START_DATETIME
3. Returns all records where dates don't match their datetime counterparts

LEGAL WARNING:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code 
remains with you. In no event shall the author be liable for any damages
whatsoever arising out of the use of or inability to use this code.
*******************************************************************************/