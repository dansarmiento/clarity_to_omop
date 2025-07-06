/*******************************************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_VISITDATEDISPARITY_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

WITH VISITDATEDISPARITY_DETAIL AS (
    SELECT 
        'PROCEDURE_DATE' AS METRIC_FIELD, 
        'VISIT_DATE_DISPARITY' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PO
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VO
        ON PO.VISIT_OCCURRENCE_ID = VO.VISIT_OCCURRENCE_ID
    WHERE
        -- MUST HAVE POPULATED VISIT OCCURRENCE ID
        (PO.VISIT_OCCURRENCE_ID IS NOT NULL
            AND PO.VISIT_OCCURRENCE_ID <> 0
            AND VO.VISIT_OCCURRENCE_ID IS NOT NULL
            AND VO.VISIT_OCCURRENCE_ID <> 0)
        AND (
            -- PROBLEM WITH PROCEDURE DATE
            (PO.PROCEDURE_DATE < VO.VISIT_START_DATE
                OR PO.PROCEDURE_DATE > VO.VISIT_END_DATE)
            OR
            -- PROBLEM WITH DATETIME
            (CAST(PO.PROCEDURE_DATETIME AS DATE) < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR CAST(PO.PROCEDURE_DATETIME AS DATE) > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            -- PROBLEM WITH THE DATETIME (EXTRACTING DATE FOR COMPARISON)
            (PO.PROCEDURE_DATE < CAST(VO.VISIT_START_DATETIME AS DATE)
                OR PO.PROCEDURE_DATE > CAST(VO.VISIT_END_DATETIME AS DATE))
            OR
            --PROBLEM WITH THE DATETIME
            (CAST(PO.PROCEDURE_DATETIME AS DATE) < VO.VISIT_START_DATE
                OR CAST(PO.PROCEDURE_DATETIME AS DATE) > VO.VISIT_END_DATE)
        )
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM VISITDATEDISPARITY_DETAIL;

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the query was executed
STANDARD_DATA_TABLE: Name of the standard data table being analyzed
QA_METRIC: Quality assurance metric being checked
METRIC_FIELD: Field being evaluated
ERROR_TYPE: Type of error found (WARNING in this case)
CDT_ID: Procedure Occurrence ID

LOGIC:
------
This query identifies procedures where the procedure date/datetime falls outside
the associated visit start and end dates/datetimes. It checks for discrepancies
using both DATE and DATETIME fields, converting between the two formats as needed.

LEGAL WARNING:
-------------
This code is provided "AS IS" without warranty of any kind, either express or 
implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/