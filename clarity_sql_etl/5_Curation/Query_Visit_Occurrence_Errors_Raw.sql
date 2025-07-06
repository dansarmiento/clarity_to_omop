/*********************************************************
Script Name: Query_Visit_Occurrence_Errors_Raw
Author: Roger J Carlson - Corewell Health
Date: June 2025
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
    CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE 
    ON QA_ERR_DBT.CDT_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'VISIT_OCCURRENCE'

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the OMOP table being checked
QA_METRIC: Description of the quality check being performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Classification of the error found
VISIT_OCCURRENCE.*: All columns from the VISIT_OCCURRENCE_RAW table

LOGIC:
------
1. Joins QA error table with VISIT_OCCURRENCE_RAW table
2. Matches records using VISIT_OCCURRENCE_ID
3. Filters for errors specific to VISIT_OCCURRENCE table
4. Returns all error details and associated visit records

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. In no event shall the author be liable for any
damages whatsoever arising out of the use or inability to use
this code.

**********************************************************/