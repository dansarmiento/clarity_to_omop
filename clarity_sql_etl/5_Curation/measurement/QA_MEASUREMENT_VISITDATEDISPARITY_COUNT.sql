---------------------------------------------------------------------
-- QA_MEASUREMENT_VISITDATEDISPARITY_COUNT
-- Purpose:
-- This query identifies measurements with date disparities between the measurement dates 
-- and their associated visit dates in the OMOP CDM.
---------------------------------------------------------------------

WITH VISITDATEDISPARITY_COUNT AS (
    SELECT 
        'MEASUREMENT_DATE' AS METRIC_FIELD,
        'VISIT_DATE_DISPARITY' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS M
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
        ON M.VISIT_OCCURRENCE_ID = VO.VISIT_OCCURRENCE_ID
    WHERE
        -- MUST HAVE POPULATED VISIT OCCURRENCE ID
        (M.VISIT_OCCURRENCE_ID IS NOT NULL
            AND M.VISIT_OCCURRENCE_ID <> 0
            AND VO.VISIT_OCCURRENCE_ID IS NOT NULL
            AND VO.VISIT_OCCURRENCE_ID <> 0)
        AND (
            -- PROBLEM WITH PROCEDURE DATE
            (M.MEASUREMENT_DATE < VO.VISIT_START_DATE
                OR M.MEASUREMENT_DATE > VO.VISIT_END_DATE)
            OR
            -- PROBLEM WITH DATETIME
            (CAST(M.MEASUREMENT_DATETIME AS DATE) < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR CAST(M.MEASUREMENT_DATETIME AS DATE) > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            -- PROBLEM WITH THE DATETIME (EXTRACTING DATE FOR COMPARISON)
            (M.MEASUREMENT_DATE < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR M.MEASUREMENT_DATE > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            -- PROBLEM WITH THE DATETIME
            (CAST(M.MEASUREMENT_DATETIME AS DATE) < VO.VISIT_START_DATE
                OR CAST(M.MEASUREMENT_DATETIME AS DATE) > VO.VISIT_END_DATE)
        )
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'MEASUREMENT' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT) AS TOTAL_RECORDS_CLEAN
FROM VISITDATEDISPARITY_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Indicates the table being analyzed (MEASUREMENT)
- QA_METRIC: Type of quality check being performed (VISIT_DATE_DISPARITY)
- METRIC_FIELD: Field being analyzed (MEASUREMENT_DATE)
- QA_ERRORS: Count of records with date disparities
- ERROR_TYPE: Indicates severity of the error (WARNING)
- TOTAL_RECORDS: Total count of records in the raw measurement table
- TOTAL_RECORDS_CLEAN: Total count of records in the clean measurement table

Logic:
1. Checks for measurements where:
   - Visit occurrence ID exists and is valid
   - Measurement date falls outside the visit start/end dates
   - Measurement datetime falls outside the visit start/end datetimes
2. Includes various date/datetime comparisons to catch all possible disparities
3. Returns aggregate counts of problematic records

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/