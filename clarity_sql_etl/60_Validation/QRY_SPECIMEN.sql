/*******************************************************************************
Script Name: QRY_SPECIMEN_VOCABULARY_VALIDATION.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This query joins the SPECIMEN table to OMOP vocabularies for data 
validation purposes, providing detailed specimen information with concept names.
********************************************************************************/

WITH specimen_detail AS (
    SELECT
        SPECIMEN.SPECIMEN_ID,
        SPECIMEN.PERSON_ID,
        LEFT(SPECIMEN.SPECIMEN_CONCEPT_ID || '::' || c1.CONCEPT_NAME, 100) AS SPECIMENS,
        SPECIMEN.SPECIMEN_DATETIME,
        SPECIMEN.SPECIMEN_TYPE_CONCEPT_ID || '::' || c2.CONCEPT_NAME AS SPECIMEN_TYPE,
        SPECIMEN.QUANTITY,
        SPECIMEN.UNIT_CONCEPT_ID || '::' || c3.CONCEPT_NAME AS UNIT,
        SPECIMEN.ANATOMIC_SITE_CONCEPT_ID || '::' || c4.CONCEPT_NAME AS ANATOMIC_SITE,
        SPECIMEN.DISEASE_STATUS_CONCEPT_ID || '::' || c5.CONCEPT_NAME AS DISEASE_STATUS,
        SPECIMEN.SPECIMEN_SOURCE_ID,
        SPECIMEN.SPECIMEN_SOURCE_VALUE,
        SPECIMEN.UNIT_SOURCE_VALUE,
        SPECIMEN.ANATOMIC_SITE_SOURCE_VALUE,
        SPECIMEN.DISEASE_STATUS_SOURCE_VALUE,
        'SPECIMEN' AS SDT_TAB,
        SPECIMEN.PERSON_ID || SPECIMEN.SPECIMEN_SOURCE_VALUE || SPECIMEN.SPECIMEN_DATETIME AS NK,
        SPECIMEN.ETL_MODULE,
        SPECIMEN.PHI_PAT_ID,
        SPECIMEN.PHI_MRN_CPI,
        SPECIMEN.SRC_TABLE,
        SPECIMEN.SRC_FIELD,
        SPECIMEN.SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.SPECIMEN
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c1
        ON SPECIMEN.SPECIMEN_CONCEPT_ID = c1.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c2
        ON SPECIMEN.SPECIMEN_TYPE_CONCEPT_ID = c2.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c3
        ON SPECIMEN.UNIT_CONCEPT_ID = c3.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c4
        ON SPECIMEN.ANATOMIC_SITE_CONCEPT_ID = c4.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c5
        ON SPECIMEN.DISEASE_STATUS_CONCEPT_ID = c5.CONCEPT_ID
)

SELECT *
FROM specimen_detail;

/*******************************************************************************
Column Descriptions:
- SPECIMEN_ID: Unique identifier for the specimen
- PERSON_ID: Identifier for the person from whom specimen was collected
- SPECIMENS: Concatenated specimen concept ID and name
- SPECIMEN_DATETIME: Date and time of specimen collection
- SPECIMEN_TYPE: Type of specimen with concept name
- QUANTITY: Amount of specimen collected
- UNIT: Unit of measurement with concept name
- ANATOMIC_SITE: Body site of specimen collection with concept name
- DISEASE_STATUS: Disease status with concept name
- Additional fields include source values and ETL tracking information

Logic:
1. Main SPECIMEN table is joined with CONCEPT table multiple times
2. Each join maps a concept ID to its corresponding concept name
3. Creates concatenated fields combining IDs with concept names
4. Natural key (NK) created from PERSON_ID, SOURCE_VALUE, and DATETIME

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either expressed or 
implied. The user assumes all risk for the use, results, and performance of this
code. No support or maintenance is provided with this code.
********************************************************************************/