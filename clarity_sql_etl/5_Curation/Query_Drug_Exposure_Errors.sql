/*******************************************************************************
Script Name: Query_Drug_Exposure_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , DRUG_EXPOSURE.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE 
    ON QA_ERR_DBT.CDT_ID = DRUG_EXPOSURE.DRUG_EXPOSURE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'DRUG_EXPOSURE'

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Quality assurance metric being evaluated
METRIC_FIELD: Specific field being checked
ERROR_TYPE: Classification of the error found
DRUG_EXPOSURE.*: All columns from the DRUG_EXPOSURE_RAW table

LOGIC:
------
1. Joins QA error table with DRUG_EXPOSURE_RAW table
2. Matches records using DRUG_EXPOSURE_ID
3. Filters for errors specifically in the DRUG_EXPOSURE table
4. Returns all error records with full drug exposure details

LEGAL WARNING:
-------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Use at your own risk.
*******************************************************************************/