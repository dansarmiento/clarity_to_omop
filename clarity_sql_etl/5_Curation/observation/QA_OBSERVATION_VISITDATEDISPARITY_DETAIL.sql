/*******************************************************************************
Script Name: QA_OBSERVATION_VISITDATEDISPARITY_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

WITH VISITDATEDISPARITY_DETAIL AS (
    SELECT 
        'OBSERVATION_DATE' AS METRIC_FIELD, 
        'VISIT_DATE_DISPARITY' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS O
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
        ON O.VISIT_OCCURRENCE_ID = VO.VISIT_OCCURRENCE_ID
    WHERE
        -- MUST HAVE POPULATED VISIT OCCURRENCE ID
        (O.VISIT_OCCURRENCE_ID IS NOT NULL
            AND O.VISIT_OCCURRENCE_ID <> 0
            AND VO.VISIT_OCCURRENCE_ID IS NOT NULL
            AND VO.VISIT_OCCURRENCE_ID <> 0)
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
    ERROR_TYPE,
    CDT_ID
FROM VISITDATEDISPARITY_DETAIL;

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Indicates the primary table being analyzed
QA_METRIC: Quality assurance metric being checked
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Classification of the error found
CDT_ID: Observation ID from the source table

LOGIC:
------
1. Identifies observations with visit dates that fall outside their associated 
   visit occurrence window
2. Checks both date and datetime fields for inconsistencies
3. Validates that observation dates occur within the visit start and end dates
4. Flags records where dates/times don't align with visit windows

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind, either express 
or implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use of this code is at your own risk.
*******************************************************************************/