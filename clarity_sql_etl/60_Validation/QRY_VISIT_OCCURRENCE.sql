/*******************************************************************************
Script Name: OMOP_CS.QRY_VISIT_OCCURRENCE
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This query joins the VISIT_OCCURRENCE table to OMOP vocabularies 
for data validation purposes, providing detailed information about patient visits
including provider, care site, and various concept mappings.
********************************************************************************/

WITH visit_occurrence_details AS (
    SELECT
        VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID,      -- Unique identifier for the visit
        VISIT_OCCURRENCE.PERSON_ID,                -- Patient identifier
        VISIT_OCCURRENCE.VISIT_TYPE_CONCEPT_ID || '::' || c1.CONCEPT_NAME AS VISIT_TYPE,  -- Visit type with description
        VISIT_OCCURRENCE.VISIT_START_DATETIME,      -- Start time of visit
        VISIT_OCCURRENCE.VISIT_END_DATETIME,        -- End time of visit
        PROVIDER.PROVIDER_ID || '::' || PROVIDER_NAME AS PROVIDER,  -- Provider details
        CARE_SITE.CARE_SITE_ID || '::' || CARE_SITE_NAME AS CARE_SITE,  -- Care site information
        VISIT_OCCURRENCE.VISIT_CONCEPT_ID || '::' || c2.CONCEPT_NAME AS VISIT,  -- Visit concept with description
        VISIT_OCCURRENCE.VISIT_SOURCE_CONCEPT_ID,   -- Original source concept ID
        VISIT_OCCURRENCE.ADMITTED_FROM_CONCEPT_ID || '::' || c3.CONCEPT_NAME AS ADMITTING_SOURCE,  -- Admission source
        VISIT_OCCURRENCE.DISCHARGED_TO_CONCEPT_ID || '::' || c4.CONCEPT_NAME AS DISCHARGE,  -- Discharge destination
        VISIT_OCCURRENCE.ADMITTED_FROM_SOURCE_VALUE,  -- Original admission source value
        VISIT_OCCURRENCE.ADMITTED_FROM_CONCEPT_ID,    -- Admission concept ID
        VISIT_OCCURRENCE.DISCHARGED_TO_SOURCE_VALUE,  -- Original discharge value
        VISIT_OCCURRENCE.DISCHARGED_TO_CONCEPT_ID,    -- Discharge concept ID
        VISIT_OCCURRENCE.PRECEDING_VISIT_OCCURRENCE_ID,  -- Link to previous visit
        'VISIT_OCCURRENCE' AS SDT_TAB,              -- Source table identifier
        VISIT_OCCURRENCE.phi_CSN_ID AS NK,          -- Natural key
        VISIT_OCCURRENCE.ETL_MODULE,                -- ETL process identifier
        VISIT_OCCURRENCE.PHI_PAT_ID,                -- Patient identifier (PHI)
        VISIT_OCCURRENCE.PHI_MRN_CPI,               -- Medical record number
        VISIT_OCCURRENCE.PHI_CSN_ID                 -- Contact serial number
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER
        ON VISIT_OCCURRENCE.PROVIDER_ID = PROVIDER.PROVIDER_ID
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE
        ON VISIT_OCCURRENCE.CARE_SITE_ID = CARE_SITE.CARE_SITE_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c1
        ON VISIT_OCCURRENCE.VISIT_TYPE_CONCEPT_ID = c1.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c2
        ON VISIT_OCCURRENCE.VISIT_CONCEPT_ID = c2.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c3
        ON VISIT_OCCURRENCE.ADMITTED_FROM_CONCEPT_ID = c3.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c4
        ON VISIT_OCCURRENCE.DISCHARGED_TO_CONCEPT_ID = c4.CONCEPT_ID
)

SELECT * FROM visit_occurrence_details;

/*******************************************************************************
Column Descriptions:
- VISIT_OCCURRENCE_ID: Primary key for the visit record
- PERSON_ID: Foreign key to the PERSON table
- VISIT_TYPE: Concatenated string of visit type concept ID and name
- VISIT_START_DATETIME: Timestamp when the visit began
- VISIT_END_DATETIME: Timestamp when the visit ended
- PROVIDER: Concatenated string of provider ID and name
- CARE_SITE: Concatenated string of care site ID and name
- VISIT: Concatenated string of visit concept ID and name
- VISIT_SOURCE_CONCEPT_ID: Concept ID from the source data
- ADMITTING_SOURCE: Concatenated string of admitting source concept ID and name
- DISCHARGE: Concatenated string of discharge concept ID and name
- PHI fields: Protected Health Information fields for patient identification

Logic:
1. Creates a CTE that joins VISIT_OCCURRENCE with related tables
2. Uses LEFT JOIN for PROVIDER to include visits without provider information
3. Uses INNER JOINs for required relationships
4. Concatenates IDs with names using '::' as a separator
5. Returns all columns from the CTE

LEGAL DISCLAIMER:
This code is provided "AS IS" without warranty of any kind.
The entire risk as to the quality and performance of the code is with you.
Should the code prove defective, you assume the cost of all necessary
servicing, repair or correction.
********************************************************************************/