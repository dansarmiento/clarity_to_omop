/*******************************************************************************
Script Name: QRY_OBSERVATION.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This query joins the OBSERVATION table to OMOP vocabularies for data 
validation purposes, retrieving detailed observation records with associated 
concept names and provider information.
********************************************************************************/

WITH observation_data AS (
    SELECT
        OBSERVATION.OBSERVATION_ID,
        OBSERVATION.PERSON_ID,
        LEFT(OBSERVATION.OBSERVATION_CONCEPT_ID || '::' || c1.CONCEPT_NAME, 100) AS OBSERVATION,
        OBSERVATION.OBSERVATION_DATETIME,
        OBSERVATION.OBSERVATION_TYPE_CONCEPT_ID || '::' || c2.CONCEPT_NAME AS OBSERVATION_TYPE,
        OBSERVATION.VALUE_AS_NUMBER,
        OBSERVATION.VALUE_AS_STRING,
        OBSERVATION.VALUE_AS_CONCEPT_ID || '::' || c3.CONCEPT_NAME AS VALUE_AS_CONCEPT,
        OBSERVATION.QUALIFIER_CONCEPT_ID || '::' || c4.CONCEPT_NAME AS QUALIFIER,
        OBSERVATION.UNIT_CONCEPT_ID || '::' || c5.CONCEPT_NAME AS UNIT,
        PROVIDER.PROVIDER_NAME,
        OBSERVATION.VISIT_OCCURRENCE_ID,
        OBSERVATION.OBSERVATION_SOURCE_VALUE,
        OBSERVATION.OBSERVATION_SOURCE_CONCEPT_ID || '::' || c6.CONCEPT_NAME AS OBSERVATION_SOURCE_CONCEPT,
        OBSERVATION.UNIT_SOURCE_VALUE,
        OBSERVATION.QUALIFIER_SOURCE_VALUE,
        'OBSERVATION' AS SDT_TAB,
        VISIT_OCCURRENCE.PERSON_ID || OBSERVATION.OBSERVATION_SOURCE_VALUE || 
            OBSERVATION.OBSERVATION_DATETIME AS NK,
        OBSERVATION.ETL_MODULE,
        OBSERVATION.PHI_PAT_ID,
        OBSERVATION.PHI_MRN_CPI,
        OBSERVATION.PHI_CSN_ID,
        OBSERVATION.SRC_TABLE,
        OBSERVATION.SRC_FIELD,
        OBSERVATION.SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.OBSERVATION OBSERVATION
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c1
        ON OBSERVATION.OBSERVATION_CONCEPT_ID = c1.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c2
        ON OBSERVATION.OBSERVATION_TYPE_CONCEPT_ID = c2.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c3
        ON OBSERVATION.VALUE_AS_CONCEPT_ID = c3.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c4
        ON OBSERVATION.QUALIFIER_CONCEPT_ID = c4.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c5
        ON OBSERVATION.UNIT_CONCEPT_ID = c5.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c6
        ON OBSERVATION.OBSERVATION_SOURCE_CONCEPT_ID = c6.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER PROVIDER
        ON OBSERVATION.PROVIDER_ID = PROVIDER.PROVIDER_ID
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE VISIT_OCCURRENCE
        ON OBSERVATION.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
)

SELECT * FROM observation_data;

/*******************************************************************************
Column Descriptions:
- OBSERVATION_ID: Unique identifier for each observation record
- PERSON_ID: Unique identifier for the patient
- OBSERVATION: Concatenated observation concept ID and name
- OBSERVATION_DATETIME: Date and time of the observation
- OBSERVATION_TYPE: Type of observation with concept name
- VALUE_AS_NUMBER: Numeric value of the observation
- VALUE_AS_STRING: String value of the observation
- VALUE_AS_CONCEPT: Concept-based value of the observation
- QUALIFIER: Observation qualifier with concept name
- UNIT: Unit of measurement with concept name
- PROVIDER_NAME: Name of the healthcare provider
- VISIT_OCCURRENCE_ID: Associated visit identifier
- NK: Natural key combining person ID, source value, and datetime
- Various PHI fields: Protected Health Information identifiers
- Source fields: Original source information

Logic:
1. Creates a CTE joining OBSERVATION table with multiple CONCEPT tables
2. Links to PROVIDER and VISIT_OCCURRENCE tables
3. Concatenates concept IDs with their names for better readability
4. Returns all columns from the CTE

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either expressed or 
implied. The entire risk as to the quality and performance of the code is with
you. In no event shall the author be liable for any damages whatsoever arising
out of the use or inability to use this code.
********************************************************************************/