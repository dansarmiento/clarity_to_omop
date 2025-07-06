/*******************************************************************************
* Script Name: QA_VISIT_OCCURRENCE_NULLCONCEPT_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: Quality assurance check for null concept IDs in VISIT_OCCURRENCE table
*******************************************************************************/

WITH NULLCONCEPT_DETAIL AS (
    SELECT 
        'VISIT_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    WHERE (VISIT_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Date when the QA check was performed
* STANDARD_DATA_TABLE: Name of the table being checked
* QA_METRIC: Type of quality check being performed
* METRIC_FIELD: Specific field being evaluated
* ERROR_TYPE: Severity of the error found
* CDT_ID: Visit Occurrence ID with the error
*
* Logic:
* ------
* 1. Identifies records in VISIT_OCCURRENCE_RAW where VISIT_CONCEPT_ID is null
* 2. Labels these as FATAL errors
* 3. Returns only non-EXPECTED errors
*
* Legal Warning:
* -------------
* This code is provided as-is without any implied warranty.
* Use at your own risk. No guarantee of accuracy or suitability
* for any particular purpose is provided.
*******************************************************************************/