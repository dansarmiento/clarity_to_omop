/*******************************************************************************
Script Name: QA_PROCEDURE_OCCURRENCE_ZEROCONCEPT_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

WITH ZEROCONCEPT_DETAIL
AS (
    SELECT 'PROCEDURE_CONCEPT_ID' AS METRIC_FIELD, 
           'ZERO CONCEPT' AS QA_METRIC, 
           'WARNING' AS ERROR_TYPE,
           PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (PROCEDURE_CONCEPT_ID = 0)

    UNION ALL

    SELECT 'PROCEDURE_TYPE_CONCEPT_ID' AS METRIC_FIELD, 
           'ZERO CONCEPT' AS QA_METRIC, 
           'WARNING' AS ERROR_TYPE,
           PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (PROCEDURE_TYPE_CONCEPT_ID = 0)

    UNION ALL

    --MODIFIER_CONCEPT_ID
    --IF THERE IS A VALUE IN 'MODIFIER_SOURCE_VALUE' THERE SHOULD NOT BE A ZERO IN 'MODIFIER_CONCEPT_ID'
    SELECT 'MODIFIER_CONCEPT_ID' AS METRIC_FIELD, 
           'ZERO CONCEPT' AS QA_METRIC, 
           'WARNING' AS ERROR_TYPE,
           PROCEDURE_OCCURRENCE_ID AS CDT_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE_RAW AS PROCEDURE_OCCURRENCE
    WHERE (MODIFIER_CONCEPT_ID = 0 AND MODIFIER_SOURCE_VALUE IS NOT NULL)
)

SELECT CAST(GETDATE() AS DATE) AS RUN_DATE,
       'PROCEDURE_OCCURRENCE' AS STANDARD_DATA_TABLE,
       QA_METRIC AS QA_METRIC,
       METRIC_FIELD AS METRIC_FIELD,
       ERROR_TYPE,
       CDT_ID
FROM ZEROCONCEPT_DETAIL
WHERE ERROR_TYPE <>'EXPECTED'

/*******************************************************************************
COLUMN DESCRIPTIONS:
- RUN_DATE: Date when the QA check was performed
- STANDARD_DATA_TABLE: Name of the table being analyzed
- QA_METRIC: Type of quality check being performed
- METRIC_FIELD: Specific field being evaluated
- ERROR_TYPE: Classification of the issue found (WARNING/ERROR)
- CDT_ID: Procedure Occurrence ID for reference

LOGIC:
This script identifies zero concepts in the PROCEDURE_OCCURRENCE table where:
1. PROCEDURE_CONCEPT_ID equals zero
2. PROCEDURE_TYPE_CONCEPT_ID equals zero
3. MODIFIER_CONCEPT_ID equals zero when MODIFIER_SOURCE_VALUE is not null

LEGAL WARNING:
This code is provided as-is without any implied warranty. Use at your own risk.
The author and Corewell Health are not liable for any damages or consequences 
resulting from the use of this code.
*******************************************************************************/