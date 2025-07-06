/*******************************************************************************
Script Name: QA_OBSERVATION_NULLFK_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies NULL foreign keys in the OBSERVATION_RAW table
            and categorizes them as either warnings or fatal errors.
*******************************************************************************/

WITH NULLFK_DETAIL AS (
    -- Check for NULL VISIT_OCCURRENCE_ID (Warning)
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for NULL PERSON_ID (Fatal Error)
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (PERSON_ID IS NULL)
)

-- Final result set excluding expected errors
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'OBSERVATION' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLFK_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked (OBSERVATION)
- QA_METRIC: Type of quality check being performed (NULL FK)
- METRIC_FIELD: Field being checked for NULL foreign keys
- ERROR_TYPE: Severity of the error (WARNING or FATAL)
- CDT_ID: OBSERVATION_ID of the record with the NULL foreign key

Logic:
1. Identifies NULL VISIT_OCCURRENCE_ID values (Warning level)
2. Identifies NULL PERSON_ID values (Fatal error level)
3. Combines results and excludes any expected errors
4. Returns all records with their corresponding error types and details

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either expressed 
or implied, including but not limited to the implied warranties of merchantability 
and/or fitness for a particular purpose. The user assumes all risk for any 
damages whatsoever resulting from the use or misuse of this code.
*******************************************************************************/