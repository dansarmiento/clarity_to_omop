/*********************************************************
Script Name: Query_Measurement_Errors.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Retrieves measurement errors by joining QA error table with MEASUREMENT
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
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT AS MEASUREMENT ON
    QA_ERR_DBT.CDT_ID = MEASUREMENT.MEASUREMENT_ID

WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'MEASUREMENT'

/*********************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the OMOP table being checked
- QA_METRIC: Quality assurance metric being evaluated
- METRIC_FIELD: Specific field being checked
- ERROR_TYPE: Classification of the error found
- MEASUREMENT.*: All columns from the MEASUREMENT table

LOGIC:
1. Joins QA error table with MEASUREMENT table using MEASUREMENT_ID
2. Filters for errors specifically in the MEASUREMENT table
3. Returns all error details along with complete measurement record

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind, either express 
or implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use of this code is at your own risk.
*********************************************************/