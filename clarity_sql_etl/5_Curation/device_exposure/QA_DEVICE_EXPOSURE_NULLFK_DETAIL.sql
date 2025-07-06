---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_NULLFK_DETAIL
-- Purpose:
-- This query performs quality assurance checks on the DEVICE_EXPOSURE_RAW table
-- by identifying null foreign key values in critical fields.
---------------------------------------------------------------------
WITH NULLFK_DETAIL AS (
    -- Check for null PROVIDER_ID
    SELECT 
        'PROVIDER_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (PROVIDER_ID IS NULL)

    UNION ALL

    -- Check for null VISIT_OCCURRENCE_ID
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for null PERSON_ID
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (PERSON_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLFK_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*
Column Descriptions:
- RUN_DATE: Current date when the QA check is performed
- STANDARD_DATA_TABLE: Name of the table being checked (DEVICE_EXPOSURE)
- QA_METRIC: Type of quality check being performed (NULL FK)
- METRIC_FIELD: The field being checked for null values
- ERROR_TYPE: Severity of the error (WARNING or FATAL)
- CDT_ID: The DEVICE_EXPOSURE_ID of the record with the null value

Logic:
1. Checks for null PROVIDER_ID (Warning level)
2. Checks for null VISIT_OCCURRENCE_ID (Warning level)
3. Checks for null PERSON_ID (Fatal level)
4. Excludes any 'EXPECTED' error types from the final results

Error Types:
- WARNING: Non-critical issues that should be reviewed
- FATAL: Critical issues that must be resolved

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/