/***************************************************************
 * QA_CONDITION_OCCURRENCE_NOVISIT_COUNT
 * 
 * Checks for condition occurrences that don't have an associated visit
 ***************************************************************/

WITH NOVISIT_COUNT AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NO VISIT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON CONDITION_OCCURRENCE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID 
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE_RAW,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM NOVISIT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/***************************************************************
 * Column Descriptions:
 * RUN_DATE - Date QA check was executed
 * STANDARD_DATA_TABLE - Name of table being checked
 * QA_METRIC - Description of QA check performed
 * METRIC_FIELD - Field being validated
 * QA_ERRORS - Count of records failing QA check
 * ERROR_TYPE_RAW - Severity of QA error (WARNING/ERROR)
 * TOTAL_RECORDS - Total count of records in raw table
 * TOTAL_RECORDS_CLEAN - Total count of records in clean table
 *
 * Logic:
 * 1. Identifies condition records that don't have a matching visit_occurrence_id
 * 2. Counts number of records missing visits
 * 3. Returns QA metrics including error counts and total record counts
 * 4. Flags missing visits as WARNING level issues
 
LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
 ***************************************************************/