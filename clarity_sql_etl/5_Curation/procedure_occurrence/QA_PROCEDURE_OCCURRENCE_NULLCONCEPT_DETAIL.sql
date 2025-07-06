/*******************************************************************************
* Script Name: QA_PROCEDURE_OCCURRENCE_NULLCONCEPT_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: This script identifies null concepts in the PROCEDURE_OCCURRENCE table
* that require attention and validation.
*******************************************************************************/

WITH NULLCONCEPT_DETAIL
AS (
    -- Check for null PROCEDURE_CONCEPT_ID
    SELECT 
        'PROCEDURE_CONCEPT_ID' AS METRIC_FIELD, 
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (PROCEDURE_CONCEPT_ID IS NULL)

    UNION ALL

    -- Check for null PROCEDURE_TYPE_CONCEPT_ID
    SELECT 
        'PROCEDURE_TYPE_CONCEPT_ID' AS METRIC_FIELD, 
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (PROCEDURE_TYPE_CONCEPT_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being checked
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Specific field being evaluated
* - ERROR_TYPE: Severity of the error (FATAL in this case)
* - CDT_ID: PROCEDURE_OCCURRENCE_ID of the record with the issue
*
* Logic:
* 1. Identifies records where PROCEDURE_CONCEPT_ID is null
* 2. Identifies records where PROCEDURE_TYPE_CONCEPT_ID is null
* 3. Combines results and returns only non-'EXPECTED' errors
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind, either expressed 
* or implied, including but not limited to the implied warranties of 
* merchantability and/or fitness for a particular purpose. The user assumes 
* all risk for any damages whatsoever resulting from the use of this code.
*******************************************************************************/