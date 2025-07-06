/*******************************************************
Script Name: QA_PERSON_NULLCONCEPT_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************/

-- Counts NULL concepts in PERSON_RAW table for QA purposes
WITH NULLCONCEPT_COUNT AS (
    SELECT 
        'GENDER_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (GENDER_CONCEPT_ID IS NULL)
    
    UNION ALL
    
    SELECT 
        'RACE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (RACE_CONCEPT_ID IS NULL)
    
    UNION ALL
    
    SELECT 
        'ETHNICITY_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (ETHNICITY_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON) AS TOTAL_RECORDS_CLEAN
FROM NULLCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being checked for nulls
- QA_ERRORS: Count of records with null values
- ERROR_TYPE: Severity of the error (FATAL in this case)
- TOTAL_RECORDS: Total number of records in PERSON_RAW
- TOTAL_RECORDS_CLEAN: Total number of records in PERSON

LOGIC:
1. Checks for null values in concept IDs for gender, race, 
   and ethnicity in PERSON_RAW table
2. Counts occurrences of null values for each field
3. Returns summary statistics including total record counts
   from both raw and clean tables

LEGAL WARNING:
This code is provided as-is without any implied warranty.
Use at your own risk. No guarantee of fitness for any 
particular purpose is provided.
********************************************************/