/*********************************************************
Script Name: Query_Specimen_Errors_Raw
Author: Roger J Carlson - Corewell Health
Date: June 2025
Description: Retrieves specimen-related quality assurance errors by joining
            QA error table with raw specimen data.
**********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , SPECIMEN.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS SPECIMEN ON
    QA_ERR_DBT.CDT_ID = SPECIMEN.SPECIMEN_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'SPECIMEN'

/*********************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being validated
QA_METRIC: Description of the quality check performed
METRIC_FIELD: Specific field being validated
ERROR_TYPE: Classification of the error found
SPECIMEN.*: All columns from the SPECIMEN_RAW table

LOGIC:
------
1. Joins QA error table with raw specimen data using SPECIMEN_ID
2. Filters for errors specifically related to the SPECIMEN table
3. Returns all specimen information associated with identified errors

LEGAL DISCLAIMER:
----------------
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code
is with you. In no event shall the author be liable for any
damages whatsoever arising out of the use or inability to use
this code.

USE AT YOUR OWN RISK.
*********************************************************/