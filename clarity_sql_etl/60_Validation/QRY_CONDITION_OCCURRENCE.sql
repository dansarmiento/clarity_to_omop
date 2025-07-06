/*******************************************************************************
Script Name: QRY_CONDITION_OCCURRENCE.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This query joins the CONDITION_OCCURRENCE table to OMOP vocabularies 
for Data Validation purposes
********************************************************************************/

WITH CONDITION_DATA AS (
    SELECT
        CONDITION_OCCURRENCE.CONDITION_OCCURRENCE_ID,
        CONDITION_OCCURRENCE.PERSON_ID,
        LEFT(CONDITION_OCCURRENCE.CONDITION_CONCEPT_ID || '::' || CONCEPT_2.CONCEPT_NAME, 100) AS CONDITION,
        CONDITION_OCCURRENCE.CONDITION_START_DATETIME,
        CONDITION_OCCURRENCE.CONDITION_END_DATETIME,
        CONDITION_OCCURRENCE.CONDITION_TYPE_CONCEPT_ID || '::' || CONCEPT.CONCEPT_NAME AS CONDITION_TYPE,
        CONDITION_OCCURRENCE.STOP_REASON,
        PROVIDER.PROVIDER_NAME,
        CONDITION_OCCURRENCE.VISIT_OCCURRENCE_ID,
        CONDITION_OCCURRENCE.CONDITION_SOURCE_VALUE,
        CONDITION_OCCURRENCE.CONDITION_SOURCE_CONCEPT_ID,
        CONDITION_OCCURRENCE.CONDITION_STATUS_CONCEPT_ID || '::' || CONCEPT_1.CONCEPT_NAME AS CONDITION_STATUS,
        'CONDITION' AS SDT_TAB,
        CONDITION_OCCURRENCE.PERSON_ID || CONDITION_SOURCE_VALUE || CONDITION_START_DATETIME AS NK,
        CONDITION_OCCURRENCE.ETL_MODULE,
        CONDITION_OCCURRENCE.PHI_PAT_ID,
        CONDITION_OCCURRENCE.PHI_MRN_CPI,
        CONDITION_OCCURRENCE.PHI_CSN_ID,
        CONDITION_OCCURRENCE.SRC_TABLE,
        CONDITION_OCCURRENCE.SRC_FIELD,
        CONDITION_OCCURRENCE.SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.CONDITION_OCCURRENCE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER
        ON CONDITION_OCCURRENCE.PROVIDER_ID = PROVIDER.PROVIDER_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS CONCEPT
        ON CONDITION_OCCURRENCE.CONDITION_TYPE_CONCEPT_ID = CONCEPT.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS CONCEPT_1
        ON CONDITION_OCCURRENCE.CONDITION_STATUS_CONCEPT_ID = CONCEPT_1.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT AS CONCEPT_2
        ON CONDITION_OCCURRENCE.CONDITION_CONCEPT_ID = CONCEPT_2.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE
        ON CONDITION_OCCURRENCE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
)

SELECT * FROM CONDITION_DATA;

/*******************************************************************************
Column Descriptions:
- CONDITION_OCCURRENCE_ID: Unique identifier for each condition occurrence
- PERSON_ID: Unique identifier for the patient
- CONDITION: Concatenated string of condition concept ID and name
- CONDITION_START_DATETIME: Start date/time of the condition
- CONDITION_END_DATETIME: End date/time of the condition
- CONDITION_TYPE: Concatenated string of condition type concept ID and name
- STOP_REASON: Reason for condition termination
- PROVIDER_NAME: Name of the healthcare provider
- VISIT_OCCURRENCE_ID: Identifier for the associated visit
- CONDITION_SOURCE_VALUE: Original condition value from source
- CONDITION_SOURCE_CONCEPT_ID: Source concept identifier
- CONDITION_STATUS: Concatenated string of status concept ID and name
- SDT_TAB: Static value indicating source table
- NK: Natural key combination
- ETL_MODULE: ETL module identifier
- PHI_PAT_ID: Protected health information - Patient ID
- PHI_MRN_CPI: Protected health information - Medical Record Number
- PHI_CSN_ID: Protected health information - CSN ID
- SRC_TABLE: Source table name
- SRC_FIELD: Source field name
- SRC_VALUE_ID: Source value identifier

Logic:
1. Creates a CTE (CONDITION_DATA) that joins CONDITION_OCCURRENCE with related tables
2. Joins with PROVIDER table for provider information
3. Joins with CONCEPT table multiple times for various concept lookups
4. Joins with VISIT_OCCURRENCE for visit information
5. Returns all columns from the CTE

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either express or 
implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
*******************************************************************************/