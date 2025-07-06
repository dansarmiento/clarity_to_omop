/*******************************************************************************
* Script Name: QA_PERSON_ZEROCONCEPT_COUNT.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: This script performs quality assurance checks on the PERSON table
* by counting records with zero concept IDs for gender, race, and ethnicity.
*******************************************************************************/

WITH ZEROCONCEPT_COUNT AS (
    SELECT 
        'GENDER_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (GENDER_CONCEPT_ID = 0)
    
    UNION ALL
    
    SELECT 
        'RACE_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (RACE_CONCEPT_ID = 0)
    
    UNION ALL
    
    SELECT 
        'ETHNICITY_CONCEPT_ID' AS METRIC_FIELD,
        'ZERO CONCEPT' AS QA_METRIC,
        'WARNING' AS ERROR_TYPE,
        COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE (ETHNICITY_CONCEPT_ID = 0)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    COALESCE(SUM(CNT), 0) AS QA_ERRORS,
    CASE WHEN SUM(CNT) <> 0 THEN ERROR_TYPE ELSE NULL END AS ERROR_TYPE,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW) AS TOTAL_RECORDS,
    (SELECT COUNT(*) AS NUM_ROWS FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON) AS TOTAL_RECORDS_CLEAN
FROM ZEROCONCEPT_COUNT
GROUP BY METRIC_FIELD, QA_METRIC, ERROR_TYPE;

/*******************************************************************************
* Column Descriptions:
* ------------------
* RUN_DATE: Date when the QA check was performed
* STANDARD_DATA_TABLE: Name of the table being analyzed
* QA_METRIC: Type of quality check being performed
* METRIC_FIELD: Specific field being checked
* QA_ERRORS: Number of records failing the QA check
* ERROR_TYPE: Severity of the error (WARNING in this case)
* TOTAL_RECORDS: Total number of records in the raw table
* TOTAL_RECORDS_CLEAN: Total number of records in the clean table
*
* Logic:
* ------
* 1. Counts records with zero concept IDs in gender, race, and ethnicity fields
* 2. Combines results with union all
* 3. Calculates final metrics including total record counts
*
* Legal Warning:
* -------------
* This code is provided as-is without any implied warranty.
* Use at your own risk. Users should thoroughly test and validate
* the code in their environment before implementation.
*******************************************************************************/