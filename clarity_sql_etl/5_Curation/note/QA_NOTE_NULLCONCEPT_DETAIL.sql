/*******************************************************************************
Script Name: QA_NOTE_NULLCONCEPT_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies NULL concept IDs in the NOTE_RAW table
            for quality assurance purposes.

Tables Used: CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW
*******************************************************************************/

WITH NULLCONCEPT_DETAIL
AS (
    -- Check for NULL NOTE_TYPE_CONCEPT_ID
    SELECT 
        'NOTE_TYPE_CONCEPT_ID' AS METRIC_FIELD, 
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        NOTE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    WHERE (NOTE_TYPE_CONCEPT_ID IS NULL)

    UNION ALL

    -- Check for NULL NOTE_CLASS_CONCEPT_ID
    SELECT 
        'NOTE_CLASS_CONCEPT_ID' AS METRIC_FIELD, 
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        NOTE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    WHERE (NOTE_CLASS_CONCEPT_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'NOTE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked (NOTE)
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being checked for NULL values
- ERROR_TYPE: Severity of the error (FATAL in this case)
- CDT_ID: NOTE_ID of the record with the NULL concept

Logic:
1. Identifies records where NOTE_TYPE_CONCEPT_ID is NULL
2. Identifies records where NOTE_CLASS_CONCEPT_ID is NULL
3. Combines results and filters out any 'EXPECTED' errors
4. Returns only records with fatal errors

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either express 
or implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/