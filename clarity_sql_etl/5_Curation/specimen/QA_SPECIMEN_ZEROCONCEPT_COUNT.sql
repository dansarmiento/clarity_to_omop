/*********************************************************
Script Name: QA_SPECIMEN_ZEROCONCEPT_COUNT
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Identifies zero concepts in the SPECIMEN table
*********************************************************/

WITH ZEROCONCEPT_COUNT
AS (
    SELECT 
        'SPECIMEN_CONCEPT_ID' AS METRIC_FIELD, 
        'ZERO CONCEPT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SPECIMEN
    WHERE (SPECIMEN_CONCEPT_ID = 0)

    UNION ALL

    SELECT 
        'ANATOMIC_SITE_CONCEPT_ID' AS METRIC_FIELD, 
        'ZERO CONCEPT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SPECIMEN
    WHERE (ANATOMIC_SITE_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'SPECIMEN' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT),0) AS QA_ERRORS,
    CASE 
        WHEN SUM(CNT) <> 0 THEN ERROR_TYPE 
        ELSE NULL 
    END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS 
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN) AS TOTAL_RECORDS_CLEAN
FROM ZEROCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*********************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being analyzed
QA_METRIC: Type of quality check being performed
METRIC_FIELD: Specific field being checked
QA_ERRORS: Count of records with zero concepts
ERROR_TYPE: Indication of error severity
TOTAL_RECORDS: Total count of records in raw table
TOTAL_RECORDS_CLEAN: Total count of records in clean table

Logic:
------
1. Counts occurrences of zero concepts in specified fields
2. Compares raw vs clean table record counts
3. Flags warnings for zero concepts found

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind.
Use at your own risk. The author and organization are not 
responsible for any damages or losses arising from its use.
*********************************************************/