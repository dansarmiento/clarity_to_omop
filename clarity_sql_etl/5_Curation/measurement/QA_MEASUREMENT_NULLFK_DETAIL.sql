---------------------------------------------------------------------
-- QA_MEASUREMENT_NULLFK_DETAIL
-- Purpose:
-- This query performs quality assurance checks on the MEASUREMENT_RAW table by identifying null foreign keys.
---------------------------------------------------------------------

WITH NULLFK_DETAIL AS (
    -- Check for null VISIT_OCCURRENCE_ID
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        MEASUREMENT_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for null PERSON_ID
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        MEASUREMENT_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT
    WHERE (PERSON_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLFK_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*
Column Descriptions:
- RUN_DATE: The date when the QA check was performed
- STANDARD_DATA_TABLE: The name of the table being checked (MEASUREMENT)
- QA_METRIC: The type of QA check being performed (NULL FK)
- METRIC_FIELD: The field being checked for null values
- ERROR_TYPE: Severity of the error (WARNING or FATAL)
- CDT_ID: The MEASUREMENT_ID of the record with the null value

Logic:
1. The CTE 'NULLFK_DETAIL' checks for two types of null foreign keys:
   - VISIT_OCCURRENCE_ID (Warning level)
   - PERSON_ID (Fatal level)
2. Results are combined using UNION ALL
3. Final query excludes any 'EXPECTED' error types
4. Results show only records with issues that need attention

Error Types:
- WARNING: Less severe issues that should be reviewed
- FATAL: Critical issues that must be resolved

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/