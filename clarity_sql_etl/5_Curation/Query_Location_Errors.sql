/*********************************************************
* Script Name: Query_Location_Errors.sql
* Author: Roger J Carlson - Corewell Health
* Date: June 2025
*
* Description: Retrieves quality assurance errors for Location data
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
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION AS LOCATION ON
    QA_ERR_DBT.CDT_ID = LOCATION.LOCATION_ID

WHERE
    QA_ERR_DBT.STANDARD_DATA_TABLE = 'LOCATION'

/************************ 
COLUMN DESCRIPTIONS:
- RUN_DATE: Date QA check was performed
- STANDARD_DATA_TABLE: OMOP table being checked
- QA_METRIC: Name of quality check performed
- METRIC_FIELD: Field that failed QA check
- ERROR_TYPE: Category/type of error found
- LOCATION.*: All fields from Location table

LOGIC:
1. Joins QA errors table to Location table on location_id
2. Filters for only Location table errors
3. Returns error details and full location record

LEGAL DISCLAIMER:
This code is provided as-is without warranty of any kind, either express or implied.
Use of this code is at your own risk. The author and organization accept no liability
for any damages or losses resulting from its use.
************************/