/*********************************************************
Script Name: Query_Death_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This query retrieves death record errors by joining
the QA error table with the DEATH table.
*********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , DEATH.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.DEATH AS DEATH 
    ON QA_ERR_DBT.CDT_ID = DEATH.PERSON_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'DEATH'

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: The specific quality metric being evaluated
METRIC_FIELD: The specific field being evaluated
ERROR_TYPE: Classification of the error found
DEATH.*: All columns from the DEATH table

LOGIC:
------
1. Joins QA error table with DEATH table using PERSON_ID
2. Filters for errors specifically in the DEATH table
3. Returns all error details and associated death records

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. In no event shall the author be liable for any
damages whatsoever arising out of the use or inability to use
this code.
*********************************************************/