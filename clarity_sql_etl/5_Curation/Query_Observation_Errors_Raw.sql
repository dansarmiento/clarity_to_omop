/*********************************************************
Script Name: Query_Observation_Errors_raw
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Retrieves observation errors by joining QA error table with raw observation data
**********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , OBSERVATION.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION ON
    QA_ERR_DBT.CDT_ID = OBSERVATION.OBSERVATION_ID
    AND QA_ERR_DBT.CDT_ID = OBSERVATION.OBSERVATION_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'OBSERVATION'

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Quality assurance metric being evaluated
METRIC_FIELD: Specific field being checked
ERROR_TYPE: Type of error identified
OBSERVATION.*: All columns from the OBSERVATION_RAW table

LOGIC:
------
1. Joins QA error table with raw observation data using OBSERVATION_ID
2. Filters for errors specifically in the OBSERVATION table
3. Returns all error details and associated observation records

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Use at your own risk.
*********************************************************/