/***************************************************************
Script Name: QA_PERSON_ZEROCONCEPT_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
****************************************************************/

/*
This query identifies records in the PERSON_RAW table where concept IDs
for gender, race, or ethnicity are set to zero, which may indicate
data quality issues.
*/

WITH ZEROCONCEPT_DETAIL AS (
    -- Check for zero concept IDs in gender field
    SELECT 
        'GENDER_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (GENDER_CONCEPT_ID = 0)

    UNION ALL

    -- Check for zero concept IDs in race field
    SELECT 
        'RACE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (RACE_CONCEPT_ID = 0)

    UNION ALL

    -- Check for zero concept IDs in ethnicity field
    SELECT 
        'ETHNICITY_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (ETHNICITY_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Severity level of the identified issue
CDT_ID: Person ID associated with the record

Logic:
------
1. Creates a CTE to identify zero concept IDs in gender, race, and ethnicity fields
2. Combines results using UNION ALL
3. Returns only records marked as warnings (excludes 'EXPECTED' cases)
4. Adds execution date and standard table name to results

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Use at your own risk.
*/