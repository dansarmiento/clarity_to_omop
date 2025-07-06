/*********************************************************
Script Name: Query_Note_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Retrieves QA errors related to the NOTE table
**********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , NOTE.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE AS NOTE ON
    QA_ERR_DBT.CDT_ID = NOTE.NOTE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'NOTE'

/************************ 
Column Descriptions:
- RUN_DATE: Date QA check was executed
- STANDARD_DATA_TABLE: OMOP table being validated
- QA_METRIC: Name of quality check being performed
- METRIC_FIELD: Specific field being validated
- ERROR_TYPE: Category/classification of error found
- NOTE.*: All columns from NOTE table

Logic:
1. Joins QA error table with NOTE table on NOTE_ID
2. Filters for only NOTE table errors
3. Returns all error details and related note records

Legal Warning:
This code is provided as-is without any implied warranty.
Use at your own risk. No liability accepted.
************************/