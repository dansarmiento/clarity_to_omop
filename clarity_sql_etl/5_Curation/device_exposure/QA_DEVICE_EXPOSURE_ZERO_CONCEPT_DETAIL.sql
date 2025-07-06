---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_ZERO_CONCEPT_DETAIL
-- This query identifies records in the DEVICE_EXPOSURE table where concept IDs are set to zero,
-- which may indicate missing or invalid data.
---------------------------------------------------------------------

WITH CTE_ERROR_DETAIL AS (
    -- Check for zero concept IDs in DEVICE_CONCEPT_ID
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (DEVICE_CONCEPT_ID = 0)
    
    UNION ALL
    
    -- Check for zero concept IDs in DEVICE_TYPE_CONCEPT_ID
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DEVICE_EXPOSURE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (DEVICE_TYPE_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM CTE_ERROR_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked (DEVICE_EXPOSURE)
- QA_METRIC: Type of quality check being performed (ZERO CONCEPT)
- METRIC_FIELD: Specific field being checked (DEVICE_CONCEPT_ID or DEVICE_TYPE_CONCEPT_ID)
- ERROR_TYPE: Severity of the issue (WARNING)
- CDT_ID: DEVICE_EXPOSURE_ID of the problematic record

Logic:
1. CTE identifies two types of zero concept issues:
   - Records where DEVICE_CONCEPT_ID = 0
   - Records where DEVICE_TYPE_CONCEPT_ID = 0
2. Results are combined using UNION ALL
3. Only WARNING type errors are included in final output
4. Each record represents a potential data quality issue that needs review

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/