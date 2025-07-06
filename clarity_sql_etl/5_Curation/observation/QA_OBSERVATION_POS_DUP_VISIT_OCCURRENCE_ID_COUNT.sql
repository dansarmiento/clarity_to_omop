/*******************************************************************************
* Script Name: QA_OBSERVATION_POS_DUP_VISIT_OCCURRENCE_ID_COUNT.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Identifies potential duplicate records in OBSERVATION table based on
*              key fields, excluding VISIT_OCCURRENCE_ID
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
    ,'VISIT_OCCURRENCE_ID' AS METRIC_FIELD
    ,COALESCE(SUM(CNT),0) AS QA_ERRORS
    ,CASE WHEN SUM(CNT) IS NOT NULL THEN 'FOLLOW_UP' ELSE NULL END AS ERROR_TYPE
    ,(SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW) AS TOTAL_RECORDS
    ,(SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION) AS TOTAL_RECORDS_CLEAN
FROM TMP_DUPES;

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being analyzed
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Specific field being evaluated
* - QA_ERRORS: Count of potential duplicate records
* - ERROR_TYPE: Indicates if follow-up is needed
* - TOTAL_RECORDS: Total count of records in raw table
* - TOTAL_RECORDS_CLEAN: Total count of records in clean table
*
* Logic:
* 1. Creates temporary table of duplicate records based on all relevant fields
*    except VISIT_OCCURRENCE_ID
* 2. Counts potential duplicates and compares raw vs clean table record counts
* 3. Only includes records with valid OBSERVATION_CONCEPT_ID and PERSON_ID
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind, either expressed 
* or implied, including but not limited to the implied warranties of merchantability 
* and/or fitness for a particular purpose. Use at your own risk.
*******************************************************************************/