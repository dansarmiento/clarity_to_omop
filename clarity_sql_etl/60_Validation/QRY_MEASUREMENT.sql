/*******************************************************************************
Script Name: QRY_MEASUREMENT_VOCABULARY_VALIDATION.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This query joins the MEASUREMENT table to OMOP vocabularies 
for data validation purposes, enriching measurement data with concept names
and related information.
********************************************************************************/

WITH SOURCE_DATA AS (
    SELECT
        MEASUREMENT.MEASUREMENT_ID,
        MEASUREMENT.PERSON_ID,
        LEFT(MEASUREMENT.MEASUREMENT_CONCEPT_ID || '::' || C1.CONCEPT_NAME, 100) AS MEASUREMENT,
        MEASUREMENT.MEASUREMENT_DATETIME,
        MEASUREMENT.MEASUREMENT_TYPE_CONCEPT_ID || '::' || C2.CONCEPT_NAME AS MEASUREMENT_TYPE,
        MEASUREMENT.OPERATOR_CONCEPT_ID || '::' || C3.CONCEPT_NAME AS OPERATOR,
        MEASUREMENT.VALUE_AS_NUMBER,
        MEASUREMENT.VALUE_AS_CONCEPT_ID || '::' || C4.CONCEPT_NAME AS VALUE_AS_CONCEPT,
        MEASUREMENT.UNIT_CONCEPT_ID || '::' || C5.CONCEPT_NAME AS UNIT,
        MEASUREMENT.RANGE_LOW,
        MEASUREMENT.RANGE_HIGH,
        PROVIDER.PROVIDER_NAME,
        MEASUREMENT.VISIT_OCCURRENCE_ID,
        MEASUREMENT.MEASUREMENT_SOURCE_VALUE,
        MEASUREMENT.MEASUREMENT_SOURCE_CONCEPT_ID || '::' || C6.CONCEPT_NAME AS MEASUREMENT_SOURCE,
        MEASUREMENT.UNIT_SOURCE_VALUE,
        MEASUREMENT.VALUE_SOURCE_VALUE,
        'MEASUREMENT' AS SDT_TAB,
        VISIT_OCCURRENCE.PERSON_ID || MEASUREMENT.MEASUREMENT_SOURCE_VALUE || 
            MEASUREMENT.MEASUREMENT_DATETIME AS NK,
        MEASUREMENT.ETL_MODULE,
        MEASUREMENT.PHI_PAT_ID,
        MEASUREMENT.PHI_MRN_CPI,
        MEASUREMENT.PHI_CSN_ID,
        MEASUREMENT.SRC_TABLE,
        MEASUREMENT.SRC_FIELD,
        MEASUREMENT.SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT MEASUREMENT
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER PROVIDER
        ON MEASUREMENT.PROVIDER_ID = PROVIDER.PROVIDER_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT C1
        ON C1.CONCEPT_ID = MEASUREMENT.MEASUREMENT_CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT C2
        ON C2.CONCEPT_ID = MEASUREMENT.MEASUREMENT_TYPE_CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT C3
        ON C3.CONCEPT_ID = MEASUREMENT.OPERATOR_CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT C4
        ON C4.CONCEPT_ID = MEASUREMENT.VALUE_AS_CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT C5
        ON C5.CONCEPT_ID = MEASUREMENT.UNIT_CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT C6
        ON C6.CONCEPT_ID = MEASUREMENT.MEASUREMENT_SOURCE_CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE VISIT_OCCURRENCE
        ON MEASUREMENT.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
)

SELECT * FROM SOURCE_DATA;

/*******************************************************************************
Column Descriptions:
- MEASUREMENT_ID: Unique identifier for each measurement record
- PERSON_ID: Unique identifier for the patient
- MEASUREMENT: Concatenated measurement concept ID and name
- MEASUREMENT_DATETIME: Date and time of measurement
- MEASUREMENT_TYPE: Type of measurement with concept name
- OPERATOR: Mathematical operator used in measurement
- VALUE_AS_NUMBER: Numeric value of measurement
- VALUE_AS_CONCEPT: Categorical value of measurement
- UNIT: Unit of measurement
- RANGE_LOW: Lower limit of normal range
- RANGE_HIGH: Upper limit of normal range
- PROVIDER_NAME: Name of healthcare provider
- VISIT_OCCURRENCE_ID: Link to visit record
- NK: Natural key combining person, source, and datetime

Logic:
1. Joins MEASUREMENT table with PROVIDER and VISIT_OCCURRENCE
2. Links to CONCEPT table multiple times for vocabulary lookups
3. Combines concept IDs with concept names for better readability
4. Creates a natural key (NK) for record identification

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either expressed 
or implied. The entire risk as to the quality and performance of the code
is with you. Should the code prove defective, you assume the cost of all 
necessary servicing, repair or correction.
********************************************************************************/