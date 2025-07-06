/*********************************************************
Script Name: OMOP_CS.QRY_VISIT_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025

Description: Joins the VISIT_DETAIL table to OMOP vocabularies 
for data validation purposes
*********************************************************/

WITH visit_detail_enhanced AS (
    SELECT
        VISIT_DETAIL.VISIT_DETAIL_ID,
        VISIT_DETAIL.PERSON_ID,
        VISIT_DETAIL.VISIT_DETAIL_CONCEPT_ID || '::' || c1.CONCEPT_NAME AS VISIT_DETAIL,
        VISIT_DETAIL.VISIT_DETAIL_START_DATETIME,
        VISIT_DETAIL.VISIT_DETAIL_END_DATETIME,
        VISIT_DETAIL.VISIT_DETAIL_TYPE_CONCEPT_ID || '::' || c2.CONCEPT_NAME AS VISIT_DETAIL_TYPE,
        PROVIDER.PROVIDER_ID || '::' || PROVIDER_NAME AS PROVIDER,
        CARE_SITE.CARE_SITE_ID || '::' || CARE_SITE_NAME AS CARE_SITE,
        VISIT_DETAIL.VISIT_DETAIL_SOURCE_VALUE,
        VISIT_DETAIL.VISIT_DETAIL_SOURCE_CONCEPT_ID || '::' || c3.CONCEPT_NAME AS VISIT_DETAIL_SOURCE,
        VISIT_DETAIL.ADMITTED_FROM_SOURCE_VALUE,
        VISIT_DETAIL.ADMITTED_FROM_CONCEPT_ID || '::' || c4.CONCEPT_NAME AS ADMITTING_SOURCE,
        VISIT_DETAIL.DISCHARGED_TO_SOURCE_VALUE,
        VISIT_DETAIL.DISCHARGED_TO_CONCEPT_ID || '::' || c4.CONCEPT_NAME AS DISCHARGE,
        VISIT_DETAIL.PRECEDING_VISIT_DETAIL_ID,
        VISIT_DETAIL.PARENT_VISIT_DETAIL_ID,
        VISIT_DETAIL.VISIT_OCCURRENCE_ID,
        'VISIT_DETAIL' AS SDT_TAB,
        VISIT_DETAIL.PERSON_ID || VISIT_DETAIL_SOURCE_VALUE || VISIT_DETAIL_START_DATETIME AS NK,
        VISIT_DETAIL.ETL_MODULE,
        VISIT_DETAIL.PHI_PAT_ID,
        VISIT_DETAIL.PHI_MRN_CPI,
        VISIT_DETAIL.PHI_CSN_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_DETAIL

    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c1
        ON c1.CONCEPT_ID = VISIT_DETAIL.VISIT_DETAIL_CONCEPT_ID

    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c2
        ON c2.CONCEPT_ID = VISIT_DETAIL.VISIT_DETAIL_TYPE_CONCEPT_ID

    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c3
        ON c3.CONCEPT_ID = VISIT_DETAIL.VISIT_DETAIL_SOURCE_CONCEPT_ID

    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c4
        ON c4.CONCEPT_ID = VISIT_DETAIL.ADMITTED_FROM_CONCEPT_ID

    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c5
        ON c5.CONCEPT_ID = VISIT_DETAIL.DISCHARGED_TO_CONCEPT_ID

    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE
        ON VISIT_DETAIL.CARE_SITE_ID = CARE_SITE.CARE_SITE_ID

    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER
        ON VISIT_DETAIL.PROVIDER_ID = PROVIDER.PROVIDER_ID
)

SELECT * FROM visit_detail_enhanced;

/*********************************************************
Column Descriptions:
- VISIT_DETAIL_ID: Unique identifier for each visit detail record
- PERSON_ID: Unique identifier for the patient
- VISIT_DETAIL: Concatenated visit detail concept ID and name
- VISIT_DETAIL_START/END_DATETIME: Start and end times of the visit
- VISIT_DETAIL_TYPE: Type of visit detail record
- PROVIDER: Healthcare provider information
- CARE_SITE: Location where care was provided
- SOURCE_VALUE fields: Original source system values
- NK: Natural key combining person, source, and datetime
- ETL_MODULE: ETL process identifier
- PHI fields: Protected Health Information identifiers

Logic:
1. Base table is VISIT_DETAIL
2. Joins to CONCEPT table multiple times for different concept lookups
3. Links to CARE_SITE and PROVIDER for additional detail
4. Creates concatenated fields for easier reading
5. Generates natural key (NK) for tracking

Legal Warning:
This code is provided as-is without any implied warranty.
Use at your own risk. No guarantee of fitness for any
particular purpose is provided.
*********************************************************/