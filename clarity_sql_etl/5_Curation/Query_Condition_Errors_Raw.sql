/*******************************************************************************
* Script Name: Query_Condition_Errors.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: This query retrieves condition occurrence records that have 
* associated quality assurance errors from the QA error table.
*******************************************************************************/

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
    CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE_RAW AS CONDITION_OCCURRENCE 
    ON QA_ERR_DBT.CDT_ID = CONDITION_OCCURRENCE.CONDITION_OCCURRENCE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'CONDITION_OCCURRENCE'

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the OMOP table being checked
* - QA_METRIC: The specific quality metric being evaluated
* - METRIC_FIELD: The specific field being evaluated
* - ERROR_TYPE: Classification of the error found
* - CONDITION_OCCURRENCE.*: All fields from the condition occurrence table
*
* Logic:
* 1. Joins QA error table with condition occurrence table using CDT_ID
* 2. Filters for only condition occurrence related errors
* 3. Returns all error details and associated condition records
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind, either expressed 
* or implied, including but not limited to the implied warranties of 
* merchantability and/or fitness for a particular purpose. The user assumes 
* all risk for any damages whatsoever resulting from the use of this code.
*******************************************************************************/