/***************************************************************
Script Name: QA_PERSON_DUPLICATES_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
****************************************************************/

WITH TMP_DUPES AS (
    SELECT
        GENDER_CONCEPT_ID,
        YEAR_OF_BIRTH,
        MONTH_OF_BIRTH,
        DAY_OF_BIRTH,
        BIRTH_DATETIME,
        RACE_CONCEPT_ID,
        ETHNICITY_CONCEPT_ID,
        LOCATION_ID,
        PROVIDER_ID,
        CARE_SITE_ID,
        PERSON_SOURCE_VALUE,
        GENDER_SOURCE_VALUE,
        GENDER_SOURCE_CONCEPT_ID,
        RACE_SOURCE_VALUE,
        RACE_SOURCE_CONCEPT_ID,
        ETHNICITY_SOURCE_VALUE,
        ETHNICITY_SOURCE_CONCEPT_ID,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    GROUP BY  
        GENDER_CONCEPT_ID,
        YEAR_OF_BIRTH,
        MONTH_OF_BIRTH,
        DAY_OF_BIRTH,
        BIRTH_DATETIME,
        RACE_CONCEPT_ID,
        ETHNICITY_CONCEPT_ID,
        LOCATION_ID,
        PROVIDER_ID,
        CARE_SITE_ID,
        PERSON_SOURCE_VALUE,
        GENDER_SOURCE_VALUE,
        GENDER_SOURCE_CONCEPT_ID,
        RACE_SOURCE_VALUE,
        RACE_SOURCE_CONCEPT_ID,
        ETHNICITY_SOURCE_VALUE,
        ETHNICITY_SOURCE_CONCEPT_ID
    HAVING COUNT(*) > 1
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    'DUPLICATE' AS QA_METRIC,
    'RECORDS'  AS METRIC_FIELD,
    'FATAL' AS ERROR_TYPE,
    PE.PERSON_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS PE ON
    D.GENDER_CONCEPT_ID = PE.GENDER_CONCEPT_ID
    AND COALESCE(D.YEAR_OF_BIRTH, 0) = COALESCE(PE.YEAR_OF_BIRTH, 0)
    AND COALESCE(D.MONTH_OF_BIRTH, 0) = COALESCE(PE.MONTH_OF_BIRTH, 0)
    AND COALESCE(D.DAY_OF_BIRTH, 0) = COALESCE(PE.DAY_OF_BIRTH, 0)
    AND COALESCE(D.BIRTH_DATETIME, '1900-01-01') = COALESCE(PE.BIRTH_DATETIME, '1900-01-01')
    AND COALESCE(D.RACE_CONCEPT_ID, 0) = COALESCE(PE.RACE_CONCEPT_ID, 0)
    AND COALESCE(D.ETHNICITY_CONCEPT_ID, 0) = COALESCE(PE.ETHNICITY_CONCEPT_ID, 0)
    AND COALESCE(D.LOCATION_ID, 0) = COALESCE(PE.LOCATION_ID, 0)
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(PE.PROVIDER_ID, 0)
    AND COALESCE(D.CARE_SITE_ID, 0) = COALESCE(PE.CARE_SITE_ID, 0)
    AND COALESCE(D.PERSON_SOURCE_VALUE, '0') = COALESCE(PE.PERSON_SOURCE_VALUE, '0')
    AND COALESCE(D.GENDER_SOURCE_VALUE, '0') = COALESCE(PE.GENDER_SOURCE_VALUE, '0')
    AND COALESCE(D.GENDER_SOURCE_CONCEPT_ID, 0) = COALESCE(PE.GENDER_SOURCE_CONCEPT_ID, 0)
    AND COALESCE(D.RACE_SOURCE_VALUE, '0') = COALESCE(PE.RACE_SOURCE_VALUE, '0')
    AND COALESCE(D.RACE_SOURCE_CONCEPT_ID, 0) = COALESCE(PE.RACE_SOURCE_CONCEPT_ID, 0)
    AND COALESCE(D.ETHNICITY_SOURCE_VALUE, '0') = COALESCE(PE.ETHNICITY_SOURCE_VALUE, '0')
    AND COALESCE(D.ETHNICITY_SOURCE_CONCEPT_ID, 0) = COALESCE(PE.ETHNICITY_SOURCE_CONCEPT_ID, 0);

/***************************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Indicates the table being analyzed (PERSON)
QA_METRIC: Type of quality check being performed (DUPLICATE)
METRIC_FIELD: Field being analyzed (RECORDS)
ERROR_TYPE: Severity of the error (FATAL)
PERSON_ID: Unique identifier for the person record

Logic:
------
1. Creates a temporary result set (TMP_DUPES) identifying duplicate records
2. Joins back to PERSON_RAW table to get specific PERSON_IDs
3. Uses COALESCE to handle NULL values in comparison
4. Returns all duplicate person records based on matching all demographic fields

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Use at your own risk.
***************************************************************/