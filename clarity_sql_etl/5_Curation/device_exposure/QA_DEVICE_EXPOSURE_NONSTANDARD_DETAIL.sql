---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_NONSTANDARD_DETAIL
-- Purpose:
-- This query identifies non-standard concept IDs in the DEVICE_EXPOSURE table for quality assurance purposes.
---------------------------------------------------------------------

WITH CTE_CONCEPTS_ERR_DETAIL AS (
    -- Check for non-standard DEVICE_CONCEPT_ID
    SELECT
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.DEVICE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'DEVICE' 
        AND upper(C.VOCABULARY_ID) = 'SNOMED'
    WHERE DEVICE_CONCEPT_ID <> 0 
        AND DEVICE_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard DEVICE_TYPE_CONCEPT_ID
    SELECT
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.DEVICE_TYPE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT' 
        AND upper(C.CONCEPT_CLASS_ID) = 'TYPE CONCEPT'
    WHERE DEVICE_TYPE_CONCEPT_ID <> 0 
        AND DEVICE_TYPE_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard DEVICE_SOURCE_CONCEPT_ID
    SELECT
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_SOURCE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.DEVICE_SOURCE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'DEVICE' 
        AND upper(C.VOCABULARY_ID) = 'SNOMED'
    WHERE DEVICE_SOURCE_CONCEPT_ID <> 0 
        AND DEVICE_SOURCE_CONCEPT_ID IS NOT NULL
        AND (C.CONCEPT_ID IS NOT NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM CTE_CONCEPTS_ERR_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*
Tables Used:
1. DEVICE_EXPOSURE_RAW - Contains raw device exposure data
2. CONCEPT - Contains standard vocabulary concepts

Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked (DEVICE_EXPOSURE)
- QA_METRIC: Type of quality check being performed (NON-STANDARD)
- METRIC_FIELD: Field being checked for quality issues
- ERROR_TYPE: Type of error found (INVALID DATA)
- CDT_ID: DEVICE_EXPOSURE_ID of the record with the issue

Logic:
1. Checks DEVICE_CONCEPT_ID for non-standard SNOMED concepts
2. Checks DEVICE_TYPE_CONCEPT_ID for non-standard type concepts
3. Checks DEVICE_SOURCE_CONCEPT_ID for non-standard SNOMED concepts
4. Combines all issues and returns records where ERROR_TYPE is not 'EXPECTED'

Non-standard concepts are identified by:
- Concepts that are not marked as standard (STANDARD_CONCEPT <> 'S')
- Concepts that don't exist in the vocabulary
- Concepts that exist but don't match the expected domain and vocabulary

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/