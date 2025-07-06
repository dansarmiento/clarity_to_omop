/*********************************************************
* Script Name: Query_Specimen_Errors.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
* 
* Description: Retrieves specimen-related quality assurance errors
* by joining QA error table with SPECIMEN table
*********************************************************/

SELECT
    QA_ERR_DBT.RUN_DATE
    , QA_ERR_DBT.STANDARD_DATA_TABLE
    , QA_ERR_DBT.QA_METRIC
    , QA_ERR_DBT.METRIC_FIELD
    , QA_ERR_DBT.ERROR_TYPE
    , SPECIMEN.*
FROM
    CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN AS SPECIMEN ON
    QA_ERR_DBT.CDT_ID = SPECIMEN.SPECIMEN_ID
    AND QA_ERR_DBT.CDT_ID = SPECIMEN.SPECIMEN_ID
WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'SPECIMEN'

/*********************************************************
* Column Descriptions:
* - RUN_DATE: Date when QA check was performed
* - STANDARD_DATA_TABLE: Name of the table being checked
* - QA_METRIC: Quality assurance metric being evaluated
* - METRIC_FIELD: Specific field being evaluated
* - ERROR_TYPE: Type of error detected
* - SPECIMEN.*: All columns from the SPECIMEN table
*
* Logic:
* 1. Joins QA error table with SPECIMEN table using SPECIMEN_ID
* 2. Filters for errors specifically related to SPECIMEN table
* 3. Returns all specimen records with associated error details
*
* Legal Warning:
* This code is provided "AS IS" without warranty of any kind.
* The entire risk of use or results from the use of this code
* remains with the user. No implied warranty for merchantability
* or fitness for a particular purpose shall apply.
* Use at your own risk.
*********************************************************/