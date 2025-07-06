/*******************************************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_POS_DUP_PROVIDER_ID_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This script identifies possible duplicate records in PROCEDURE_OCCURRENCE
             table based on matching key fields while excluding PROVIDER_ID
*******************************************************************************/

WITH TMP_DUPES AS (
    SELECT PERSON_ID
        ,PROCEDURE_CONCEPT_ID
        ,PROCEDURE_DATETIME
        ,MODIFIER_CONCEPT_ID
        ,QUANTITY
        ,VISIT_OCCURRENCE_ID
        ,COUNT(*) AS CNT
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS T1
    WHERE T1.PROCEDURE_CONCEPT_ID <> 0
        AND T1.PROCEDURE_CONCEPT_ID IS NOT NULL
        AND T1.PERSON_ID <> 0
        AND T1.PERSON_ID IS NOT NULL
    GROUP BY PERSON_ID
        ,PROCEDURE_CONCEPT_ID
        ,PROCEDURE_DATETIME
        ,MODIFIER_CONCEPT_ID
        ,QUANTITY
        ,VISIT_OCCURRENCE_ID
    HAVING COUNT(*) > 1
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE
    ,'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE
    ,'POSSIBLE_DUPLICATE' AS QA_METRIC
    ,'PROVIDER_ID'  AS METRIC_FIELD
    ,'FOLLOW_UP' AS ERROR_TYPE
    ,PO.PROCEDURE_OCCURRENCE_ID
FROM TMP_DUPES AS D
INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PO 
    ON D.PERSON_ID = PO.PERSON_ID
    AND D.PROCEDURE_CONCEPT_ID = PO.PROCEDURE_CONCEPT_ID
    AND COALESCE(D.PROCEDURE_DATETIME,'1900-01-01') = COALESCE(PO.PROCEDURE_DATETIME,'1900-01-01')
    AND COALESCE(D.MODIFIER_CONCEPT_ID, 0) = COALESCE(PO.MODIFIER_CONCEPT_ID, 0)
    AND COALESCE(D.QUANTITY, 0) = COALESCE(PO.QUANTITY, 0)
    AND COALESCE(D.VISIT_OCCURRENCE_ID, 0) = COALESCE(PO.VISIT_OCCURRENCE_ID, 0);

/*******************************************************************************
Column Descriptions:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being analyzed
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Field being evaluated for duplicates
- ERROR_TYPE: Classification of the potential error
- PROCEDURE_OCCURRENCE_ID: Unique identifier for the procedure record

Logic:
1. Creates temporary table of duplicate records based on key fields
2. Joins back to main table to get PROCEDURE_OCCURRENCE_ID
3. Excludes PROVIDER_ID from matching criteria to identify possible duplicates
   with different providers

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either express 
or implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/