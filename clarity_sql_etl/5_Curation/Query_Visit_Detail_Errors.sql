/*********************************************************
Script Name: Query_Visit_Detail_Errors
Author: Roger J Carlson - Corewell Health
Date: June 2025
**********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , VISIT_DETAIL.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL AS VISIT_DETAIL 
    ON QA_ERR_DBT.CDT_ID = VISIT_DETAIL.VISIT_DETAIL_ID
    AND QA_ERR_DBT.CDT_ID = VISIT_DETAIL.VISIT_DETAIL_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'VISIT_DETAIL'

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: The specific quality metric being evaluated
METRIC_FIELD: The specific field being checked
ERROR_TYPE: Classification of the error found
VISIT_DETAIL.*: All columns from the VISIT_DETAIL table

LOGIC:
------
1. Joins QA error table with VISIT_DETAIL table
2. Matches records based on VISIT_DETAIL_ID
3. Filters for errors specifically in the VISIT_DETAIL table
4. Returns all error details along with complete visit information

LEGAL WARNING:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. Should the code prove defective, you assume the
cost of all necessary servicing, repair or correction.
*********************************************************/