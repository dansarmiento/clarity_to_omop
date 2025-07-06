/*******************************************************************************
* Script Name: QA_VISIT_OCCURRENCE_NONSTANDARD_COUNT.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Quality assurance check for non-standard concepts in VISIT_OCCURRENCE
*******************************************************************************/

WITH NONSTANDARD_COUNT
AS (
    --VISIT_CONCEPT_ID Check
    SELECT 'VISIT_CONCEPT_ID' AS METRIC_FIELD, 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE, 
           COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON VO.VISIT_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.VOCABULARY_ID) = 'VISIT' 
        AND upper(C.DOMAIN_ID) = 'VISIT'
    WHERE VISIT_CONCEPT_ID <> 0 
    AND STANDARD_CONCEPT <> 'S'

    UNION ALL

    --VISIT_TYPE_CONCEPT_ID Check
    SELECT 'VISIT_TYPE_CONCEPT_ID', 
           'NON-STANDARD' AS QA_METRIC, 
           'INVALID DATA' AS ERROR_TYPE, 
           COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS C
        ON VO.VISIT_TYPE_CONCEPT_ID = C.CONCEPT_ID 
        AND upper(C.VOCABULARY_ID) = 'VISIT TYPE' 
        AND upper(C.DOMAIN_ID) = 'TYPE CONCEPT'
    WHERE VISIT_SOURCE_CONCEPT_ID <> 0 
    AND STANDARD_CONCEPT <> 'S'

    [... similar blocks for other concept IDs ...]
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM NONSTANDARD_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being checked
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Specific field being evaluated
* - QA_ERRORS: Count of records failing the QA check
* - ERROR_TYPE: Description of the error found
* - TOTAL_RECORDS: Total number of records in raw table
* - TOTAL_RECORDS_CLEAN: Total number of records in clean table
*
* Logic:
* 1. Checks each concept ID field against the CONCEPT table
* 2. Identifies non-standard concepts (where STANDARD_CONCEPT <> 'S')
* 3. Counts occurrences of non-standard concepts for each field
* 4. Aggregates results with relevant metadata
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind.
* The entire risk arising out of the use or performance of the code
* remains with you. In no event shall the author be liable for any
* damages whatsoever arising out of the use of or inability to use
* this code.
*******************************************************************************/