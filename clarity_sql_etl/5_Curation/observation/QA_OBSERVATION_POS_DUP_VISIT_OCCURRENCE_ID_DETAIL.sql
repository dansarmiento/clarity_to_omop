/*******************************************************************************
Script Name: QA_OBSERVATION_POS_DUP_VISIT_OCCURRENCE_ID_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,OBSERVATION_CONCEPT_ID
        ,OBSERVATION_DATETIME
        ,VALUE_AS_NUMBER
        ,VALUE_AS_STRING
        ,VALUE_AS_CONCEPT_ID
        ,QUALIFIER_CONCEPT_ID
        ,UNIT_CONCEPT_ID
        ,PROVIDER_ID
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
        ,PROVIDER_ID
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
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(OB.PROVIDER_ID, 0)
    AND COALESCE(D.OBSERVATION_SOURCE_VALUE, '0') = COALESCE(OB.OBSERVATION_SOURCE_VALUE, '0')
    AND COALESCE(D.OBSERVATION_SOURCE_CONCEPT_ID, 0) = COALESCE(OB.OBSERVATION_SOURCE_CONCEPT_ID, 0)
    AND COALESCE(D.UNIT_SOURCE_VALUE, '0') = COALESCE(OB.UNIT_SOURCE_VALUE, '0')
    AND COALESCE(D.QUALIFIER_SOURCE_VALUE, '0') = COALESCE(OB.QUALIFIER_SOURCE_VALUE, '0');

/*******************************************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Indicates the primary table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Classification of the potential issue
OBSERVATION_ID: Unique identifier for the observation record

Logic:
------
1. Creates temporary table of duplicate observations based on multiple matching fields
2. Identifies observations that share identical values across all relevant fields
3. Returns potential duplicate records for further investigation

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
Use of this code is at your own risk and responsibility.
*******************************************************************************/