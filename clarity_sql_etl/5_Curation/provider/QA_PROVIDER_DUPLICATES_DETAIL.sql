/***************************************************************
Script Name: QA_PROVIDER_DUPLICATES_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
****************************************************************/

WITH TMP_DUPES AS (
    SELECT PROVIDER_NAME
        ,NPI
        ,DEA
        ,SPECIALTY_CONCEPT_ID
        ,CARE_SITE_ID
        ,YEAR_OF_BIRTH
        ,GENDER_CONCEPT_ID
        ,PROVIDER_SOURCE_VALUE
        ,SPECIALTY_SOURCE_VALUE
        ,SPECIALTY_SOURCE_CONCEPT_ID
        ,GENDER_SOURCE_VALUE
        ,GENDER_SOURCE_CONCEPT_ID
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    GROUP BY PROVIDER_NAME
        ,NPI
        ,DEA
        ,SPECIALTY_CONCEPT_ID
        ,CARE_SITE_ID
        ,YEAR_OF_BIRTH
        ,GENDER_CONCEPT_ID
        ,PROVIDER_SOURCE_VALUE
        ,SPECIALTY_SOURCE_VALUE
        ,SPECIALTY_SOURCE_CONCEPT_ID
        ,GENDER_SOURCE_VALUE
        ,GENDER_SOURCE_CONCEPT_ID
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'PROVIDER' AS STANDARD_DATA_TABLE
    ,'DUPLICATE' AS QA_METRIC
    ,'RECORDS' AS METRIC_FIELD
    ,'FATAL' AS ERROR_TYPE
    ,PR.PROVIDER_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PR 
    ON COALESCE(D.PROVIDER_NAME, '0') = COALESCE(PR.PROVIDER_NAME, '0')
    AND COALESCE(D.NPI, '0') = COALESCE(PR.NPI, '0')
    AND COALESCE(D.DEA, '0') = COALESCE(PR.DEA, '0')
    AND COALESCE(D.SPECIALTY_CONCEPT_ID, 0) = COALESCE(PR.SPECIALTY_CONCEPT_ID, 0)
    AND COALESCE(D.CARE_SITE_ID, 0) = COALESCE(PR.CARE_SITE_ID, 0)
    AND COALESCE(D.YEAR_OF_BIRTH, 0) = COALESCE(PR.YEAR_OF_BIRTH, 0)
    AND COALESCE(D.GENDER_CONCEPT_ID, 0) = COALESCE(PR.GENDER_CONCEPT_ID, 0)
    AND COALESCE(D.PROVIDER_SOURCE_VALUE, '0') = COALESCE(PR.PROVIDER_SOURCE_VALUE, '0')
    AND COALESCE(D.SPECIALTY_SOURCE_VALUE, '0') = COALESCE(PR.SPECIALTY_SOURCE_VALUE, '0')
    AND COALESCE(D.SPECIALTY_SOURCE_CONCEPT_ID, 0) = COALESCE(PR.SPECIALTY_SOURCE_CONCEPT_ID, 0)
    AND COALESCE(D.GENDER_SOURCE_VALUE, '0') = COALESCE(PR.GENDER_SOURCE_VALUE, '0')
    AND COALESCE(D.GENDER_SOURCE_CONCEPT_ID, 0) = COALESCE(PR.GENDER_SOURCE_CONCEPT_ID, 0);

/***************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Indicates the table being analyzed (PROVIDER)
QA_METRIC: Type of quality check being performed (DUPLICATE)
METRIC_FIELD: Field being measured (RECORDS)
ERROR_TYPE: Severity of the error (FATAL)
PROVIDER_ID: Unique identifier for the provider

LOGIC:
------
1. Creates temporary table (TMP_DUPES) identifying duplicate provider records
2. Joins results back to PROVIDER_RAW to get PROVIDER_IDs
3. Uses COALESCE to handle NULL values in comparison
4. Considers records duplicate when all specified fields match

LEGAL WARNING:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Use at your own risk.
****************************************************************/