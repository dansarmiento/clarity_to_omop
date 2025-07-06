/*********************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_NONSTANDARD_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script performs quality assurance checks on the PROCEDURE_OCCURRENCE table
            by identifying non-standard concept IDs in various fields.

**********************************************************/

WITH NONSTANDARD_COUNT
AS (
    -- Check for non-standard PROCEDURE_CONCEPT_ID
    SELECT 'PROCEDURE_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE, 
           COUNT(*) AS CNT
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
           COUNT(*) AS CNT
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
           COUNT(*) AS CNT
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
           COUNT(*) AS CNT
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
       COALESCE(SUM(CNT), 0) AS QA_ERRORS,
       CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
       (SELECT COUNT(*) AS NUM_ROWS 
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS,
       (SELECT COUNT(*) AS NUM_ROWS 
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM NONSTANDARD_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Type of quality check performed
METRIC_FIELD: Field being evaluated
QA_ERRORS: Number of errors found
ERROR_TYPE: Description of the error type
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
------
1. Checks for non-standard concepts in PROCEDURE_CONCEPT_ID
2. Checks for non-standard concepts in PROCEDURE_TYPE_CONCEPT_ID
3. Checks for non-standard concepts in MODIFIER_CONCEPT_ID
4. Checks for non-standard concepts in PROCEDURE_SOURCE_CONCEPT_ID
5. Aggregates results with counts and error types

Legal Warning:
-------------
This code is provided as-is without any implied warranty.
Use at your own risk. No liability is assumed for its use.
**********************************************************/