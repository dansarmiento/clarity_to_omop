/*******************************************************************************
Script Name: QA_PERSON_WO_VISIT_COUNT.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies persons in PERSON_RAW table who don't have 
            any corresponding records in VISIT_OCCURRENCE_RAW table
*******************************************************************************/

WITH TMP_WO_VISIT AS (
    SELECT
        PERSON_RAW.PERSON_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS PERSON_RAW
        LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE_RAW
            ON PERSON_RAW.person_ID = VISIT_OCCURRENCE_RAW.PERSON_ID
    WHERE VISIT_OCCURRENCE_RAW.PERSON_ID IS NULL
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON'   AS STANDARD_DATA_TABLE,
    'WO_VISIT' AS QA_METRIC,
    'RECORDS'  AS METRIC_FIELD,
    'FATAL'    AS ERROR_TYPE,
    CDT_ID
FROM TMP_WO_VISIT;

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the query was executed
- STANDARD_DATA_TABLE: Indicates the primary table being analyzed (PERSON)
- QA_METRIC: Type of quality check being performed (Without Visit)
- METRIC_FIELD: Type of measurement being counted (Records)
- ERROR_TYPE: Severity of the identified issue (Fatal)
- CDT_ID: Person identifier from PERSON_RAW table

Logic:
1. Creates a temporary result set (TMP_WO_VISIT) using LEFT JOIN
2. Identifies PERSON_IDs that don't have matching records in VISIT_OCCURRENCE_RAW
3. Returns formatted results with QA metadata and identified PERSON_IDs

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either expressed 
or implied, including, but not limited to, the implied warranties of 
merchantability and fitness for a particular purpose. The entire risk as to the 
quality and performance of the code is with you. Should the code prove defective, 
you assume the cost of all necessary servicing, repair, or correction.
*******************************************************************************/