/*********************************************************
Script Name: QA_SPECIMEN_NONSTANDARD_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script identifies non-standard concept IDs in the SPECIMEN table
*********************************************************/

WITH NONSTANDARD_DETAIL
AS (
    -- Check SPECIMEN_CONCEPT_ID for non-standard concepts
    SELECT 'SPECIMEN_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
        , SPECIMEN_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.SPECIMEN_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'SPECIMEN' 
        AND upper(C.VOCABULARY_ID) = ('SNOMED')
    WHERE SPECIMEN_CONCEPT_ID <> 0 
        AND SPECIMEN_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check SPECIMEN_TYPE_CONCEPT_ID for non-standard concepts
    SELECT 'SPECIMEN_TYPE_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
        , SPECIMEN_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.SPECIMEN_TYPE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT' 
        AND upper(C.VOCABULARY_ID) = ('TYPE CONCEPT')
    WHERE SPECIMEN_TYPE_CONCEPT_ID <> 0 
        AND SPECIMEN_TYPE_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check UNIT_CONCEPT_ID for non-standard concepts
    SELECT 'UNIT_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
        , SPECIMEN_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.UNIT_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'UNIT'
    WHERE UNIT_CONCEPT_ID <> 0 
        AND UNIT_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check ANATOMIC_SITE_CONCEPT_ID for non-standard concepts
    SELECT 'ANATOMIC_SITE_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
        , SPECIMEN_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.ANATOMIC_SITE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'SPEC ANATOMIC SITE' 
        AND upper(C.VOCABULARY_ID) = ('SNOMED')
    WHERE ANATOMIC_SITE_CONCEPT_ID <> 0 
        AND ANATOMIC_SITE_CONCEPT_ID IS NOT NULL 
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check DISEASE_STATUS_CONCEPT_ID for non-standard concepts
    SELECT 'DISEASE_STATUS_CONCEPT_ID' AS METRIC_FIELD, 'NON-STANDARD' AS QA_METRIC, 'INVALID DATA' AS ERROR_TYPE
        , SPECIMEN_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.DISEASE_STATUS_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'MEASUREMENT' 
        AND upper(C.VOCABULARY_ID) IN ('LOINC', 'SNOMED')
    WHERE DISEASE_STATUS_CONCEPT_ID <> 0 AND C.CONCEPT_ID IS NULL
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'SPECIMEN' AS STANDARD_DATA_TABLE
    , QA_METRIC AS QA_METRIC
    , METRIC_FIELD AS METRIC_FIELD
    , ERROR_TYPE
    , CDT_ID
FROM NONSTANDARD_DETAIL
WHERE ERROR_TYPE <>'EXPECTED'

/*********************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check performed
- METRIC_FIELD: Field being evaluated
- ERROR_TYPE: Classification of the error found
- CDT_ID: Specimen ID with the error

Logic:
This script checks various concept ID fields in the SPECIMEN table
to ensure they are using standard concepts from the appropriate
domains and vocabularies.

Legal Warning:
This code is provided as-is without any implied warranty.
Use at your own risk. No guarantee of accuracy or completeness
is expressed or implied.
*********************************************************/