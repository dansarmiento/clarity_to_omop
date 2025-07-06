/*******************************************************************************
* Script Name: QA_PROCEDURE_OCCURRENCE_NOVISIT_COUNT.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* Description: Quality assurance check for procedures without associated visits
*******************************************************************************/

WITH NOVISIT_COUNT AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD, 
        'NO VISIT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON PROCEDURE_OCCURRENCE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) IS NOT NULL AND SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE) AS TOTAL_RECORDS_CLEAN
FROM NOVISIT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being analyzed
* - QA_METRIC: Type of quality check being performed
* - METRIC_FIELD: Field being evaluated
* - QA_ERRORS: Count of records failing the QA check
* - ERROR_TYPE: Severity of the error (WARNING in this case)
* - TOTAL_RECORDS: Total number of records in the raw table
* - TOTAL_RECORDS_CLEAN: Total number of records in the clean table
*
* Logic:
* 1. Identifies procedures in PROCEDURE_OCCURRENCE_RAW that don't have 
*    corresponding entries in VISIT_OCCURRENCE_RAW
* 2. Counts these orphaned procedures
* 3. Returns summary statistics including total record counts
*
* Legal Warning:
* This code is provided as-is without any implied warranty. Use at your own risk.
* Users should thoroughly test and validate the code before implementation in a
* production environment.
*******************************************************************************/