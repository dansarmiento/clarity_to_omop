---------------------------------------------------------------------
-- QA_DEVICE_EXPOSURE_NOVISIT_COUNT
---------------------------------------------------------------------

-- Common Table Expression to count devices without associated visits
WITH CTE_NO_VISIT_COUNT AS (
    SELECT 
        'DEVICE_EXPOSURE' AS STANDARD_DATA_TABLE,
        'DEVICE_CONCEPT_ID' AS METRIC_FIELD,
        'NO VISIT' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE 
        ON DEVICE_EXPOSURE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

-- Main query to generate QA metrics
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN 'FATAL' 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM CTE_NO_VISIT_COUNT
GROUP BY STANDARD_DATA_TABLE, METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Current date when the QA check is executed
STANDARD_DATA_TABLE: Name of the table being analyzed (DEVICE_EXPOSURE)
QA_METRIC: Type of QA check being performed (NO VISIT)
METRIC_FIELD: Field being evaluated (DEVICE_CONCEPT_ID)
QA_ERRORS: Count of records that failed the QA check
ERROR_TYPE: Indicates severity of the error (FATAL if errors exist, NULL if no errors)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. CTE identifies device exposure records that don't have a corresponding visit record
2. Main query aggregates results and adds metadata including:
   - Current run date
   - Error counts
   - Total record counts from both raw and clean tables
3. FATAL error is assigned when devices without visits are found
4. Comparison between raw and clean table counts helps track data cleaning impact

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/