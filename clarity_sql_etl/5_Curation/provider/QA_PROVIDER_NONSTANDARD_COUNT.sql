/*******************************************************
Script Name: QA_PROVIDER_NONSTANDARD_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: Quality assurance check for non-standard concept IDs in the PROVIDER table
*******************************************************/

WITH NON_STANDARD_COUNT AS (
    SELECT 'SPECIALTY_CONCEPT_ID' AS METRIC_FIELD,
           'NON-STANDARD' AS QA_METRIC,
           'INVALID DATA' AS ERROR_TYPE,
           COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS P
        LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C 
            ON P.SPECIALTY_CONCEPT_ID = C.CONCEPT_ID
            AND upper(C.DOMAIN_ID) = 'PROVIDER'
            AND upper(C.CONCEPT_CLASS_ID) IN ('PHYSICIAN SPECIALTY','PROVIDER')
    WHERE SPECIALTY_CONCEPT_ID <> 0
        AND SPECIALTY_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    SELECT 'GENDER_CONCEPT_ID' AS METRIC_FIELD,
           'NON-STANDARD' AS QA_METRIC,
           'INVALID DATA' AS ERROR_TYPE,
           COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS P
        LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C 
            ON P.GENDER_CONCEPT_ID = C.CONCEPT_ID
            AND upper(C.DOMAIN_ID) = 'GENDER'
    WHERE GENDER_CONCEPT_ID <> 0
        AND GENDER_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    SELECT 'SPECIALTY_SOURCE_CONCEPT_ID' AS METRIC_FIELD,
           'NON-STANDARD' AS QA_METRIC,
           'INVALID DATA' AS ERROR_TYPE,
           COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS P
        LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C 
            ON P.SPECIALTY_SOURCE_CONCEPT_ID = C.CONCEPT_ID
            AND upper(C.DOMAIN_ID) = 'PROVIDER'
            AND upper(C.CONCEPT_CLASS_ID) = 'PHYSICIAN SPECIALTY'
    WHERE SPECIALTY_SOURCE_CONCEPT_ID <> 0
        AND SPECIALTY_SOURCE_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)

    UNION ALL

    SELECT 'GENDER_SOURCE_CONCEPT_ID' AS METRIC_FIELD,
           'NON-STANDARD' AS QA_METRIC,
           'INVALID DATA' AS ERROR_TYPE,
           COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS P
        LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C 
            ON P.GENDER_SOURCE_CONCEPT_ID = C.CONCEPT_ID
            AND upper(C.DOMAIN_ID) = 'GENDER'
    WHERE GENDER_SOURCE_CONCEPT_ID <> 0
        AND GENDER_SOURCE_CONCEPT_ID IS NOT NULL
        AND (STANDARD_CONCEPT <> 'S' OR STANDARD_CONCEPT IS NULL)
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE,
       'PROVIDER' AS STANDARD_DATA_TABLE,
       QA_METRIC AS QA_METRIC,
       METRIC_FIELD AS METRIC_FIELD,
       COALESCE(SUM(CNT),0) AS QA_ERRORS,
       CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
       (SELECT COUNT(*) AS NUM_ROWS 
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW) AS TOTAL_RECORDS,
       (SELECT COUNT(*) AS NUM_ROWS 
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER) AS TOTAL_RECORDS_CLEAN
FROM NON_STANDARD_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************
Column Descriptions:
- RUN_DATE: Date the QA check was performed
- STANDARD_DATA_TABLE: Name of table being checked
- QA_METRIC: Type of QA check performed
- METRIC_FIELD: Field being checked
- QA_ERRORS: Count of records failing the check
- ERROR_TYPE: Description of the error found
- TOTAL_RECORDS: Total count of records in raw table
- TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
This script checks for non-standard concept IDs in the following PROVIDER fields:
- SPECIALTY_CONCEPT_ID 
- GENDER_CONCEPT_ID
- SPECIALTY_SOURCE_CONCEPT_ID
- GENDER_SOURCE_CONCEPT_ID

Legal Warning:
This code is provided as-is without any implied warranty.
Use at your own risk.
*******************************************************/