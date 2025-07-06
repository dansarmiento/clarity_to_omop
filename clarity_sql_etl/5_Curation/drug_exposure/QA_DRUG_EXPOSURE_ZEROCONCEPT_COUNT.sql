---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_ZEROCONCEPT_COUNT
---------------------------------------------------------------------

WITH ZEROCONCEPT_COUNT AS (
    -- Check for zero concepts in DRUG_CONCEPT_ID
    SELECT 
        'DRUG_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    WHERE (DRUG_CONCEPT_ID = 0)

    UNION ALL

    -- Check for zero concepts in DRUG_TYPE_CONCEPT_ID
    SELECT 
        'DRUG_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    WHERE (DRUG_TYPE_CONCEPT_ID = 0)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM ZEROCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being checked
QA_ERRORS: Number of records failing the quality check
ERROR_TYPE: Severity of the error (WARNING in this case)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. The CTE 'ZEROCONCEPT_COUNT' identifies records where either:
   - DRUG_CONCEPT_ID = 0
   - DRUG_TYPE_CONCEPT_ID = 0

2. The main query:
   - Combines results from both checks
   - Adds metadata (run date, table name)
   - Calculates total error counts
   - Includes record counts from both raw and clean tables
   - Groups results by metric field and QA metric

PURPOSE:
--------
This query identifies records in the DRUG_EXPOSURE table where concept IDs
are zero, which may indicate mapping or data quality issues.

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/