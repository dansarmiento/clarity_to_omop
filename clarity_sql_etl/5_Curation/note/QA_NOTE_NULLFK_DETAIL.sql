/*******************************************************************************
Script Name: QA_NOTE_NULLFK_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies NULL foreign keys in the NOTE_RAW table
            and categorizes them as either WARNING or FATAL errors.

Tables Used:
- CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW

Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Field being evaluated
- ERROR_TYPE: Severity of the error (WARNING or FATAL)
- CDT_ID: NOTE_ID from the source table
*******************************************************************************/

WITH NULLFK_DETAIL
AS (
    -- Check for NULL VISIT_OCCURRENCE_ID (Warning level)
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD, 
        'NULL FK' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        NOTE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for NULL PERSON_ID (Fatal level)
    SELECT 
        'PERSON_ID' AS METRIC_FIELD, 
        'NULL FK' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        NOTE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    WHERE (PERSON_ID IS NULL)
)

-- Final result set excluding expected errors
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'NOTE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLFK_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
Legal Disclaimer:

This code is provided "AS IS" without warranty of any kind. The author and 
organization make no warranties, express or implied, regarding the functionality, 
reliability, or performance of this code. Use of this code is at your own risk.
The author and organization shall not be liable for any damages or losses 
arising from the use of this code.
*******************************************************************************/