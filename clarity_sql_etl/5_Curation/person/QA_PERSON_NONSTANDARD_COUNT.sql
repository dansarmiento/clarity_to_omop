/*********************************************************
Script Name: QA_PERSON_NONSTANDARD_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: This script performs quality assurance checks on the PERSON table
            to identify non-standard concept IDs for gender, race, and ethnicity
*********************************************************/

WITH NO_MATCH_COUNT AS (
    -- Check for non-standard GENDER_CONCEPT_ID
    SELECT
        'GENDER_CONCEPT_ID' AS METRIC_FIELD,
        'NON-STANDARD' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        COUNT(*) AS CNT
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
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS P
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON P.RACE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.DOMAIN_ID) = 'RACE' 
        AND upper(C.CONCEPT_CLASS_ID) = 'RACE'
    WHERE RACE_CONCEPT_ID <> 0 
        AND RACE_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    [... similar blocks for ETHNICITY and SOURCE concepts ...]
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON) AS TOTAL_RECORDS_CLEAN
FROM NO_MATCH_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being evaluated
QA_ERRORS: Count of records failing the quality check
ERROR_TYPE: Description of the error found
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
------
1. Checks each concept ID field in PERSON table
2. Verifies if concepts are standard according to CONCEPT table
3. Counts occurrences of non-standard concepts
4. Aggregates results by metric field

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
Use at your own risk. The author and organization assume no
responsibility for any issues arising from its use.
*********************************************************/