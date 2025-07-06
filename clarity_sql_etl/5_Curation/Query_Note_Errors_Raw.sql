/*******************************************************************************
Script Name: Query_Note_Errors_raw.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

-- Query to identify and analyze errors in NOTE table records
SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , NOTE.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE 
    ON QA_ERR_DBT.CDT_ID = NOTE.NOTE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'NOTE'

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the quality check was performed
STANDARD_DATA_TABLE: Name of the table being validated
QA_METRIC: Quality assurance metric being checked
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Classification of the error found
NOTE.*: All columns from the NOTE_RAW table

LOGIC:
------
1. Joins QA error tracking table with NOTE_RAW table
2. Matches records using NOTE_ID as the key
3. Filters for errors specifically related to the NOTE table
4. Returns all error details and corresponding note records

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code
remains with you. In no event shall the author be liable for any
damages whatsoever arising out of the use of or inability to use
this code.

*******************************************************************************/