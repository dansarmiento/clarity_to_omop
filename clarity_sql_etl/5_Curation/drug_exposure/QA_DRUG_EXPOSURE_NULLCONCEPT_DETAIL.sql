---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_NULLCONCEPT_DETAIL
-- Purpose:
-- This query identifies records in the DRUG_EXPOSURE_RAW table where critical concept IDs are null.
---------------------------------------------------------------------

WITH NULLCONCEPT_DETAIL AS (
    -- Check for null Drug Concept IDs
    SELECT 
        'DRUG_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    WHERE (DRUG_CONCEPT_ID IS NULL)

    UNION ALL

    -- Check for null Drug Type Concept IDs
    SELECT 
        'DRUG_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    WHERE (DRUG_TYPE_CONCEPT_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*
Column Descriptions:
- RUN_DATE: Current date when the QA check is performed
- STANDARD_DATA_TABLE: Name of the table being checked (DRUG_EXPOSURE)
- QA_METRIC: Type of quality check being performed (NULL CONCEPT)
- METRIC_FIELD: Specific field being checked for nulls
- ERROR_TYPE: Severity of the error (FATAL in this case)
- CDT_ID: The DRUG_EXPOSURE_ID of the problematic record

Logic:
1. The CTE NULLCONCEPT_DETAIL checks for two types of null concepts:
   - Null DRUG_CONCEPT_ID
   - Null DRUG_TYPE_CONCEPT_ID
2. Results are combined using UNION ALL
3. Final query filters out any 'EXPECTED' errors and adds metadata

Error Types:
- FATAL: Indicates a critical data quality issue that must be addressed

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/