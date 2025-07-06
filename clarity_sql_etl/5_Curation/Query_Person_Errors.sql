/*********************************************************
* Script Name: Query_Person_Errors.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: Retrieves quality assurance errors related to
* person records by joining QA error table with PERSON table
*********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , PERSON.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON AS PERSON 
    ON QA_ERR_DBT.CDT_ID = PERSON.PERSON_ID
    AND QA_ERR_DBT.CDT_ID = PERSON.PERSON_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'PERSON'

/*********************************************************
* Column Descriptions:
* - RUN_DATE: Date when QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being checked
* - QA_METRIC: Quality assurance measure being evaluated
* - METRIC_FIELD: Specific field being checked
* - ERROR_TYPE: Classification of the error found
* - PERSON.*: All columns from the PERSON table
*
* Logic:
* 1. Joins QA error table with PERSON table using PERSON_ID
* 2. Filters for errors specifically in the PERSON table
* 3. Returns all error details and associated person records
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind.
* The entire risk as to the quality and performance of the
* code is with you. In no event shall the author be liable
* for any damages whatsoever arising out of the use or
* inability to use this code.
*********************************************************/