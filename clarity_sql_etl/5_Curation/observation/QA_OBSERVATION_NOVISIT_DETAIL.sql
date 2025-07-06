/*******************************************************************************
Script Name: QA_OBSERVATION_NOVISIT_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies OBSERVATION records that lack corresponding 
VISIT_OCCURRENCE records in the OMOP CDM.

LEGAL WARNING:
This code is provided as-is without any implied warranty. Use at your own risk.
********************************************************************************/

WITH NOVISIT_DETAIL AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD, 
        'NO VISIT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        OBSERVATION_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION_RAW AS OBSERVATION
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON OBSERVATION.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'OBSERVATION' AS STANDARD_DATA_TABLE,
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
- CDT_ID: Unique identifier for the observation record

Logic:
1. Creates a CTE to identify OBSERVATION records without matching VISIT_OCCURRENCE
2. Joins OBSERVATION_RAW with VISIT_OCCURRENCE_RAW
3. Filters for records where no matching visit exists
4. Returns formatted results with standardized output columns

Legal Notice:
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code 
remains with you.
*******************************************************************************/