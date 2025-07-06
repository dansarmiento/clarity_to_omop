/*********************************************************
Script Name: Query_Observation_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: Retrieves observation records that failed QA checks
by joining QA error table with OBSERVATION table
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
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION AS OBSERVATION ON
    QA_ERR_DBT.CDT_ID = OBSERVATION.OBSERVATION_ID
    AND QA_ERR_DBT.CDT_ID = OBSERVATION.OBSERVATION_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'OBSERVATION'

/************************ 
Column Descriptions:
- RUN_DATE: Date QA check was performed
- STANDARD_DATA_TABLE: OMOP table being checked
- QA_METRIC: Name of quality check that failed
- METRIC_FIELD: Field that failed the check
- ERROR_TYPE: Category/type of error found
- OBSERVATION.*: All fields from OBSERVATION table

Logic:
1. Joins QA error table with OBSERVATION on ID fields
2. Filters for only OBSERVATION table errors
3. Returns error details and full observation record

Legal Warning:
This code is provided as-is without warranty of any kind, either
express or implied. Use at your own risk.
************************/