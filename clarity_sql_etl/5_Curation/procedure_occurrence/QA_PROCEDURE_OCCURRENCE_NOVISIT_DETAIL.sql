/*******************************************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_NOVISIT_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies procedure occurrences that lack corresponding 
visit occurrence records in the OMOP CDM.

Logic:
1. Creates CTE to identify procedures without associated visits
2. Left joins PROCEDURE_OCCURRENCE with VISIT_OCCURRENCE
3. Returns records where no matching visit exists
4. Includes run date, table name, and error details in output
*******************************************************************************/

WITH NOVISIT_DETAIL AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD, 
        'NO VISIT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON PROCEDURE_OCCURRENCE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NOVISIT_DETAIL;

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the primary table being checked
- QA_METRIC: Description of the quality check performed
- METRIC_FIELD: Field being evaluated
- ERROR_TYPE: Severity of the issue found
- CDT_ID: Procedure occurrence identifier

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either express or 
implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/