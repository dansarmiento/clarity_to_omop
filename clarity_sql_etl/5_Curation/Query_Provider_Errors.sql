/*********************************************************
* Script Name: Query_Provider_Errors.sql
* Author: Roger J Carlson - Corewell Health 
* Date: June 2025
*
* Description: Retrieves provider records with data quality errors
* by joining QA error table with Provider table
*********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE  
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , PROVIDER.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER AS PROVIDER ON
    QA_ERR_DBT.CDT_ID = PROVIDER.PROVIDER_ID
    AND QA_ERR_DBT.CDT_ID = PROVIDER.PROVIDER_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'PROVIDER'

/*********************************************************
* Column Descriptions:
* RUN_DATE - Date QA check was performed
* STANDARD_DATA_TABLE - OMOP table being validated
* QA_METRIC - Type of quality check performed
* METRIC_FIELD - Field that failed validation
* ERROR_TYPE - Category/description of error found
* PROVIDER.* - All provider table columns
*
* Logic:
* 1. Joins QA error table to Provider table on provider ID
* 2. Filters for only Provider table errors
* 3. Returns error details and full provider record
*
* Legal Warning:
* This code is provided as-is with no implied warranty.
* Use at your own risk.
*********************************************************/