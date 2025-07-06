/*******************************************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_POS_DUP_PROVIDER_ID_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies possible duplicate records in the 
PROCEDURE_OCCURRENCE table based on matching key fields while having different 
VISIT_OCCURRENCE_IDs.
*******************************************************************************/

WITH TMP_DUPES AS (
    -- [Previous SQL code remains the same]
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE
    ,'POSSIBLE_DUPLICATE' AS QA_METRIC
    ,'VISIT_OCCURRENCE_ID'  AS METRIC_FIELD
    ,'FOLLOW_UP' AS ERROR_TYPE
    ,PO.PROCEDURE_OCCURRENCE_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PO 
    ON D.PERSON_ID = PO.PERSON_ID
    AND D.PROCEDURE_CONCEPT_ID = PO.PROCEDURE_CONCEPT_ID
    AND COALESCE(D.PROCEDURE_DATETIME,'1900-01-01') = COALESCE(PO.PROCEDURE_DATETIME,'1900-01-01')
    AND COALESCE(D.MODIFIER_CONCEPT_ID, 0) = COALESCE(PO.MODIFIER_CONCEPT_ID, 0)
    AND COALESCE(D.QUANTITY, 0) = COALESCE(PO.QUANTITY, 0)
    AND COALESCE(D.PROVIDER_ID, 0) = COALESCE(PO.PROVIDER_ID, 0);

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being analyzed
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Field being evaluated for duplicates
- ERROR_TYPE: Classification of the identified issue
- PROCEDURE_OCCURRENCE_ID: Unique identifier for the procedure record

Logic:
1. Creates temporary table of duplicate procedures based on:
   - PERSON_ID
   - PROCEDURE_CONCEPT_ID
   - PROCEDURE_DATETIME
   - MODIFIER_CONCEPT_ID
   - QUANTITY
   - PROVIDER_ID
2. Joins back to main table to get full record details

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either expressed or 
implied, including but not limited to the implied warranties of merchantability 
and/or fitness for a particular purpose. The user assumes all risk for any 
damages whatsoever resulting from the use or misuse of this code.
*******************************************************************************/