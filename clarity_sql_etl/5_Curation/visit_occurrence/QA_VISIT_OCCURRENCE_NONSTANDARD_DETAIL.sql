/*********************************************************
Script Name: QA_VISIT_OCCURRENCE_NONSTANDARD_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script identifies non-standard concepts in the VISIT_OCCURRENCE table
*********************************************************/

WITH NONSTANDARD_DETAIL
AS (
    --VISIT_CONCEPT_ID Check
    SELECT 'VISIT_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE,
           VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON VO.VISIT_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.VOCABULARY_ID) = 'VISIT' 
        AND upper(C.DOMAIN_ID) = 'VISIT'
    WHERE VISIT_CONCEPT_ID <> 0 
        AND STANDARD_CONCEPT <> 'S'

    UNION ALL

    --VISIT_TYPE_CONCEPT_ID Check
    SELECT 'VISIT_TYPE_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE,
           VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON VO.VISIT_TYPE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.VOCABULARY_ID) = 'VISIT TYPE' 
        AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT'
    WHERE VISIT_TYPE_CONCEPT_ID <> 0 
        AND STANDARD_CONCEPT <> 'S'

    UNION ALL

    --VISIT_SOURCE_CONCEPT_ID Check
    SELECT 'VISIT_SOURCE_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE,
           VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON VO.VISIT_SOURCE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.VOCABULARY_ID) = 'VISIT' 
        AND upper(C.DOMAIN_ID) = 'VISIT'
    WHERE VISIT_SOURCE_CONCEPT_ID <> 0 
        AND STANDARD_CONCEPT <> 'S'

    UNION ALL

    --ADMITTED_FROM_CONCEPT_ID Check
    SELECT 'ADMITTED_FROM_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE,
           VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON VO.ADMITTED_FROM_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.VOCABULARY_ID) = 'CMS PLACE OF SERVICE'
    WHERE ADMITTED_FROM_CONCEPT_ID <> 0 
        AND STANDARD_CONCEPT <> 'S'

    UNION ALL

    --DISCHARGED_TO_CONCEPT_ID Check
    SELECT 'DISCHARGED_TO_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE,
           VISIT_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON VO.DISCHARGED_TO_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.VOCABULARY_ID) = 'CMS PLACE OF SERVICE'
    WHERE DISCHARGED_TO_CONCEPT_ID <> 0 
        AND STANDARD_CONCEPT <> 'S'
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE,
       'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
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
- CDT_ID: Visit Occurrence ID with the error

Logic:
This script checks various concept IDs in the VISIT_OCCURRENCE table
to ensure they are using standard concepts from the appropriate
vocabularies. It identifies records where non-standard concepts
are being used.

Legal Warning:
This code is provided as-is without any implied warranty.
Use at your own risk. No guarantee of accuracy or completeness
is expressed or implied.
*********************************************************/