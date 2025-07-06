/*******************************************************************************
Script Name: QA_PERSON_NONSTANDARD_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
DESCRIPTION:
This script identifies non-standard concept IDs in the PERSON table for gender, 
race, and ethnicity fields (both standard and source concepts).

TABLES USED:
- CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW
- CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT

MODIFICATIONS:
- None
*******************************************************************************/

WITH NO_MATCH_DETAIL AS (
    -- Check for non-standard GENDER_CONCEPT_ID
    SELECT
        'GENDER_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.GENDER_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'GENDER' 
        AND upper(C.CONCEPT_CLASS_ID) = 'GENDER'
    WHERE GENDER_CONCEPT_ID <> 0 
        AND GENDER_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    -- Check for non-standard RACE_CONCEPT_ID
    SELECT
        'RACE_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.RACE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'RACE' 
        AND upper(C.CONCEPT_CLASS_ID) = 'RACE'
    WHERE RACE_CONCEPT_ID <> 0 
        AND RACE_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    -- Additional UNION ALL statements follow same pattern...
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NO_MATCH_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked (always 'PERSON')
- QA_METRIC: Type of quality check (always 'NON-STANDARD')
- METRIC_FIELD: Field being checked for non-standard concepts
- ERROR_TYPE: Type of error found (always 'INVALID DATA')
- CDT_ID: PERSON_ID of the record with the error

LOGIC:
1. Checks each concept ID field in PERSON table
2. Joins with CONCEPT table to verify if concept is standard
3. Returns records where concepts are non-standard or invalid
4. Excludes zero values and nulls
5. Combines results for all checked fields

LEGAL WARNING:
This code is provided as-is without any implied warranty or guarantee of fitness
for any particular purpose. Use of this code is at your own risk. The author
and organization assume no liability for any consequences resulting from the use
of this code.
*******************************************************************************/