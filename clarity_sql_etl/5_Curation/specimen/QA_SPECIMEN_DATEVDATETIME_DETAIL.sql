/*******************************************************************************
Script Name: QA_SPECIMEN_DATEVDATETIME_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies discrepancies between SPECIMEN_DATE and 
SPECIMEN_DATETIME fields in the SPECIMEN_RAW table.
*******************************************************************************/

WITH DATEVDATETIME_DETAIL AS (
    SELECT 
        'SPECIMEN_DATE' AS METRIC_FIELD, 
        'DATEVDATETIME' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE,
        SPECIMEN_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN_RAW AS T1
    WHERE SPECIMEN_DATE <> CAST(SPECIMEN_DATETIME AS DATE)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'SPECIMEN' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM DATEVDATETIME_DETAIL;

/*******************************************************************************

Column Descriptions:
- RUN_DATE: Current date when the script is executed
- STANDARD_DATA_TABLE: Name of the source table being validated
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Field being evaluated
- ERROR_TYPE: Severity level of the discrepancy
- CDT_ID: Specimen identifier

Logic:
1. Creates CTE to identify records where SPECIMEN_DATE doesn't match the date part 
   of SPECIMEN_DATETIME
2. Returns detailed information about the discrepancies for further investigation

Legal Warning:
This code is provided "AS IS" without warranty of any kind. The author and 
organization are not responsible for any damages or losses arising from its use. 
Use at your own risk.
*******************************************************************************/