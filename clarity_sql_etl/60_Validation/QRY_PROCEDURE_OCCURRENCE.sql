/*******************************************************************************
Script Name: QRY_PROCEDURE_OCCURRENCE.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This query joins the PROCEDURE_OCCURRENCE table to OMOP vocabularies 
for data validation purposes.
********************************************************************************/

WITH procedure_query AS (
    SELECT
        PROCEDURE_OCCURRENCE.PROCEDURE_OCCURRENCE_ID,
        PROCEDURE_OCCURRENCE.PERSON_ID,
        LEFT(PROCEDURE_OCCURRENCE.PROCEDURE_CONCEPT_ID || '::' || c1.CONCEPT_NAME, 100) AS PROCEDURE,
        PROCEDURE_OCCURRENCE.PROCEDURE_DATETIME,
        PROCEDURE_OCCURRENCE.PROCEDURE_TYPE_CONCEPT_ID || '::' || c2.CONCEPT_NAME AS "PROCEDURE TYPE",
        PROCEDURE_OCCURRENCE.MODIFIER_CONCEPT_ID || '::' || c3.CONCEPT_NAME AS MODIFIER,
        PROCEDURE_OCCURRENCE.QUANTITY,
        PROVIDER.PROVIDER_NAME,
        PROCEDURE_OCCURRENCE.VISIT_OCCURRENCE_ID,
        PROCEDURE_OCCURRENCE.PROCEDURE_SOURCE_VALUE,
        PROCEDURE_OCCURRENCE.PROCEDURE_SOURCE_CONCEPT_ID || '::' || c4.CONCEPT_NAME AS PROCEDURE_SOURCE,
        PROCEDURE_OCCURRENCE.MODIFIER_SOURCE_VALUE AS QUALIFIER_SOURCE_VALUE,
        'PROCEDURE' AS SDT_TAB,
        PROCEDURE_OCCURRENCE.PERSON_ID || PROCEDURE_SOURCE_VALUE || PROCEDURE_DATETIME AS NK,
        PROCEDURE_OCCURRENCE.ETL_MODULE,
        PROCEDURE_OCCURRENCE.PHI_PAT_ID,
        PROCEDURE_OCCURRENCE.PHI_MRN_CPI,
        PROCEDURE_OCCURRENCE.PHI_CSN_ID,
        PROCEDURE_OCCURRENCE.SRC_TABLE,
        PROCEDURE_OCCURRENCE.SRC_FIELD,
        PROCEDURE_OCCURRENCE.SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.PROCEDURE_OCCURRENCE

    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c1
        ON PROCEDURE_OCCURRENCE.PROCEDURE_CONCEPT_ID = c1.CONCEPT_ID

    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c2
        ON PROCEDURE_OCCURRENCE.PROCEDURE_TYPE_CONCEPT_ID = c2.CONCEPT_ID

    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c3
        ON PROCEDURE_OCCURRENCE.MODIFIER_CONCEPT_ID = c3.CONCEPT_ID

    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER
        ON PROCEDURE_OCCURRENCE.PROVIDER_ID = PROVIDER.PROVIDER_ID

    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c4
        ON PROCEDURE_OCCURRENCE.PROCEDURE_SOURCE_CONCEPT_ID = c4.CONCEPT_ID

    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE
        ON PROCEDURE_OCCURRENCE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
)

SELECT * FROM procedure_query;

/*******************************************************************************
Column Descriptions:
- PROCEDURE_OCCURRENCE_ID: Unique identifier for procedure occurrence
- PERSON_ID: Unique identifier for the patient
- PROCEDURE: Concatenated procedure concept ID and name
- PROCEDURE_DATETIME: Date and time of procedure
- PROCEDURE TYPE: Type of procedure record
- MODIFIER: Procedure modifier information
- QUANTITY: Number of procedures performed
- PROVIDER_NAME: Name of the provider performing procedure
- VISIT_OCCURRENCE_ID: Associated visit identifier
- PROCEDURE_SOURCE_VALUE: Original procedure code
- PROCEDURE_SOURCE: Source concept information
- QUALIFIER_SOURCE_VALUE: Original modifier value
- SDT_TAB: Source data table identifier
- NK: Natural key combination
- ETL_MODULE: ETL module identifier
- PHI_PAT_ID: Protected health information - Patient ID
- PHI_MRN_CPI: Protected health information - Medical Record Number
- PHI_CSN_ID: Protected health information - CSN ID
- SRC_TABLE: Source table name
- SRC_FIELD: Source field name
- SRC_VALUE_ID: Source value identifier

Logic:
1. Creates CTE 'procedure_query' joining PROCEDURE_OCCURRENCE with vocabulary tables
2. Joins with CONCEPT table multiple times for different concept lookups
3. Links to PROVIDER and VISIT_OCCURRENCE tables
4. Returns all columns from the CTE

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either express or 
implied. The user assumes all risk for the use, results, and performance of this
code. No implied warranty or fitness for a particular purpose shall apply.
*******************************************************************************/