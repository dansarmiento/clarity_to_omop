/*******************************************************************************
Script Name: Query_Device_Exposure_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

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
    CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE AS DEVICE_EXPOSURE 
    ON QA_ERR_DBT.CDT_ID = DEVICE_EXPOSURE.DEVICE_EXPOSURE_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'DEVICE_EXPOSURE'

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the OMOP table being checked
QA_METRIC: Description of the quality check being performed
METRIC_FIELD: Specific field being evaluated
ERROR_TYPE: Classification of the error found
DEVICE_EXPOSURE.*: All columns from the DEVICE_EXPOSURE table

LOGIC:
------
1. Joins QA error table with DEVICE_EXPOSURE table using DEVICE_EXPOSURE_ID
2. Filters for records specifically related to DEVICE_EXPOSURE table
3. Returns all error records with corresponding device exposure details

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind, either express 
or implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use of this code is at your own risk.
*******************************************************************************/