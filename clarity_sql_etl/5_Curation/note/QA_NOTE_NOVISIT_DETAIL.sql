/*******************************************************************************
Script Name: QA_NOTE_NOVISIT_DETAIL.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025

Purpose: Identifies NOTE records that lack corresponding VISIT_OCCURRENCE records
         for data quality assurance purposes.


*******************************************************************************/

WITH NOVISIT_DETAIL AS (
    SELECT 
        'VISIT_OCCURRENCE_ID' AS METRIC_FIELD, 
        'NO VISIT' AS QA_METRIC, 
        'WARNING' AS ERROR_TYPE, 
        NOTE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.NOTE_RAW AS NOTE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON NOTE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
    WHERE (VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID IS NULL)
)

SELECT 
    CAST(GETDATE() AS DATE) AS RUN_DATE,
    'NOTE' AS STANDARD_DATA_TABLE,
    QA_METRIC AS QA_METRIC,
    METRIC_FIELD AS METRIC_FIELD,
    ERROR_TYPE,
    CDT_ID
FROM NOVISIT_DETAIL
WHERE ERROR_TYPE <> 'EXPECTED';

/*******************************************************************************
COLUMN DESCRIPTIONS:
------------------
RUN_DATE: Date when the QA check was performed
STANDARD_DATA_TABLE: Indicates the primary table being checked (NOTE)
QA_METRIC: Description of the quality check being performed
METRIC_FIELD: The specific field being evaluated
ERROR_TYPE: Classification of the issue found (WARNING in this case)
CDT_ID: The NOTE_ID of the record with the issue

LOGIC:
------
1. Creates a CTE (NOVISIT_DETAIL) that identifies NOTE records without 
   corresponding VISIT_OCCURRENCE records using a LEFT JOIN
2. Main query returns all records from the CTE where ERROR_TYPE is not 'EXPECTED'
3. Results include metadata about the QA check and the specific records affected

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk arising out of the use or performance of the code 
remains with you. In no event shall the author be liable for any damages 
whatsoever arising out of or in connection with the use or performance 
of this code.
*******************************************************************************/