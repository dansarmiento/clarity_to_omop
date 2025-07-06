/*********************************************************
* Script Name: Query_Location_Errors.sql
* Author: Roger J Carlson - Corewell Health 
* Date: June 2025
*
* Description: Retrieves location-related quality assurance errors by joining
* QA error table with location raw data
*********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE  
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , LOCATION.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW AS LOCATION ON
    QA_ERR_DBT.CDT_ID = LOCATION.LOCATION_ID

WHERE 
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'LOCATION'

/*********************************************************
* Column Descriptions:
* RUN_DATE - Date QA check was performed
* STANDARD_DATA_TABLE - Name of table being checked
* QA_METRIC - Quality metric being evaluated
* METRIC_FIELD - Specific field being checked
* ERROR_TYPE - Category/type of error found
* LOCATION.* - All fields from LOCATION_RAW table
*
* Logic:
* 1. Joins QA error table with location raw data on location ID
* 2. Filters for only location-related QA errors
* 
* Legal Warning:
* This code is provided as-is with no implied warranty.
* Use at your own risk.
*********************************************************/