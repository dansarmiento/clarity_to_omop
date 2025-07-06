/*******************************************************************************
* Script Name: QA_VISIT_OCCURRENCE_ZEROCONCEPT_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: Identifies zero concepts in VISIT_OCCURRENCE table for QA purposes
*******************************************************************************/

WITH ZEROCONCEPT_DETAIL AS (
    SELECT 
        'VISIT_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    WHERE (VISIT_CONCEPT_ID = 0)
    
    UNION ALL
    
    SELECT 
        'VISIT_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    WHERE (VISIT_TYPE_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Date when the QA check was performed
* STANDARD_DATA_TABLE: Name of the table being analyzed
* QA_METRIC: Type of quality check being performed
* METRIC_FIELD: Specific field being checked
* ERROR_TYPE: Classification of the issue found
* CDT_ID: Visit Occurrence ID with the identified issue
*
* Logic:
* ------
* 1. Identifies records where VISIT_CONCEPT_ID = 0
* 2. Identifies records where VISIT_TYPE_CONCEPT_ID = 0
* 3. Combines results and returns only non-expected warnings
*
* Legal Warning:
* -------------
* This code is provided as-is without any implied warranty.
* Use at your own risk. No guarantee of accuracy or completeness is given or implied.
*******************************************************************************/