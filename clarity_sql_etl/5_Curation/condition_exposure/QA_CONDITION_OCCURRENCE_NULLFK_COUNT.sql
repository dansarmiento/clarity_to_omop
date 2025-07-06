/*******************************************************************************
* QA_CONDITION_OCCURRENCE_NULLFK_COUNT
* 
* This query checks for null foreign keys in the CONDITION_OCCURRENCE_RAW table
* and provides quality assurance metrics.
*******************************************************************************/

WITH NULLFK_COUNT AS (
    -- Check for null VISIT_OCCURRENCE_ID (Warning level)
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    WHERE (VISIT_OCCURRENCE_ID IS NULL)

    UNION ALL

    -- Check for null PERSON_ID (Fatal level)
    SELECT 
        'PERSON_ID' AS METRIC_FIELD,
        'NULL FK' AS QA_METRIC,
        'FATAL' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    WHERE (PERSON_ID IS NULL)
)

-- Final result set
SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM NULLFK_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Current date when the QA check is performed
* STANDARD_DATA_TABLE: Name of the table being checked
* QA_METRIC: Type of quality check being performed
* METRIC_FIELD: Field being evaluated
* QA_ERRORS: Count of records with errors
* ERROR_TYPE: Severity of the error (WARNING or FATAL)
* TOTAL_RECORDS: Total number of records in the raw table
* TOTAL_RECORDS_CLEAN: Total number of records in the clean table
*
* Logic:
* ------
* 1. Checks for null values in two foreign key fields:
*    - VISIT_OCCURRENCE_ID (Warning level)
*    - PERSON_ID (Fatal level)
* 2. Counts occurrences of null values for each field
* 3. Combines results with metadata about the check
* 4. Includes comparison between raw and clean table record counts

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/