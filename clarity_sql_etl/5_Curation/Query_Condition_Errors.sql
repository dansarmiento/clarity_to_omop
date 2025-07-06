/*********************************************************
Script Name: Query_Condition_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Retrieves condition occurrence records with quality assurance errors
**********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , CONDITION_OCCURRENCE.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE AS CONDITION_OCCURRENCE 
    ON QA_ERR_DBT.CDT_ID = CONDITION_OCCURRENCE.CONDITION_OCCURRENCE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'CONDITION_OCCURRENCE'

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the OMOP table being checked
QA_METRIC: Description of the quality check performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Category or description of the error found
CONDITION_OCCURRENCE.*: All fields from the condition occurrence table

LOGIC:
------
1. Joins QA error table with condition occurrence table
2. Matches records using CDT_ID to CONDITION_OCCURRENCE_ID
3. Filters for errors specific to CONDITION_OCCURRENCE table

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. Use at your own risk.
*********************************************************/