/*******************************************************
Script Name: QA_OBSERVATION_NULLCONCEPT_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: Identifies null concept IDs in the OBSERVATION table
*******************************************************/

WITH NULLCONCEPT_DETAIL AS (
    SELECT 
        'OBSERVATION_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (OBSERVATION_CONCEPT_ID IS NULL)

    UNION ALL

    SELECT 
        'OBSERVATION_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (OBSERVATION_TYPE_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'OBSERVATION' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD, 
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************
Column Descriptions:
- RUN_DATE: Date the QA check was executed
- STANDARD_DATA_TABLE: Name of the OMOP table being checked
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being evaluated
- ERROR_TYPE: Severity of the error found
- CDT_ID: Observation ID of the record with the error

Logic:
1. Checks for null values in OBSERVATION_CONCEPT_ID
2. Checks for null values in OBSERVATION_TYPE_CONCEPT_ID
3. Returns only FATAL errors (excludes EXPECTED nulls)

Legal Warning:
This code is provided as-is without any implied warranty.
Use at your own risk. No liability is assumed for any
damages or losses arising from the use of this code.
*******************************************************/