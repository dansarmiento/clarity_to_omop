/*******************************************************************************
* Script Name: QA_NOTE_NONSTANDARD_COUNT.sql
* Author: Roger J Carlson
* Date: June 2025
* Description: Identifies and counts non-standard concept usage in NOTE table
*******************************************************************************/

WITH NONSTANDARD_COUNT
AS (
    -- Check for non-standard NOTE_TYPE_CONCEPT_ID
    SELECT 
        'NOTE_TYPE_CONCEPT_ID' AS CONCEPT_ERR_ID, 
        'NON-STANDARD' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NT
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON NT.NOTE_TYPE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT' 
        AND upper(C.VOCABULARY_ID) = ('TYPE CONCEPT')
    WHERE NOTE_TYPE_CONCEPT_ID <> 0 
        AND NOTE_TYPE_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard NOTE_CLASS_CONCEPT_ID
    SELECT 
        'NOTE_CLASS_CONCEPT_ID' AS CONCEPT_ERR_ID, 
        'NON-STANDARD' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NT
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON NT.NOTE_CLASS_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'MEAS VALUE' 
        AND upper(C.VOCABULARY_ID) = ('LOINC')
        AND C.CONCEPT_CLASS_ID IN ('DOC KIND', 'DOC SUBJECT MATTER', 'DOC SETTING', 'DOC ROLE', 'DOC TYPE OF SERVICE')
    WHERE NOTE_CLASS_CONCEPT_ID <> 0 
        AND NOTE_CLASS_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'NOTE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    CONCEPT_ERR_ID AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE) AS TOTAL_RECORDS_CLEAN
FROM NONSTANDARD_COUNT
GROUP BY CONCEPT_ERR_ID, QA_METRIC, ERROR_TYPE;

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being analyzed
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Specific field being checked
* - QA_ERRORS: Count of records with errors
* - ERROR_TYPE: Description of the error type
* - TOTAL_RECORDS: Total number of records in raw table
* - TOTAL_RECORDS_CLEAN: Total number of records in clean table
*
* Logic:
* 1. Checks for non-standard concepts in NOTE_TYPE_CONCEPT_ID
* 2. Checks for non-standard concepts in NOTE_CLASS_CONCEPT_ID
* 3. Aggregates results with error counts and totals
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind.
* The entire risk of use or results from this code remains with the user.
* Use at your own risk.
*******************************************************************************/