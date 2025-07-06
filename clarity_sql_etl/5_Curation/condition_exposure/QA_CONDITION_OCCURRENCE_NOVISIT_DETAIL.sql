/*******************************************************************************
* QA_CONDITION_OCCURRENCE_NOVISIT_DETAIL
* This query identifies condition occurrences that don't have associated visits
* Purpose:
* --------
* Quality assurance check to identify condition records that don't have
* corresponding visit records, which might indicate data completeness issues.
*******************************************************************************/
WITH NOVISIT_DETAIL AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD,
        'NO VISIT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        CONDITION_OCCURRENCE_ID AS CDT_ID
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
    ERROR_TYPE,
    CDT_ID
FROM NOVISIT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED'

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Current date when the query is executed
* STANDARD_DATA_TABLE: Name of the table being analyzed (CONDITION_OCCURRENCE)
* QA_METRIC: Type of quality check being performed (NO VISIT)
* METRIC_FIELD: Field being evaluated (VISIT_OCCURRENCE_ID)
* ERROR_TYPE: Severity of the issue (WARNING)
* CDT_ID: Condition occurrence ID with missing visit information
*
* Logic:
* ------
* 1. Creates a CTE (NOVISIT_DETAIL) that:
*    - Joins condition_occurrence with visit_occurrence
*    - Identifies records where visit_occurrence_id doesn't exist in visit table
* 
* 2. Main query:
*    - Adds metadata (run date, table name)
*    - Returns only non-'EXPECTED' error types
*    - Provides details about conditions missing visit information

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/