/*******************************************************************************
Script Name: QA_PERSON_AGE_ERR_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: This script identifies persons with invalid age values in the PERSON_RAW
table by checking for ages under 18 or over 120 years old.
*******************************************************************************/

WITH AGE_ERR_DETAIL AS (
    SELECT
        'UNDER18' AS AGE,
        PERSON_ID AS CDT_ID
    FROM
        CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE 
        (DATEDIFF(YEAR, BIRTH_DATETIME, GETDATE()) < 18)
    
    UNION ALL
    
    SELECT
        'OVER120' AS AGE,
        PERSON_ID AS CDT_ID
    FROM
        CARE_RES_OMOP_DEV2_WKSP.OMOP.PERSON_RAW AS T1
    WHERE 
        (DATEDIFF(YEAR, BIRTH_DATETIME, GETDATE()) > 120)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PERSON' AS STANDARD_DATA_TABLE,
    'WRONG AGE:' || AGE AS QA_METRIC,
    'BIRTH_DATETIME' AS METRIC_FIELD,
    'WARNING' AS ERROR_TYPE,
    CDT_ID
FROM 
    AGE_ERR_DETAIL;

/*******************************************************************************
Column Descriptions:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Name of the table being checked
QA_METRIC: Description of the quality issue found
METRIC_FIELD: Field where the quality issue was identified
ERROR_TYPE: Severity of the quality issue
CDT_ID: Person identifier with the quality issue

Logic:
------
1. Creates a CTE that identifies two types of age errors:
   - Persons under 18 years old
   - Persons over 120 years old
2. Calculates age using DATEDIFF between BIRTH_DATETIME and current date
3. Returns formatted results with appropriate warning labels

Legal Warning:
-------------
This code is provided "AS IS" without warranty of any kind, either express or 
implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/