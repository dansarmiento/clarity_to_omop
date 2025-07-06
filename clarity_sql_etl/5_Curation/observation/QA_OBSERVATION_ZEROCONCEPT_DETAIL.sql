/*******************************************************************************
Script Name: QA_OBSERVATION_ZEROCONCEPT_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script identifies zero concepts in the OBSERVATION_RAW table
            that may indicate data quality issues.

********************************************************************************/

WITH ZEROCONCEPT_DETAIL
AS (
    -- Check for zero concepts in OBSERVATION_CONCEPT_ID
    SELECT 'OBSERVATION_CONCEPT_ID' AS METRIC_FIELD, 
           'ZERO CONCEPT' AS QA_METRIC, 
           'WARNING' AS ERROR_TYPE,
           OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (OBSERVATION_CONCEPT_ID = 0)

    UNION ALL

    -- Check for zero concepts in OBSERVATION_TYPE_CONCEPT_ID
    SELECT 'OBSERVATION_TYPE_CONCEPT_ID' AS METRIC_FIELD, 
           'ZERO CONCEPT' AS QA_METRIC, 
           'WARNING' AS ERROR_TYPE,
           OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (OBSERVATION_TYPE_CONCEPT_ID = 0)

    UNION ALL

    -- Check for invalid zero concepts in VALUE_AS_CONCEPT_ID
    -- When VALUE_AS_NUMBER is present, VALUE_AS_CONCEPT_ID should not be zero
    SELECT 'VALUE_AS_CONCEPT_ID' AS METRIC_FIELD, 
           'ZERO CONCEPT' AS QA_METRIC, 
           'WARNING' AS ERROR_TYPE,
           OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    WHERE (VALUE_AS_CONCEPT_ID = 0 AND VALUE_AS_NUMBER IS NOT NULL)
)

-- Final output
SELECT CAST(GETDATE() AS DATE) AS RUN_DATE,
       'OBSERVATION' AS STANDARD_DATA_TABLE,
       QA_METRIC AS QA_METRIC,
       METRIC_FIELD AS METRIC_FIELD,
       ERROR_TYPE,
       CDT_ID
FROM ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Severity of the issue found (WARNING or ERROR)
CDT_ID: Observation ID of the record with the issue

Logic:
------
1. Identifies observations where concept IDs are zero when they should have valid values
2. Specifically checks OBSERVATION_CONCEPT_ID, OBSERVATION_TYPE_CONCEPT_ID, 
   and VALUE_AS_CONCEPT_ID fields
3. Excludes cases where zero concepts are expected

Legal Warning:
-------------
This code is provided as-is without any implied warranty or guarantee of fitness
for any particular purpose. Use of this code is at your own risk. The author
and organization assume no liability for its use or misuse.
*******************************************************************************/