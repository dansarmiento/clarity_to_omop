/*********************************************************
Script Name: QA_VISIT_DETAIL_DATEVDATETIME_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

WITH DATEVDATETIME_DETAIL AS (
    SELECT 
        'VISIT_START_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE VISIT_DETAIL_START_DATE <> CAST(VISIT_DETAIL_START_DATETIME AS DATE)

    UNION ALL

    SELECT 
        'VISIT_DETAIL_END_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE VISIT_DETAIL_END_DATE <> CAST(VISIT_DETAIL_START_DATETIME AS DATE)

    UNION ALL

    SELECT 
        'VISIT_DETAIL_END_DATE' AS METRIC_FIELD, 
        'NULL_END_DATE' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE VISIT_DETAIL_END_DATE IS NULL
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_DETAIL' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM DATEVDATETIME_DETAIL;

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Severity of the error (WARNING/FATAL)
CDT_ID: Visit Detail ID from source table

LOGIC:
------
1. Checks for mismatches between date and datetime fields
2. Identifies missing end dates in visit details
3. Flags inconsistencies as either warnings or fatal errors

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind.
Use of this code is at your own risk. The author and organization
accept no liability for any damages or losses resulting from
its use.
*********************************************************/