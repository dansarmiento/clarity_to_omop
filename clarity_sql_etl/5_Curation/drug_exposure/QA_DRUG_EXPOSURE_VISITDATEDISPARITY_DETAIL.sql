---------------------------------------------------------------------
-- QA_DRUG_EXPOSURE_VISITDATEDISPARITY_DETAIL
-- Purpose:
-- This query identifies drug exposure records where the drug exposure dates fall outside 
-- the associated visit dates, which may indicate data quality issues.
---------------------------------------------------------------------

WITH VISITDATEDISPARITY_DETAIL AS (
    SELECT 
        'DRUG_EXPOSURE_START_DATE' AS METRIC_FIELD,
        'VISIT_DATE_DISPARITY' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        DRUG_EXPOSURE_ID AS CDT_ID
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
            -- PROBLEM WITH THE DATETIME
            (CAST(DE.DRUG_EXPOSURE_START_DATETIME AS DATE) < VO.VISIT_START_DATE
                OR CAST(DE.DRUG_EXPOSURE_START_DATETIME AS DATE) > VO.VISIT_END_DATE))
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'DRUG_EXPOSURE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM VISITDATEDISPARITY_DETAIL;

/*
Column Descriptions:
- RUN_DATE: Current date when the query is executed
- STANDARD_DATA_TABLE: Constant value 'DRUG_EXPOSURE' indicating the source table
- QA_METRIC: Type of quality check being performed ('VISIT_DATE_DISPARITY')
- METRIC_FIELD: Field being checked ('DRUG_EXPOSURE_START_DATE')
- ERROR_TYPE: Severity of the issue ('WARNING')
- CDT_ID: Drug exposure ID with the date disparity

Logic:
1. Joins DRUG_EXPOSURE_RAW with VISIT_OCCURRENCE_RAW tables
2. Checks for valid VISIT_OCCURRENCE_ID values
3. Identifies date disparities by comparing:
   - Drug exposure start date vs. visit start/end dates
   - Drug exposure start datetime vs. visit start/end datetime
   - Mixed comparisons between dates and datetimes

Warning conditions:
- Drug exposure date before visit start date
- Drug exposure date after visit end date
- Similar checks using datetime values converted to dates

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
*/