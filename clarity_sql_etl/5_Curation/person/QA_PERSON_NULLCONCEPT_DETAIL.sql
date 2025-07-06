/*******************************************************************************
Script Name: QA_PERSON_NULLCONCEPT_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************
Description: This script identifies null concept IDs in the PERSON_RAW table
            for gender, race, and ethnicity fields.

********************************************************************************/

WITH NULLCONCEPT_DETAIL AS (
    SELECT 
        'GENDER_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (GENDER_CONCEPT_ID IS NULL)
    
    UNION ALL
    
    SELECT 
        'RACE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (RACE_CONCEPT_ID IS NULL)
    
    UNION ALL
    
    SELECT 
        'ETHNICITY_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (ETHNICITY_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Name of the table being analyzed (PERSON)
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being checked for null concepts
ERROR_TYPE: Severity of the error (FATAL in this case)
CDT_ID: PERSON_ID of the record with the null concept

Logic:
------
1. Identifies records where concept IDs are null for:
   - Gender
   - Race
   - Ethnicity
2. Combines results using UNION ALL
3. Returns only FATAL errors (excludes 'EXPECTED' errors)

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Use at your own risk.
*******************************************************************************/