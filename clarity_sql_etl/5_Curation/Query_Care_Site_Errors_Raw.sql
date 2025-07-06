/*********************************************************
Script Name: Query_Care_Site_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Retrieves care site errors from QA error table
*********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , CARE_SITE.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW AS CARE_SITE 
    ON QA_ERR_DBT.CDT_ID = CARE_SITE.CARE_SITE_ID
    AND QA_ERR_DBT.CDT_ID = CARE_SITE.CARE_SITE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'CARE_SITE'

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Quality assurance metric being evaluated
METRIC_FIELD: Specific field being checked
ERROR_TYPE: Type of error detected
CARE_SITE.*: All columns from the CARE_SITE_RAW table

LOGIC:
------
1. Joins QA error table with CARE_SITE_RAW table
2. Matches records based on CARE_SITE_ID
3. Filters for errors specific to CARE_SITE table

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. Use at your own risk.
*********************************************************/