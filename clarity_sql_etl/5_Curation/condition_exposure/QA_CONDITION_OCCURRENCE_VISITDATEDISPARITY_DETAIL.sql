/*******************************************************************************
 * QA_CONDITION_OCCURRENCE_VISITDATEDISPARITY_DETAIL
 * This query identifies condition occurrences where the condition dates fall 
 * outside of their associated visit dates
 *******************************************************************************/

WITH VISITDATEDISPARITY_DETAIL AS (
    SELECT 
        'CONDITION_START_DATE' AS METRIC_FIELD,
        'VISIT_DATE_DISPARITY' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        CONDITION_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CO
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
        ON CO.VISIT_OCCURRENCE_ID = VO.VISIT_OCCURRENCE_ID
    WHERE
        -- Ensure valid visit occurrence IDs exist
        (CO.VISIT_OCCURRENCE_ID IS NOT NULL
         AND CO.VISIT_OCCURRENCE_ID <> 0
         AND VO.VISIT_OCCURRENCE_ID IS NOT NULL
         AND VO.VISIT_OCCURRENCE_ID <> 0)
        AND (
            -- Check if condition date is outside visit date range
            (CO.CONDITION_START_DATE < VO.VISIT_START_DATE
             OR CO.CONDITION_START_DATE > VO.VISIT_END_DATE)
            OR
            -- Check if condition datetime is outside visit datetime range
            (CAST(CO.CONDITION_START_DATETIME AS DATE) < CAST(VO.VISIT_START_DATETIME AS DATE)
             OR CAST(CO.CONDITION_START_DATETIME AS DATE) > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            -- Check if condition date is outside visit datetime range
            (CO.CONDITION_START_DATE < CAST(VO.VISIT_START_DATETIME AS DATE)
             OR CO.CONDITION_START_DATE > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            -- Check if condition datetime is outside visit date range
            (CAST(CO.CONDITION_START_DATETIME AS DATE) < VO.VISIT_START_DATE
             OR CAST(CO.CONDITION_START_DATETIME AS DATE) > VO.VISIT_END_DATE)
        )
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM VISITDATEDISPARITY_DETAIL;

/*******************************************************************************
 * Column Descriptions:
 * ------------------
 * RUN_DATE: Current date when the query is executed
 * STANDARD_DATA_TABLE: Name of the table being analyzed (CONDITION_OCCURRENCE)
 * QA_METRIC: Type of quality check being performed (VISIT_DATE_DISPARITY)
 * METRIC_FIELD: Field being evaluated (CONDITION_START_DATE)
 * ERROR_TYPE: Severity of the issue (WARNING)
 * CDT_ID: Condition occurrence ID with the date disparity
 *
 * Logic:
 * ------
 * 1. Identifies condition records with valid visit occurrence IDs
 * 2. Checks for four types of date mismatches:
 *    - Condition date vs. Visit date
 *    - Condition datetime vs. Visit datetime
 *    - Condition date vs. Visit datetime
 *    - Condition datetime vs. Visit date
 * 3. Returns records where any of these date comparisons show the condition
 *    occurred outside the visit timeframe
 
LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
 *******************************************************************************/