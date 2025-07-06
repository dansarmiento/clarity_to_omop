/*******************************************************************************
Script Name: QA_OBSERVATION_POS_DUP_PROVIDER_ID_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Purpose: Identifies potential duplicate records in OBSERVATION table based on 
matching values across multiple fields, excluding PROVIDER_ID
*******************************************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,OBSERVATION_CONCEPT_ID
        ,OBSERVATION_DATETIME
        ,VALUE_AS_NUMBER
        ,VALUE_AS_STRING
        ,VALUE_AS_CONCEPT_ID
        ,QUALIFIER_CONCEPT_ID
        ,UNIT_CONCEPT_ID
        ,VISIT_OCCURRENCE_ID
        ,OBSERVATION_SOURCE_VALUE
        ,OBSERVATION_SOURCE_CONCEPT_ID
        ,UNIT_SOURCE_VALUE
        ,QUALIFIER_SOURCE_VALUE
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS T1
    WHERE T1.OBSERVATION_CONCEPT_ID <> 0
        AND T1.OBSERVATION_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID <> 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY PERSON_ID
        ,OBSERVATION_CONCEPT_ID
        ,OBSERVATION_DATETIME
        ,VALUE_AS_NUMBER
        ,VALUE_AS_STRING
        ,VALUE_AS_CONCEPT_ID
        ,QUALIFIER_CONCEPT_ID
        ,UNIT_CONCEPT_ID
        ,VISIT_OCCURRENCE_ID
        ,OBSERVATION_SOURCE_VALUE
        ,OBSERVATION_SOURCE_CONCEPT_ID
        ,UNIT_SOURCE_VALUE
        ,QUALIFIER_SOURCE_VALUE
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'OBSERVATION' AS STANDARD_DATA_TABLE
    ,'POSSIBLE_DUPLICATE' AS QA_METRIC
    ,'PROVIDER_ID'  AS METRIC_FIELD
    ,'FOLLOW_UP' AS ERROR_TYPE
    ,OB.OBSERVATION_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OB 
    ON D.PERSON_ID = OB.PERSON_ID
    AND D.OBSERVATION_CONCEPT_ID = OB.OBSERVATION_CONCEPT_ID
    AND COALESCE(D.OBSERVATION_DATETIME,'1900-01-01') = COALESCE(OB.OBSERVATION_DATETIME,'1900-01-01')
    AND COALESCE(D.VALUE_AS_NUMBER, 0) = COALESCE(OB.VALUE_AS_NUMBER, 0)
    AND COALESCE(D.VALUE_AS_STRING, '0') = COALESCE(OB.VALUE_AS_STRING, '0')
    AND COALESCE(D.VALUE_AS_CONCEPT_ID, 0) = COALESCE(OB.VALUE_AS_CONCEPT_ID, 0)
    AND COALESCE(D.QUALIFIER_CONCEPT_ID, 0) = COALESCE(OB.QUALIFIER_CONCEPT_ID, 0)
    AND COALESCE(D.UNIT_CONCEPT_ID, 0) = COALESCE(OB.UNIT_CONCEPT_ID, 0)
    AND COALESCE(D.VISIT_OCCURRENCE_ID, 0) = COALESCE(OB.VISIT_OCCURRENCE_ID, 0)
    AND COALESCE(D.OBSERVATION_SOURCE_VALUE, '0') = COALESCE(OB.OBSERVATION_SOURCE_VALUE, '0')
    AND COALESCE(D.OBSERVATION_SOURCE_CONCEPT_ID, 0) = COALESCE(OB.OBSERVATION_SOURCE_CONCEPT_ID, 0)
    AND COALESCE(D.UNIT_SOURCE_VALUE, '0') = COALESCE(OB.UNIT_SOURCE_VALUE, '0')
    AND COALESCE(D.QUALIFIER_SOURCE_VALUE, '0') = COALESCE(OB.QUALIFIER_SOURCE_VALUE, '0');

/*******************************************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the query was executed
- STANDARD_DATA_TABLE: Name of the table being analyzed
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Field being evaluated for duplicates
- ERROR_TYPE: Classification of the potential error
- OBSERVATION_ID: Unique identifier for the observation record

LOGIC:
1. Creates temporary table of duplicate records based on matching values across
   multiple fields, excluding PROVIDER_ID
2. Joins back to original table to get OBSERVATION_ID for duplicate records
3. Uses COALESCE to handle NULL values in comparison

LEGAL WARNING:
This code is provided "AS IS" without warranty of any kind, either express 
or implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/