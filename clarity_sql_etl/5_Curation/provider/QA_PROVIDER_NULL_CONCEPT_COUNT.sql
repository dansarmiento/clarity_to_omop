/*********************************************************
 * Script Name: QA_PROVIDER_NULL_CONCEPT_COUNT
 * Author: Roger J Carlson - Corewell Health
 * Date: June 2025
 * 
 * Description: This script performs quality assurance checks 
 * on the PROVIDER table by counting null concepts in specific fields.
 *********************************************************/

WITH CTE_NULLCONCEPT_COUNT AS (
    SELECT 
        'PROVIDER' AS STANDARD_DATA_TABLE,
        'SPECIALTY_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    WHERE (SPECIALTY_CONCEPT_ID IS NULL)
    
    UNION ALL
    
    SELECT 
        'PROVIDER' AS STANDARD_DATA_TABLE,
        'GENDER_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    WHERE (GENDER_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER) AS TOTAL_RECORDS_CLEAN
FROM CTE_NULLCONCEPT_COUNT
GROUP BY 
    STANDARD_DATA_TABLE, 
    METRIC_FIELD, 
    QA_METRIC, 
    ERROR_TYPE;

/*********************************************************
 * Column Descriptions:
 * - RUN_DATE: Date when the QA check was performed
 * - STANDARD_DATA_TABLE: Name of the table being checked
 * - QA_METRIC: Type of quality check being performed
 * - METRIC_FIELD: Specific field being evaluated
 * - QA_ERRORS: Count of records with null concepts
 * - ERROR_TYPE: Severity of the error (WARNING/ERROR)
 * - TOTAL_RECORDS: Total count of records in raw table
 * - TOTAL_RECORDS_CLEAN: Total count of records in clean table
 *
 * Logic:
 * 1. Counts null values in SPECIALTY_CONCEPT_ID
 * 2. Counts null values in GENDER_CONCEPT_ID
 * 3. Aggregates results and compares with total record counts
 *
 * Legal Warning:
 * This code is provided "AS IS" without warranty of any kind.
 * The entire risk as to the quality and performance of the code
 * is with you. Use at your own risk.
 *********************************************************/