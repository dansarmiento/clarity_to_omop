/*********************************************************
Script Name: QA_PROVIDER_NONSTANDARD_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

WITH NON_STANDARD_DETAIL AS (
    -- Check for non-standard Specialty Concept IDs
    SELECT 
        'SPECIALTY_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        PROVIDER_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS P
        LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C 
            ON P.SPECIALTY_CONCEPT_ID = C.CONCEPT_ID
            AND upper(C.DOMAIN_ID) = 'PROVIDER'
            AND upper(C.CONCEPT_CLASS_ID) IN ('PHYSICIAN SPECIALTY','PROVIDER')
    WHERE SPECIALTY_CONCEPT_ID <> 0
        AND SPECIALTY_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard Gender Concept IDs
    SELECT 
        'GENDER_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        PROVIDER_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS P
        LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C 
            ON P.GENDER_CONCEPT_ID = C.CONCEPT_ID
            AND upper(C.DOMAIN_ID) = 'GENDER'
    WHERE GENDER_CONCEPT_ID <> 0
        AND GENDER_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard Specialty Source Concept IDs
    SELECT 
        'SPECIALTY_SOURCE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        PROVIDER_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS P
        LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C 
            ON P.SPECIALTY_SOURCE_CONCEPT_ID = C.CONCEPT_ID
            AND upper(C.DOMAIN_ID) = 'PROVIDER'
            AND upper(C.CONCEPT_CLASS_ID) = 'PHYSICIAN SPECIALTY'
    WHERE SPECIALTY_SOURCE_CONCEPT_ID <> 0
        AND SPECIALTY_SOURCE_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard Gender Source Concept IDs
    SELECT 
        'GENDER_SOURCE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        PROVIDER_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS P
        LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C 
            ON P.GENDER_SOURCE_CONCEPT_ID = C.CONCEPT_ID
            AND upper(C.DOMAIN_ID) = 'GENDER'
    WHERE GENDER_SOURCE_CONCEPT_ID <> 0
        AND GENDER_SOURCE_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROVIDER' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NON_STANDARD_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Type of quality check performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Classification of the error found
CDT_ID: Provider ID with the identified issue

Logic:
------
This script identifies non-standard concept IDs in the PROVIDER_RAW table
for specialty and gender fields, both standard and source concepts.
It checks against the CONCEPT table to ensure all referenced concepts
are standard concepts ('S') within their respective domains.

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. Use at your own risk.
*********************************************************/