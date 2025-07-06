-- QA_CONDITION_OCCURRENCE_NULLFK_DETAIL

-- Purpose:
-- This query performs quality assurance checks on the CONDITION_OCCURRENCE_RAW table 
-- by identifying null foreign key values.
---------------------------------------------------------------------

WITH NULLFK_DETAIL AS (
    -- Check for null VISIT_OCCURRENCE_ID
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        CONDITION_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for null PERSON_ID
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        CONDITION_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    WHERE (PERSON_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLFK_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*

Column Descriptions:
- RUN_DATE: The date when the QA check was performed
- STANDARD_DATA_TABLE: The name of the table being checked
- QA_METRIC: The type of quality check being performed (NULL FK in this case)
- METRIC_FIELD: The field being checked for null values
- ERROR_TYPE: Severity of the error (WARNING or FATAL)
- CDT_ID: The CONDITION_OCCURRENCE_ID of the problematic record

Logic:
1. Checks for null VISIT_OCCURRENCE_ID (Warning level error)
2. Checks for null PERSON_ID (Fatal level error)
3. Combines results and excludes any 'EXPECTED' error types
4. Returns only records with issues that need attention

Error Types:
- WARNING: Less severe issues that should be reviewed
- FATAL: Critical issues that must be resolved

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/