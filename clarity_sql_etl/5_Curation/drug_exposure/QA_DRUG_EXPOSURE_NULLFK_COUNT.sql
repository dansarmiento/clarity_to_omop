---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_NULLFK_COUNT
-- Purpose:
-- This query performs quality assurance checks on the DRUG_EXPOSURE_RAW table by identifying null foreign keys.
---------------------------------------------------------------------

WITH NULLFK_COUNT AS (
    -- Check for null VISIT_OCCURRENCE_ID
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for null PERSON_ID
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    WHERE (PERSON_ID IS NULL)
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
FROM NULLFK_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
Column Descriptions:
- RUN_DATE: Current date when the QA check is performed
- STANDARD_DATA_TABLE: Name of the table being checked (DRUG_EXPOSURE)
- QA_METRIC: Type of quality check being performed (NULL FK)
- METRIC_FIELD: Field being checked for nulls
- QA_ERRORS: Count of records with null values
- ERROR_TYPE: Severity of the error (WARNING or FATAL)
- TOTAL_RECORDS: Total number of records in the raw table
- TOTAL_RECORDS_CLEAN: Total number of records in the clean table

Logic:
1. Creates a CTE to check for null values in two foreign key fields:
   - VISIT_OCCURRENCE_ID (Warning level)
   - PERSON_ID (Fatal level)
2. Combines results and adds metadata about the QA check
3. Returns summary statistics including total record counts for both raw and clean tables

Error Types:
- WARNING: Less severe issues that may need attention
- FATAL: Critical issues that must be resolved

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/