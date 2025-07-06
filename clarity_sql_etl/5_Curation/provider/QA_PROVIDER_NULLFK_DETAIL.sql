/*******************************************************************************
Script Name: QA_PROVIDER_NULLFK_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

--Check for NULL Foreign Keys in PROVIDER table
WITH CTE_NULLFK_DETAIL AS (
    SELECT 
        'PROVIDER' AS STANDARD_DATA_TABLE,
        'CARE_SITE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        PROVIDER_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS T1
    WHERE (CARE_SITE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM CTE_NULLFK_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Name of the table being analyzed (PROVIDER)
QA_METRIC: Type of quality check being performed (NULL FK)
METRIC_FIELD: Field being checked for NULL values (CARE_SITE_ID)
ERROR_TYPE: Severity of the issue (WARNING)
CDT_ID: Provider ID with NULL foreign key

LOGIC:
------
1. CTE identifies PROVIDER records where CARE_SITE_ID is NULL
2. Main query returns all records where ERROR_TYPE is not 'EXPECTED'
3. Results indicate potential data quality issues requiring review

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind, either express 
or implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/