/*********************************************************
Script Name: Query_Care_Site_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This query retrieves quality assurance errors 
related to care site data by joining QA error table with 
the CARE_SITE table.
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
    CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE AS CARE_SITE 
    ON QA_ERR_DBT.CDT_ID = CARE_SITE.CARE_SITE_ID
    AND QA_ERR_DBT.CDT_ID = CARE_SITE.CARE_SITE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'CARE_SITE'

/*********************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being checked
- QA_METRIC: Quality assurance metric being evaluated
- METRIC_FIELD: Specific field being checked
- ERROR_TYPE: Type of error identified
- CARE_SITE.*: All columns from the CARE_SITE table

LOGIC:
1. Joins QA error table with CARE_SITE table using CARE_SITE_ID
2. Filters for errors specifically related to CARE_SITE table
3. Returns all matching records with error details and care site information

LEGAL WARNING:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. In no event shall the author be liable for any
damages whatsoever arising out of the use or inability to use
this code.
*********************************************************/