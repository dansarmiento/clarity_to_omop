/*******************************************************************************
* Script Name: QA_PROCEDURE_OCCURRENCE_NULLFK_DETAIL.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Identifies null foreign keys in PROCEDURE_OCCURRENCE table
*******************************************************************************/

WITH NULLFK_DETAIL AS (
    -- Check for null VISIT_OCCURRENCE_ID (Warning level)
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for null PERSON_ID (Fatal level)
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (PERSON_ID IS NULL)
)

-- Main query to return results
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLFK_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being checked
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Field being evaluated
* - ERROR_TYPE: Severity of the error (WARNING or FATAL)
* - CDT_ID: PROCEDURE_OCCURRENCE_ID of the record with the null FK
*
* Logic:
* 1. Checks for null VISIT_OCCURRENCE_ID (Warning level issue)
* 2. Checks for null PERSON_ID (Fatal level issue)
* 3. Returns only non-EXPECTED error types
*
* Legal Warning:
* This code is provided as-is without any implied warranty.
* Use at your own risk. No guarantee of accuracy or completeness is given or implied.
*******************************************************************************/