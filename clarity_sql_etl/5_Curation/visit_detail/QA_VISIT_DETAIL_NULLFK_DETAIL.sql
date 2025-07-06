/*********************************************************
Script Name: QA_VISIT_DETAIL_NULLFK_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
*********************************************************/

WITH NULLFK_DETAIL AS (
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        VISIT_DETAIL_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE (PERSON_ID IS NULL)

    UNION ALL

    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL_RAW AS T1
    WHERE (VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'VISIT_DETAIL' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLFK_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Quality assessment metric (NULL FK in this case)
METRIC_FIELD: Field being evaluated for null foreign keys
ERROR_TYPE: Classification of the error (WARNING or EXPECTED)
CDT_ID: Visit Detail ID or count of occurrences

LOGIC:
------
1. Identifies null foreign keys in VISIT_DETAIL_RAW table
2. Checks specifically for null PERSON_ID and VISIT_OCCURRENCE_ID
3. Excludes expected null values
4. Returns only WARNING type errors

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code
remains with you. Use at your own risk.
*********************************************************/