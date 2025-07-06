/*********************************************************
Script Name: QA_OBSERVATION_VISITDATEDISPARITY_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Identifies discrepancies between observation dates and visit dates
*********************************************************/

WITH VISITDATEDISPARITY_COUNT AS (
    SELECT 
        'OBSERVATION_DATE' AS METRIC_FIELD, 
        'VISIT_DATE_DISPARITY' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS O
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
        ON O.VISIT_OCCURRENCE_ID = VO.VISIT_OCCURRENCE_ID
    WHERE
        -- MUST HAVE POPULATED VISIT OCCURRENCE ID
        (O.VISIT_OCCURRENCE_ID IS NOT NULL
            AND O.VISIT_OCCURRENCE_ID <> 0
            AND O.VISIT_OCCURRENCE_ID IS NOT NULL
            AND O.VISIT_OCCURRENCE_ID <> 0)
        AND (
            -- PROBLEM WITH OBSERVATION DATE
            (O.OBSERVATION_DATE < VO.VISIT_START_DATE
                OR O.OBSERVATION_DATE > VO.VISIT_END_DATE)
            OR
            -- PROBLEM WITH DATETIME
            (CAST(O.OBSERVATION_DATETIME AS DATE) < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR CAST(O.OBSERVATION_DATETIME AS DATE) > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            -- PROBLEM WITH THE DATETIME (EXTRACTING DATE FOR COMPARISON)
            (O.OBSERVATION_DATE < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR O.OBSERVATION_DATE > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            --PROBLEM WITH THE DATETIME
            (CAST(O.OBSERVATION_DATETIME AS DATE) < VO.VISIT_START_DATE
                OR CAST(O.OBSERVATION_DATETIME AS DATE) > VO.VISIT_END_DATE))
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'OBSERVATION' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION) AS TOTAL_RECORDS_CLEAN
FROM VISITDATEDISPARITY_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Field being evaluated
QA_ERRORS: Count of records with date discrepancies
ERROR_TYPE: Classification of the error (WARNING in this case)
TOTAL_RECORDS: Total count of records in the raw table
TOTAL_RECORDS_CLEAN: Total count of records in the clean table

Logic:
------
1. Identifies observations where the observation date/datetime falls outside
   the visit start and end dates/datetimes
2. Checks for discrepancies using both DATE and DATETIME formats
3. Only considers records with valid VISIT_OCCURRENCE_ID values

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind, either express 
or implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*********************************************************/