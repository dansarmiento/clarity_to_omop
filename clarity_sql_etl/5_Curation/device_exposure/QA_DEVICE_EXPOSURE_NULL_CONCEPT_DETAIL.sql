---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_NULL_CONCEPT_DETAIL
---------------------------------------------------------------------

WITH CTE_ERROR_DETAIL AS (
    -- Check for null DEVICE_CONCEPT_ID
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (DEVICE_CONCEPT_ID IS NULL)
    
    UNION ALL
    
    -- Check for null DEVICE_TYPE_CONCEPT_ID
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (DEVICE_TYPE_CONCEPT_ID IS NULL)
    
    UNION ALL
    
    -- Check for null DEVICE_SOURCE_CONCEPT_ID
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_SOURCE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (DEVICE_SOURCE_CONCEPT_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM CTE_ERROR_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*
DOCUMENTATION:

Purpose:
This query identifies null concept IDs in the DEVICE_EXPOSURE_RAW table that are considered fatal errors.

Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked (DEVICE_EXPOSURE)
- QA_METRIC: Type of quality check being performed (NULL CONCEPT)
- METRIC_FIELD: Specific field being checked for nulls
- ERROR_TYPE: Severity of the error (FATAL)
- CDT_ID: DEVICE_EXPOSURE_ID of the record with the error

Logic:
1. Creates a CTE that checks for null values in three concept ID fields:
   - DEVICE_CONCEPT_ID
   - DEVICE_TYPE_CONCEPT_ID
   - DEVICE_SOURCE_CONCEPT_ID
2. Combines results using UNION ALL
3. Returns only FATAL errors (excludes 'EXPECTED' errors)
4. Each record represents a null concept ID that needs to be addressed

Note: All null concepts are marked as FATAL errors, indicating they must be resolved
before the data can be considered valid.

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/