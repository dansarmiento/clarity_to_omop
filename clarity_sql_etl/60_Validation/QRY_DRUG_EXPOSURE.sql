/*******************************************************************************
Script Name: QRY_DRUG_EXPOSURE_DETAIL
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This query joins the DRUG_EXPOSURE table to OMOP vocabularies 
for data validation purposes, providing detailed information about drug exposures
including concepts, provider details, and visit information.
********************************************************************************/

WITH drug_exposure_detail AS (
    SELECT
        DRUG_EXPOSURE.DRUG_EXPOSURE_ID,
        DRUG_EXPOSURE.PERSON_ID,
        LEFT(DRUG_EXPOSURE.DRUG_CONCEPT_ID || '::' || c1.CONCEPT_NAME, 100) AS DRUG_CONCEPT,
        DRUG_EXPOSURE.DRUG_EXPOSURE_START_DATETIME,
        DRUG_EXPOSURE.DRUG_EXPOSURE_END_DATETIME,
        DRUG_EXPOSURE.VERBATIM_END_DATE,
        DRUG_EXPOSURE.DRUG_TYPE_CONCEPT_ID || '::' || c2.CONCEPT_NAME AS DRUG_TYPE,
        DRUG_EXPOSURE.STOP_REASON,
        DRUG_EXPOSURE.REFILLS,
        DRUG_EXPOSURE.QUANTITY,
        DRUG_EXPOSURE.DAYS_SUPPLY,
        DRUG_EXPOSURE.SIG,
        DRUG_EXPOSURE.ROUTE_CONCEPT_ID || '::' || c3.CONCEPT_NAME AS ROUTE,
        DRUG_EXPOSURE.LOT_NUMBER,
        PROVIDER.PROVIDER_NAME,
        DRUG_EXPOSURE.VISIT_OCCURRENCE_ID,
        DRUG_EXPOSURE.DRUG_SOURCE_VALUE,
        DRUG_EXPOSURE.DRUG_SOURCE_CONCEPT_ID || '::' || c4.CONCEPT_NAME AS DRUG_SOURCE_CONCEPT,
        DRUG_EXPOSURE.ROUTE_SOURCE_VALUE,
        DRUG_EXPOSURE.DOSE_UNIT_SOURCE_VALUE,
        'DRUG' AS SDT_TAB,
        VISIT_OCCURRENCE.PERSON_ID || DRUG_SOURCE_VALUE || DRUG_EXPOSURE_START_DATETIME AS NK,
        DRUG_EXPOSURE.ETL_MODULE,
        DRUG_EXPOSURE.PHI_PAT_ID,
        DRUG_EXPOSURE.PHI_MRN_CPI,
        DRUG_EXPOSURE.PHI_CSN_ID,
        DRUG_EXPOSURE.SRC_TABLE,
        DRUG_EXPOSURE.SRC_FIELD,
        DRUG_EXPOSURE.SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c1
        ON DRUG_EXPOSURE.DRUG_CONCEPT_ID = c1.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c2
        ON DRUG_EXPOSURE.DRUG_TYPE_CONCEPT_ID = c2.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c3
        ON DRUG_EXPOSURE.ROUTE_CONCEPT_ID = c3.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT c4
        ON DRUG_EXPOSURE.DRUG_SOURCE_CONCEPT_ID = c4.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER
        ON DRUG_EXPOSURE.PROVIDER_ID = PROVIDER.PROVIDER_ID
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE
        ON DRUG_EXPOSURE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
)

SELECT * FROM drug_exposure_detail;

/*******************************************************************************
Column Descriptions:
- DRUG_EXPOSURE_ID: Unique identifier for each drug exposure record
- PERSON_ID: Unique identifier for the patient
- DRUG_CONCEPT: Standardized drug concept name and ID
- DRUG_EXPOSURE_START_DATETIME: Start time of drug exposure
- DRUG_EXPOSURE_END_DATETIME: End time of drug exposure
- DRUG_TYPE: Type of drug exposure (prescription, administration, etc.)
- QUANTITY: Amount of drug administered
- DAYS_SUPPLY: Number of days the drug supply should last
- ROUTE: Administration route of the drug
- PROVIDER_NAME: Name of the prescribing provider
- NK: Natural key combining person, drug, and datetime

Logic:
1. Joins DRUG_EXPOSURE table with CONCEPT table multiple times to get:
   - Drug concepts
   - Drug type concepts
   - Route concepts
   - Source concepts
2. Links to PROVIDER table for provider information
3. Links to VISIT_OCCURRENCE for visit context
4. Creates a natural key (NK) for unique identification

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either expressed 
or implied, including but not limited to the implied warranties of merchantability 
and/or fitness for a particular purpose. Use at your own risk.
*******************************************************************************/