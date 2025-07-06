/*******************************************************************************
* Script Name: QA_OBSERVATION_ZEROCONCEPT_COUNT.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Quality assurance check for zero concepts in OBSERVATION table
*******************************************************************************/

WITH ZEROCONCEPT_COUNT AS (
    -- Check for zero concepts in OBSERVATION_CONCEPT_ID
    SELECT 
        'OBSERVATION_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (OBSERVATION_CONCEPT_ID = 0)

    UNION ALL

    -- Check for zero concepts in OBSERVATION_TYPE_CONCEPT_ID
    SELECT 
        'OBSERVATION_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (OBSERVATION_TYPE_CONCEPT_ID = 0)

    UNION ALL

    -- Check for invalid VALUE_AS_CONCEPT_ID when VALUE_AS_NUMBER exists
    SELECT 
        'VALUE_AS_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (VALUE_AS_CONCEPT_ID = 0 AND VALUE_AS_NUMBER IS NOT NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'OBSERVATION' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION) AS TOTAL_RECORDS_CLEAN
FROM ZEROCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being analyzed
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Field being analyzed
* - QA_ERRORS: Number of errors found
* - ERROR_TYPE: Classification of the error severity
* - TOTAL_RECORDS: Total number of records in the raw table
* - TOTAL_RECORDS_CLEAN: Total number of records in the clean table
*
* Logic:
* 1. Checks for zero concepts in OBSERVATION_CONCEPT_ID
* 2. Checks for zero concepts in OBSERVATION_TYPE_CONCEPT_ID
* 3. Identifies invalid VALUE_AS_CONCEPT_ID when VALUE_AS_NUMBER exists
* 4. Aggregates results and provides summary counts
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind.
* The entire risk arising out of the use or performance of the code
* remains with you. In no event shall the author be liable for any
* damages whatsoever arising out of the use of or inability to use
* this code.
*******************************************************************************/