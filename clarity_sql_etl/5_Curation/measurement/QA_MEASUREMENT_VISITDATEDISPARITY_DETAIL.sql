---------------------------------------------------------------------
-- QA_MEASUREMENT_VISITDATEDISPARITY_DETAIL
---------------------------------------------------------------------

WITH VISITDATEDISPARITY_DETAIL AS (
    SELECT 
        'MEASUREMENT_DATE' AS METRIC_FIELD,
        'VISIT_DATE_DISPARITY' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        MEASUREMENT_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS M
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
        ON M.VISIT_OCCURRENCE_ID = VO.VISIT_OCCURRENCE_ID
    WHERE
        -- Ensure valid visit occurrence IDs exist
        (M.VISIT_OCCURRENCE_ID IS NOT NULL
            AND M.VISIT_OCCURRENCE_ID <> 0
            AND VO.VISIT_OCCURRENCE_ID IS NOT NULL
            AND VO.VISIT_OCCURRENCE_ID <> 0)
        AND (
            -- Check if measurement date falls outside visit date range
            (M.MEASUREMENT_DATE < VO.VISIT_START_DATE
                OR M.MEASUREMENT_DATE > VO.VISIT_END_DATE)
            OR
            -- Check if measurement datetime falls outside visit datetime range
            (CAST(M.MEASUREMENT_DATETIME AS DATE) < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR CAST(M.MEASUREMENT_DATETIME AS DATE) > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            -- Check if measurement date falls outside visit datetime range
            (M.MEASUREMENT_DATE < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR M.MEASUREMENT_DATE > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            -- Check if measurement datetime falls outside visit date range
            (CAST(M.MEASUREMENT_DATETIME AS DATE) < VO.VISIT_START_DATE
                OR CAST(M.MEASUREMENT_DATETIME AS DATE) > VO.VISIT_END_DATE)
        )
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM VISITDATEDISPARITY_DETAIL;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Current date when the QA check is executed
STANDARD_DATA_TABLE: The primary table being validated (MEASUREMENT)
QA_METRIC: Type of QA check being performed (VISIT_DATE_DISPARITY)
METRIC_FIELD: The field being validated (MEASUREMENT_DATE)
ERROR_TYPE: Severity of the error (WARNING)
CDT_ID: The measurement_id from the source table

LOGIC EXPLANATION:
----------------
1. The query identifies measurements that have dates inconsistent with their associated visits
2. Checks are performed on both date and datetime fields to ensure measurements occurred within visit periods
3. Four different date comparison scenarios are checked:
   - Measurement date vs. Visit date
   - Measurement datetime vs. Visit datetime
   - Measurement date vs. Visit datetime
   - Measurement datetime vs. Visit date
4. Only records with valid visit_occurrence_ids are checked
5. Any measurement falling outside its visit period triggers a warning

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/