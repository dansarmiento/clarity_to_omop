/*******************************************************************************
* Script Name: Query_Device_Exposure_Errors.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: Retrieves device exposure records that have associated quality 
* assurance errors from the QA error tracking table.
*******************************************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , DEVICE_EXPOSURE.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE 
    ON QA_ERR_DBT.CDT_ID = DEVICE_EXPOSURE.DEVICE_EXPOSURE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'DEVICE_EXPOSURE'

/*******************************************************************************
* Column Descriptions:
* - RUN_DATE: Date when the QA check was performed
* - STANDARD_DATA_TABLE: Name of the OMOP table being checked
* - QA_METRIC: The specific quality metric being evaluated
* - METRIC_FIELD: The specific field being evaluated
* - ERROR_TYPE: Classification of the error found
* - DEVICE_EXPOSURE.*: All columns from the DEVICE_EXPOSURE_RAW table
*
* Logic:
* 1. Joins QA error tracking table with Device Exposure raw data
* 2. Matches records using DEVICE_EXPOSURE_ID
* 3. Filters for errors specifically in the DEVICE_EXPOSURE table
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind, either expressed 
* or implied, including but not limited to the implied warranties of 
* merchantability and/or fitness for a particular purpose. The user assumes 
* all risk for any damages whatsoever resulting from the use or misuse of 
* this code.
*******************************************************************************/