/*********************************************************
Script Name: Query_Procedure_Occurrence_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Retrieves procedure occurrence records with quality assurance errors
**********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , PROCEDURE_OCCURRENCE.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE AS PROCEDURE_OCCURRENCE 
    ON QA_ERR_DBT.CDT_ID = PROCEDURE_OCCURRENCE.PROCEDURE_OCCURRENCE_ID

WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'PROCEDURE_OCCURRENCE'

/*********************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when QA check was performed
- STANDARD_DATA_TABLE: Name of the OMOP table being checked
- QA_METRIC: Quality assurance measure being evaluated
- METRIC_FIELD: Specific field being checked
- ERROR_TYPE: Category or description of the error found
- PROCEDURE_OCCURRENCE.*: All fields from the procedure occurrence table

LOGIC:
1. Joins QA error table with procedure occurrence table
2. Matches records using procedure occurrence ID
3. Filters for errors specific to procedure occurrence table

LEGAL WARNING:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. In no event shall the author be liable for any
damages whatsoever arising out of the use or inability to use
this code.
*********************************************************/