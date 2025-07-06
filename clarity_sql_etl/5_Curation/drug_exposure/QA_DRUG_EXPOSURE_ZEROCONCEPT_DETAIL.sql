---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_ZEROCONCEPT_DETAIL
-- Purpose:
-- This query identifies records in the DRUG_EXPOSURE_RAW table where concept IDs are zero,
-- which may indicate missing or invalid data.
---------------------------------------------------------------------

WITH ZEROCONCEPT_DETAIL AS (
    -- Check for zero concepts in DRUG_CONCEPT_ID
    SELECT 
        'DRUG_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    WHERE (DRUG_CONCEPT_ID = 0)

    UNION ALL

    -- Check for zero concepts in DRUG_TYPE_CONCEPT_ID
    SELECT 
        'DRUG_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    WHERE (DRUG_TYPE_CONCEPT_ID = 0)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Always 'DRUG_EXPOSURE' to identify the source table
- QA_METRIC: Always 'ZERO CONCEPT' to indicate the type of quality check
- METRIC_FIELD: Identifies which field contains the zero concept (DRUG_CONCEPT_ID or DRUG_TYPE_CONCEPT_ID)
- ERROR_TYPE: Set to 'WARNING' for these cases
- CDT_ID: The DRUG_EXPOSURE_ID of the problematic record

Logic:
1. The CTE 'ZEROCONCEPT_DETAIL' checks for two types of zero concepts:
   - Records where DRUG_CONCEPT_ID = 0
   - Records where DRUG_TYPE_CONCEPT_ID = 0
2. Results are combined using UNION ALL
3. Final query filters out any 'EXPECTED' error types and adds the run date

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/