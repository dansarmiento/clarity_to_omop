/*********************************************************
Script Name: QA_VISIT_OCCURRENCE_DUPLICATES_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

/********************************************************* 
Identifies duplicate records in VISIT_OCCURRENCE_RAW table
*********************************************************/

WITH TMP_DUPES_DETAIL AS (
    SELECT PERSON_ID
        ,VISIT_CONCEPT_ID
        ,VISIT_START_DATE
        ,VISIT_START_DATETIME
        ,VISIT_END_DATE
        ,VISIT_END_DATETIME
        ,VISIT_TYPE_CONCEPT_ID
        ,PROVIDER_ID
        ,CARE_SITE_ID
        ,phi_CSN_ID
        ,VISIT_SOURCE_CONCEPT_ID
        ,ADMITTED_FROM_CONCEPT_ID
        ,ADMITTED_FROM_SOURCE_VALUE
        ,DISCHARGED_TO_CONCEPT_ID
        ,DISCHARGED_TO_SOURCE_VALUE
        ,PRECEDING_VISIT_OCCURRENCE_ID
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS T1
    GROUP BY PERSON_ID
        ,VISIT_CONCEPT_ID
        ,VISIT_START_DATE
        ,VISIT_START_DATETIME
        ,VISIT_END_DATE
        ,VISIT_END_DATETIME
        ,VISIT_TYPE_CONCEPT_ID
        ,PROVIDER_ID
        ,CARE_SITE_ID
        ,phi_CSN_ID
        ,VISIT_SOURCE_CONCEPT_ID
        ,ADMITTED_FROM_CONCEPT_ID
        ,ADMITTED_FROM_SOURCE_VALUE
        ,DISCHARGED_TO_CONCEPT_ID
        ,DISCHARGED_TO_SOURCE_VALUE
        ,PRECEDING_VISIT_OCCURRENCE_ID
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'VISIT_OCCURRENCE' AS STANDARD_DATA_TABLE
    ,'DUPLICATE' AS QA_METRIC
    ,'RECORDS'  AS METRIC_FIELD
    ,'FATAL' AS ERROR_TYPE
    ,VI.VISIT_OCCURRENCE_ID
FROM TMP_DUPES_DETAIL AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VI 
    ON D.PERSON_ID = VI.PERSON_ID
    AND D.VISIT_CONCEPT_ID = VI.VISIT_CONCEPT_ID
    AND D.VISIT_START_DATE = VI.VISIT_START_DATE
    AND D.VISIT_START_DATETIME = VI.VISIT_START_DATETIME
    AND D.VISIT_END_DATE = VI.VISIT_END_DATE
    AND COALESCE(D.VISIT_END_DATETIME,'1900-01-01') = COALESCE(VI.VISIT_END_DATETIME,'1900-01-01')
    AND COALESCE(D.VISIT_TYPE_CONCEPT_ID, 0) = COALESCE(VI.VISIT_TYPE_CONCEPT_ID, 0)
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(VI.PROVIDER_ID, 0)
    AND COALESCE(D.CARE_SITE_ID, 0) = COALESCE(VI.CARE_SITE_ID, 0)
    AND COALESCE(D.phi_CSN_ID, '0') = COALESCE(VI.phi_CSN_ID, '0')
    AND COALESCE(D.VISIT_SOURCE_CONCEPT_ID, 0) = COALESCE(VI.VISIT_SOURCE_CONCEPT_ID, 0)
    AND COALESCE(D.ADMITTED_FROM_CONCEPT_ID, 0) = COALESCE(VI.ADMITTED_FROM_CONCEPT_ID, 0)
    AND COALESCE(D.ADMITTED_FROM_SOURCE_VALUE, '0') = COALESCE(VI.ADMITTED_FROM_SOURCE_VALUE, '0')
    AND COALESCE(D.DISCHARGED_TO_CONCEPT_ID, 0) = COALESCE(VI.DISCHARGED_TO_CONCEPT_ID, 0)
    AND COALESCE(D.DISCHARGED_TO_SOURCE_VALUE, '0') = COALESCE(VI.DISCHARGED_TO_SOURCE_VALUE, '0')
    AND COALESCE(D.PRECEDING_VISIT_OCCURRENCE_ID, 0) = COALESCE(VI.PRECEDING_VISIT_OCCURRENCE_ID, 0);

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date the query was executed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being evaluated
ERROR_TYPE: Severity of the error
VISIT_OCCURRENCE_ID: Unique identifier for the visit

Logic:
------
1. CTE identifies records with identical values across all fields
2. Main query joins back to original table to get VISIT_OCCURRENCE_IDs
3. COALESCE used to handle NULL values in comparison

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
Use of this code is at your own risk and responsibility.
*********************************************************/