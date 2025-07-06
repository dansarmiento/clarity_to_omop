/*******************************************************************************
* QA_CONDITION_OCCURRENCE_VISITDATEDISPARITY_COUNT
* 
* This query identifies discrepancies between condition dates and their associated 
* visit dates in the CONDITION_OCCURRENCE table.
*******************************************************************************/

WITH VISITDATEDISPARITY_COUNT AS (
    SELECT 
        'CONDITION_START_DATE' AS METRIC_FIELD,
        'VISIT_DATE_DISPARITY' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CO
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
        ON CO.VISIT_OCCURRENCE_ID = VO.VISIT_OCCURRENCE_ID
    WHERE
        -- Ensure valid visit occurrence IDs exist
        (   CO.VISIT_OCCURRENCE_ID IS NOT NULL
            AND CO.VISIT_OCCURRENCE_ID <> 0
            AND VO.VISIT_OCCURRENCE_ID IS NOT NULL
            AND VO.VISIT_OCCURRENCE_ID <> 0   )
        AND (
            -- Check for date inconsistencies using DATE format
            (   CO.CONDITION_START_DATE < VO.VISIT_START_DATE
                OR CO.CONDITION_START_DATE > VO.VISIT_END_DATE)
            OR
            -- Check for date inconsistencies using DATETIME format
            (   CAST(CO.CONDITION_START_DATETIME AS DATE) < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR CAST(CO.CONDITION_START_DATETIME AS DATE) > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            -- Check for mixed format inconsistencies (DATE vs DATETIME)
            (   CO.CONDITION_START_DATE < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR CO.CONDITION_START_DATE > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            (   CAST(CO.CONDITION_START_DATETIME AS DATE) < VO.VISIT_START_DATE
                OR CAST(CO.CONDITION_START_DATETIME AS DATE) > VO.VISIT_END_DATE))
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'CONDITION_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM VISITDATEDISPARITY_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Current date when the QA check is performed
* STANDARD_DATA_TABLE: Name of the table being checked
* QA_METRIC: Type of quality check being performed
* METRIC_FIELD: Specific field being evaluated
* QA_ERRORS: Number of records with date discrepancies
* ERROR_TYPE: Severity level of the error (WARNING in this case)
* TOTAL_RECORDS: Total number of records in the raw table
* TOTAL_RECORDS_CLEAN: Total number of records in the clean table
*
* Logic:
* ------
* 1. Identifies conditions where the start date falls outside the visit date range
* 2. Checks for inconsistencies across different date formats (DATE vs DATETIME)
* 3. Only considers records with valid visit occurrence IDs
* 4. Compares both raw and clean table record counts

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*******************************************************************************/