---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_VISITDATEDISPARITY_COUNT
---------------------------------------------------------------------

WITH VISITDATEDISPARITY_COUNT AS (
    SELECT 
        'DRUG_EXPOSURE_START_DATE' AS METRIC_FIELD,
        'VISIT_DATE_DISPARITY' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
        ON DE.VISIT_OCCURRENCE_ID = VO.VISIT_OCCURRENCE_ID
    WHERE
        -- MUST HAVE POPULATED VISIT OCCURRENCE ID
        (   DE.VISIT_OCCURRENCE_ID IS NOT NULL
            AND DE.VISIT_OCCURRENCE_ID <> 0
            AND VO.VISIT_OCCURRENCE_ID IS NOT NULL
            AND VO.VISIT_OCCURRENCE_ID <> 0  )
        AND (
            -- PROBLEM WITH PROCEDURE DATE
            (DE.DRUG_EXPOSURE_START_DATE < VO.VISIT_START_DATE
                OR DE.DRUG_EXPOSURE_START_DATE > VO.VISIT_END_DATE)
            OR
            -- PROBLEM WITH DATETIME
            (CAST(DE.DRUG_EXPOSURE_START_DATETIME AS DATE) < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR CAST(DE.DRUG_EXPOSURE_START_DATETIME AS DATE) > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            -- PROBLEM WITH THE DATETIME (EXTRACTING DATE FOR COMPARISON)
            (DE.DRUG_EXPOSURE_START_DATE < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR DE.DRUG_EXPOSURE_START_DATE > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            --PROBLEM WITH THE DATETIME
            (CAST(DE.DRUG_EXPOSURE_START_DATETIME AS DATE) < VO.VISIT_START_DATE
                OR CAST(DE.DRUG_EXPOSURE_START_DATETIME AS DATE) > VO.VISIT_END_DATE))
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE) AS TOTAL_RECORDS_CLEAN
FROM VISITDATEDISPARITY_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being evaluated
QA_ERRORS: Count of records that failed the QA check
ERROR_TYPE: Classification of the error (WARNING in this case)
TOTAL_RECORDS: Total number of records in the raw table
TOTAL_RECORDS_CLEAN: Total number of records in the clean table

LOGIC:
------
1. The query identifies drug exposure records where the exposure dates fall outside 
   the associated visit dates
2. Checks are performed on both DATE and DATETIME fields
3. Four different date comparison scenarios are evaluated:
   - Direct date comparison
   - Datetime to datetime comparison (cast to date)
   - Date to datetime comparison
   - Datetime to date comparison
4. Only considers records with valid visit occurrence IDs
5. Returns a warning when drug exposure dates don't align with visit dates

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/