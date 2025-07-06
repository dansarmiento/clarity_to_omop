/*******************************************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_VISITDATEDISPARITY_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies discrepancies between procedure dates and 
associated visit dates in the PROCEDURE_OCCURRENCE table.

Legal Warning: 
This code is provided "AS IS" without warranty of any kind.
Use of this code is at your own risk and responsibility.
*******************************************************************************/

WITH VISITDATEDISPARITY_COUNT AS (
    SELECT 
        'PROCEDURE_DATE' AS METRIC_FIELD, 
        'VISIT_DATE_DISPARITY' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
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
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 
         THEN ERROR_TYPE 
         ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM VISITDATEDISPARITY_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being analyzed
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Field being evaluated
- QA_ERRORS: Count of records with date discrepancies
- ERROR_TYPE: Classification of the error (WARNING in this case)
- TOTAL_RECORDS: Total count of records in the raw table
- TOTAL_RECORDS_CLEAN: Total count of records in the clean table

Logic:
1. Identifies procedures where the procedure date falls outside the visit date range
2. Checks both date and datetime fields for inconsistencies
3. Ensures valid visit occurrence IDs exist
4. Aggregates results with error counts and totals
*******************************************************************************/