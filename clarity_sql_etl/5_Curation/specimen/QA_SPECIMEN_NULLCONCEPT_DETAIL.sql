/*********************************************************
Script Name: QA_SPECIMEN_NULLCONCEPT_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script identifies null concept IDs in the SPECIMEN_RAW table
*********************************************************/

WITH NULLCONCEPT_DETAIL
AS (
    SELECT 
        'SPECIMEN_CONCEPT_ID' AS METRIC_FIELD, 
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        SPECIMEN_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SPECIMEN
    WHERE (SPECIMEN_CONCEPT_ID IS NULL)

    UNION ALL

    SELECT 
        'ANATOMIC_SITE_CONCEPT_ID' AS METRIC_FIELD, 
        'NULL CONCEPT' AS QA_METRIC, 
        'FATAL' AS ERROR_TYPE,
        SPECIMEN_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SPECIMEN
    WHERE (ANATOMIC_SITE_CONCEPT_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'SPECIMEN' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NULLCONCEPT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*********************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being checked for null concepts
- ERROR_TYPE: Severity of the error (FATAL in this case)
- CDT_ID: Specimen ID of the record with null concept

Logic:
1. Identifies records where SPECIMEN_CONCEPT_ID is null
2. Identifies records where ANATOMIC_SITE_CONCEPT_ID is null
3. Combines results and filters out any 'EXPECTED' errors
4. Returns detailed information about each null concept found

Legal Warning:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. In no event shall the author be liable for any
damages whatsoever arising out of the use or inability to use
this code.
*********************************************************/