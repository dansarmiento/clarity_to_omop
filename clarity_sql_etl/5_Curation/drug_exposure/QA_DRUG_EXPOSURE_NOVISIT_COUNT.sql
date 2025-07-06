---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_NOVISIT_COUNT
---------------------------------------------------------------------

WITH NOVISIT_COUNT AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NO VISIT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON DRUG_EXPOSURE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM NOVISIT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Current date when the query is executed
STANDARD_DATA_TABLE: Name of the table being analyzed (DRUG_EXPOSURE)
QA_METRIC: Type of quality check being performed (NO VISIT)
METRIC_FIELD: Field being checked (VISIT_OCCURRENCE_ID)
QA_ERRORS: Count of records that failed the quality check
ERROR_TYPE: Type of error (WARNING if errors exist, NULL if no errors)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. The CTE (NOVISIT_COUNT) identifies drug exposure records that don't have 
   a corresponding visit record in the VISIT_OCCURRENCE_RAW table
2. The main query aggregates the results and adds metadata including:
   - Current run date
   - Table name
   - Error counts
   - Total record counts from both raw and clean tables
3. WARNING is only shown when errors exist (CNT > 0)

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/