/*********************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_NONSTANDARD_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script identifies non-standard and invalid data 
in the PROCEDURE_OCCURRENCE table by checking various concept IDs 
against their respective domains and vocabularies.
**********************************************************/

WITH NONSTANDARD_DETAIL
AS (
    -- Check for non-standard PROCEDURE_CONCEPT_ID
    SELECT 'PROCEDURE_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE,
           PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.PROCEDURE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'PROCEDURE'
    WHERE PROCEDURE_CONCEPT_ID <> 0 
        AND PROCEDURE_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard PROCEDURE_TYPE_CONCEPT_ID
    SELECT 'PROCEDURE_TYPE_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE,
           PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.PROCEDURE_TYPE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT' 
        AND upper(C.VOCABULARY_ID) IN ('TYPE CONCEPT')
    WHERE PROCEDURE_TYPE_CONCEPT_ID <> 0 
        AND PROCEDURE_TYPE_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard MODIFIER_CONCEPT_ID
    SELECT 'MODIFIER_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE,
           PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.MODIFIER_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.CONCEPT_CLASS_ID) IN ('CPT4 MODIFIER', 'HCPCS MODIFIER')
    WHERE MODIFIER_CONCEPT_ID <> 0 
        AND MODIFIER_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard PROCEDURE_SOURCE_CONCEPT_ID
    SELECT 'PROCEDURE_SOURCE_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE,
           PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.PROCEDURE_SOURCE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'PROCEDURE'
    WHERE PROCEDURE_SOURCE_CONCEPT_ID <> 0 
        AND C.CONCEPT_ID IS NULL
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE,
       'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
       QA_METRIC AS QA_METRIC,
       METRIC_FIELD AS METRIC_FIELD,
       ERROR_TYPE,
       CDT_ID
FROM NONSTANDARD_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*********************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check performed
- METRIC_FIELD: Specific field being evaluated
- ERROR_TYPE: Classification of the error found
- CDT_ID: Procedure occurrence identifier

Logic:
1. Checks PROCEDURE_CONCEPT_ID for non-standard concepts
2. Validates PROCEDURE_TYPE_CONCEPT_ID against type concepts
3. Verifies MODIFIER_CONCEPT_ID against modifier vocabularies
4. Confirms PROCEDURE_SOURCE_CONCEPT_ID exists in concept table

Legal Warning:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. Use at your own risk.
*********************************************************/