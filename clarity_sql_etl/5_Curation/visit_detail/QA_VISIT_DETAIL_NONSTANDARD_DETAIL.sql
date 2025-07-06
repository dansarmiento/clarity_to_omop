/*********************************************************
Script Name: QA_VISIT_OCCURRENCE_NONSTANDARD_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

WITH NONSTANDARD_DETAIL
AS (
    --VISIT_CONCEPT_ID Check
    SELECT 'VISIT_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE,
           VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS VD
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON VD.VISIT_DETAIL_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.VOCABULARY_ID) = 'VISIT' 
        AND upper(C.DOMAIN_ID) = 'VISIT'
    WHERE VISIT_DETAIL_CONCEPT_ID <> 0 
        AND STANDARD_CONCEPT <> 'S'

    UNION ALL

    --VISIT_TYPE_CONCEPT_ID Check
    SELECT 'VISIT_TYPE_CONCEPT_ID' AS METRIC_FIELD,
           'NON-STANDARD' AS QA_METRIC,
           'INVALID DATA' AS ERROR_TYPE,
           VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS VD
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON VD.VISIT_DETAIL_TYPE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.VOCABULARY_ID) = 'VISIT TYPE' 
        AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT'
    WHERE VISIT_DETAIL_TYPE_CONCEPT_ID <> 0 
        AND STANDARD_CONCEPT <> 'S'

    -- Additional UNION ALL blocks follow same pattern...
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE,
       'VISIT_DETAIL' AS STANDARD_DATA_TABLE,
       QA_METRIC AS QA_METRIC,
       METRIC_FIELD AS METRIC_FIELD,
       ERROR_TYPE,
       CDT_ID
FROM NONSTANDARD_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*********************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check performed
- METRIC_FIELD: Specific field being evaluated
- ERROR_TYPE: Classification of the error found
- CDT_ID: Visit Detail ID reference

LOGIC:
This script performs quality assurance checks on various concept IDs
in the VISIT_DETAIL table to ensure they are using standard concepts.
It checks:
1. Visit Concept ID
2. Visit Type Concept ID
3. Visit Source Concept ID
4. Admitted From Concept ID
5. Discharged To Concept ID

LEGAL WARNING:
This code is provided as-is without any implied warranty.
Use at your own risk. No guarantee of accuracy or completeness
is expressed or implied.
*********************************************************/