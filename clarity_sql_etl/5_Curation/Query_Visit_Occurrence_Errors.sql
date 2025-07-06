/*********************************************************
Script Name: Query_Visit_Occurrence_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Retrieves visit occurrence records with quality assurance errors
**********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , VISIT_OCCURRENCE.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE AS VISIT_OCCURRENCE 
    ON QA_ERR_DBT.CDT_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    AND QA_ERR_DBT.CDT_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'VISIT_OCCURRENCE'

/*********************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Quality assurance metric being evaluated
- METRIC_FIELD: Specific field being checked
- ERROR_TYPE: Type of error detected
- VISIT_OCCURRENCE.*: All columns from the VISIT_OCCURRENCE table

LOGIC:
1. Joins QA error table with VISIT_OCCURRENCE table
2. Matches records based on VISIT_OCCURRENCE_ID
3. Filters for errors specifically in VISIT_OCCURRENCE table

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. Use at your own risk.
*********************************************************/