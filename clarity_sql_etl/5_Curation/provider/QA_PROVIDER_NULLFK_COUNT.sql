/*******************************************************************************
Script Name: QA_PROVIDER_NULLFK_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

---------------------------------------------------------------------
-- Counts NULL Foreign Keys in PROVIDER table
---------------------------------------------------------------------

WITH CTE_NULLFK_COUNT AS (
    SELECT 
        'PROVIDER' AS STANDARD_DATA_TABLE,
        'CARE_SITE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    WHERE (CARE_SITE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC,
    METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER) AS TOTAL_RECORDS_CLEAN
FROM CTE_NULLFK_COUNT
GROUP BY  
    STANDARD_DATA_TABLE, 
    METRIC_FIELD, 
    QA_METRIC, 
    ERROR_TYPE;

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being analyzed
QA_ERRORS: Count of records with NULL foreign keys
ERROR_TYPE: Indicates severity of the error
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. CTE counts NULL values in CARE_SITE_ID field
2. Main query aggregates results and adds metadata
3. Compares raw vs clean table record counts

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code 
remains with you. Use at your own risk.
*******************************************************************************/