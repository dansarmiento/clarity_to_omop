/*********************************************************
Script Name: QA_PROVIDER_ZEROCONCEPT_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Identifies zero concept counts in the PROVIDER table
*********************************************************/

WITH CTE_ZEROCONCEPT_COUNT AS (
    SELECT 
        'PROVIDER' AS STANDARD_DATA_TABLE, 
        'SPECIALTY_CONCEPT_ID' AS METRIC_FIELD, 
        'ZERO CONCEPT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    WHERE (SPECIALTY_CONCEPT_ID = 0)

    UNION ALL

    SELECT 
        'PROVIDER' AS STANDARD_DATA_TABLE, 
        'GENDER_CONCEPT_ID' AS METRIC_FIELD, 
        'ZERO CONCEPT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    WHERE (GENDER_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER) AS TOTAL_RECORDS_CLEAN
FROM CTE_ZEROCONCEPT_COUNT
GROUP BY  
    STANDARD_DATA_TABLE, 
    METRIC_FIELD, 
    QA_METRIC, 
    ERROR_TYPE;

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being analyzed
QA_ERRORS: Count of records with zero concepts
ERROR_TYPE: Classification of the error (WARNING/NULL)
TOTAL_RECORDS: Total count of records in the raw table
TOTAL_RECORDS_CLEAN: Total count of records in the clean table

LOGIC:
------
1. CTE identifies records where concept IDs are zero
2. Main query aggregates results and adds metadata
3. Compares raw vs clean record counts

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind.
Use of this code is at your own risk. The author and organization
accept no liability for any consequences arising from its use.
*********************************************************/