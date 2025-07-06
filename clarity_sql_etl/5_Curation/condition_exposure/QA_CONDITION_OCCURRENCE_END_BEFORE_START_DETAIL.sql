/*******************************************************************************
* QA_CONDITION_OCCURRENCE_END_BEFORE_START_DETAIL
* This query identifies condition occurrences where the end date is before the start date
*******************************************************************************/

WITH END_BEFORE_START_DETAIL AS (
    SELECT 
        'CONDITION_END_DATETIME' AS METRIC_FIELD,
        'END_BEFORE_START' AS QA_METRIC,
        'INVALID DATA' AS ERROR_TYPE,
        CONDITION_OCCURRENCE_ID AS CDT_ID
    FROM 
        CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE
    WHERE 
        CONDITION_END_DATETIME < CONDITION_START_DATETIME
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM 
    END_BEFORE_START_DETAIL;

/*******************************************************************************
* Column Descriptions:
* --------------------
* RUN_DATE: The date when the QA check was performed
* STANDARD_DATA_TABLE: The name of the table being checked (CONDITION_OCCURRENCE)
* QA_METRIC: The type of QA check being performed (END_BEFORE_START)
* METRIC_FIELD: The field being evaluated (CONDITION_END_DATETIME)
* ERROR_TYPE: The category of error found (INVALID DATA)
* CDT_ID: The CONDITION_OCCURRENCE_ID of the record with the error
*
* Logic:
* ------
* 1. The CTE identifies condition occurrences where the end datetime is earlier 
*    than the start datetime (logically impossible)
* 2. The main query adds metadata about the QA check and formats the output
* 3. This helps identify data quality issues in the temporal aspects of 
*    condition records

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/