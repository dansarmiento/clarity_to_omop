---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_NULL_CONCEPT_COUNT
---------------------------------------------------------------------

WITH CTE_ERROR_COUNT AS (
    -- Check for null DEVICE_CONCEPT_ID
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (DEVICE_CONCEPT_ID IS NULL)
    
    UNION ALL
    
    -- Check for null DEVICE_TYPE_CONCEPT_ID
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_TYPE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (DEVICE_TYPE_CONCEPT_ID IS NULL)
    
    UNION ALL
    
    -- Check for null DEVICE_SOURCE_CONCEPT_ID
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_SOURCE_CONCEPT_ID' AS METRIC_FIELD,
        'NULL CONCEPT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    WHERE (DEVICE_SOURCE_CONCEPT_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE AS DEVICE_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM CTE_ERROR_COUNT
GROUP BY 
    STANDARD_DATA_TABLE, 
    METRIC_FIELD, 
    QA_METRIC, 
    ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked (DEVICE_EXPOSURE)
QA_METRIC: Type of quality check being performed (NULL CONCEPT)
METRIC_FIELD: Specific field being checked for nulls
QA_ERRORS: Count of records with null values
ERROR_TYPE: Severity of the error (FATAL if errors exist, NULL if no errors)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. CTE checks for null values in three concept ID fields:
   - DEVICE_CONCEPT_ID
   - DEVICE_TYPE_CONCEPT_ID
   - DEVICE_SOURCE_CONCEPT_ID
2. Main query aggregates results and adds metadata including:
   - Current run date
   - Total record counts from both raw and clean tables
3. Error type is set to FATAL when null values are found

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/