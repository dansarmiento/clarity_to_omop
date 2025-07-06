/*********************************************************
Script Name: Query_Provider_Errors_Raw.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Retrieves provider-related quality assurance errors by joining
            QA error table with Provider raw data.
**********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , PROVIDER.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER 
    ON QA_ERR_DBT.CDT_ID = PROVIDER.PROVIDER_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'PROVIDER'

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being validated
QA_METRIC: The specific quality metric being checked
METRIC_FIELD: The specific field being validated
ERROR_TYPE: Classification of the error found
PROVIDER.*: All columns from the PROVIDER_RAW table

LOGIC:
------
1. Joins QA error table with Provider raw data using Provider ID
2. Filters for only Provider-related QA errors
3. Returns all provider information associated with QA errors

LEGAL DISCLAIMER:
---------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. In no event shall the author be liable for any
damages whatsoever arising out of or in connection with the
use or performance of this code.

Use at your own risk.
*********************************************************/