/*********************************************************
Script Name: Query_Measurement_Errors_Raw.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Retrieves measurement errors from QA error table
            joined with measurement raw data
**********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , MEASUREMENT.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW AS MEASUREMENT 
    ON QA_ERR_DBT.CDT_ID = MEASUREMENT.MEASUREMENT_ID

WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'MEASUREMENT'

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when QA check was performed
STANDARD_DATA_TABLE: Name of the OMOP table being checked
QA_METRIC: Quality assurance metric being evaluated
METRIC_FIELD: Specific field being checked
ERROR_TYPE: Type of error detected
MEASUREMENT.*: All columns from MEASUREMENT_RAW table

LOGIC:
------
1. Joins QA error table with MEASUREMENT_RAW table
2. Matches records using MEASUREMENT_ID
3. Filters for only MEASUREMENT table errors

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. Should the code prove defective, you assume the
cost of all necessary servicing, repair or correction.

**********************************************************/