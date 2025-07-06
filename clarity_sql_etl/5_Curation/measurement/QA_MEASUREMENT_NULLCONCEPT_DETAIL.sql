---------------------------------------------------------------------
-- QA_MEASUREMENT_NULLCONCEPT_DETAIL
-- Purpose:
-- This query identifies records in the MEASUREMENT_RAW table where specific concept IDs are null,
-- which could indicate data quality issues.
---------------------------------------------------------------------

WITH NULLCONCEPT_DETAIL AS (
    -- Check for null MEASUREMENT_CONCEPT_ID
    SELECT 
        'MEASUREMENT_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        MEASUREMENT_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    WHERE (MEASUREMENT_CONCEPT_ID IS NULL)

    UNION ALL

    -- Check for null OPERATOR_CONCEPT_ID
    SELECT 
        'OPERATOR_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        MEASUREMENT_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    WHERE (OPERATOR_CONCEPT_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Always set to 'MEASUREMENT' to identify the source table
- QA_METRIC: Set to 'NULL CONCEPT' to indicate the type of quality check
- METRIC_FIELD: Identifies which concept field is being checked (MEASUREMENT_CONCEPT_ID or OPERATOR_CONCEPT_ID)
- ERROR_TYPE: Set to 'FATAL' for these checks as null concepts are considered critical errors
- CDT_ID: The MEASUREMENT_ID from the source record with the issue

Logic:
1. The CTE checks for null values in two concept fields:
   - MEASUREMENT_CONCEPT_ID
   - OPERATOR_CONCEPT_ID
2. Results are combined using UNION ALL
3. Final query filters out any 'EXPECTED' errors (though none are marked as such in this case)
4. Results show only records with critical data quality issues

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.

*/