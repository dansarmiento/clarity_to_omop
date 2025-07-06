/*******************************************************************************
Script Name: QA_VISIT_OCCURRENCE_NULLCONCEPT_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

WITH NULLCONCEPT_DETAIL AS (
    SELECT 
        'VISIT_DETAIL_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE (VISIT_DETAIL_CONCEPT_ID IS NULL)

    UNION ALL

    SELECT 
        'VISIT_DETAIL_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE (VISIT_DETAIL_TYPE_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_DETAIL' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Severity of the error found
CDT_ID: Visit Detail ID associated with the error

LOGIC:
------
1. Checks for NULL values in required concept ID fields in VISIT_DETAIL_RAW
2. Identifies missing concept IDs that are considered fatal errors
3. Returns all records where errors are not explicitly expected

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind, either express or 
implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use of this code is at your own risk.
*******************************************************************************/