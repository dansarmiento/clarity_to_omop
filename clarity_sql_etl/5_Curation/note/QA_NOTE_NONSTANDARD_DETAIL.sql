/*******************************************************************************
Script Name: QA_NOTE_NONSTANDARD_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script identifies non-standard concept IDs in the NOTE_RAW table
            for quality assurance purposes.
*******************************************************************************/

WITH NONSTANDARD_DETAIL
AS (
    -- Check for non-standard NOTE_TYPE_CONCEPT_ID
    SELECT 
        'NOTE_TYPE_CONCEPT_ID' AS METRIC_FIELD, 
        'NON-STANDARD' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        NOTE_ID AS CDT_ID
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
        'NOTE_CLASS_CONCEPT_ID' AS METRIC_FIELD, 
        'NON-STANDARD' AS QA_METRIC, 
        'INVALID DATA' AS ERROR_TYPE,
        NOTE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NT
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON NT.NOTE_CLASS_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'MEAS VALUE' 
        AND upper(C.VOCABULARY_ID) IN ('LOINC')
        AND C.CONCEPT_CLASS_ID IN (
            'DOC KIND', 
            'DOC SUBJECT MATTER', 
            'DOC SETTING', 
            'DOC ROLE', 
            'DOC TYPE OF SERVICE'
        )
    WHERE NOTE_CLASS_CONCEPT_ID <> 0 
        AND NOTE_CLASS_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'NOTE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NONSTANDARD_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Indicates the table being checked (NOTE)
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Classification of the error found
CDT_ID: NOTE_ID of the record with the error

LOGIC:
------
1. Checks NOTE_TYPE_CONCEPT_ID for non-standard concepts in the Type Concept domain
2. Checks NOTE_CLASS_CONCEPT_ID for non-standard concepts in the LOINC vocabulary
   with specific document-related concept classes

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind, either express or 
implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use of this code is at your own risk.
*******************************************************************************/