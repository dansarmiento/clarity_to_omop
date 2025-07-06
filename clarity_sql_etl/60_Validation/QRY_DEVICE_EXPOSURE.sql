/*******************************************************************************
Script Name: QRY_DEVICE_EXPOSURE.sql
Author: Roger J Carlson - Corewell Health
Date: June 2025
********************************************************************************/

/*******************************************************************************
Description: This query joins the DEVICE_EXPOSURE table to OMOP vocabularies 
for Data Validation purposes.
********************************************************************************/

WITH device_exposure_data AS (
    SELECT
        DEVICE_EXPOSURE.DEVICE_EXPOSURE_ID,
        DEVICE_EXPOSURE.PERSON_ID,
        LEFT(DEVICE_EXPOSURE.DEVICE_CONCEPT_ID || '::' || CONCEPT.CONCEPT_NAME, 100) AS DEVICE,
        DEVICE_EXPOSURE.DEVICE_EXPOSURE_START_DATETIME,
        DEVICE_EXPOSURE.DEVICE_EXPOSURE_END_DATETIME,
        DEVICE_EXPOSURE.DEVICE_TYPE_CONCEPT_ID || '::' || CONCEPT_1.CONCEPT_NAME AS DEVICE_TYPE,
        DEVICE_EXPOSURE.UNIQUE_DEVICE_ID,
        DEVICE_EXPOSURE.QUANTITY,
        PROVIDER.PROVIDER_NAME,
        DEVICE_EXPOSURE.VISIT_OCCURRENCE_ID,
        DEVICE_EXPOSURE.DEVICE_SOURCE_VALUE,
        DEVICE_EXPOSURE.DEVICE_SOURCE_CONCEPT_ID || '::' || CONCEPT_2.CONCEPT_NAME AS DEVICE_SOURCE_CONCEPT,
        DEVICE_EXPOSURE.PROVIDER_ID,
        'DEVICE' AS SDT_TAB,
        VISIT_OCCURRENCE.PERSON_ID || DEVICE_EXPOSURE.DEVICE_SOURCE_VALUE || 
            DEVICE_EXPOSURE.DEVICE_EXPOSURE_START_DATETIME AS NK,
        DEVICE_EXPOSURE.ETL_MODULE,
        DEVICE_EXPOSURE.PHI_PAT_ID,
        DEVICE_EXPOSURE.PHI_MRN_CPI,
        DEVICE_EXPOSURE.PHI_CSN_ID,
        DEVICE_EXPOSURE.SRC_TABLE,
        DEVICE_EXPOSURE.SRC_FIELD,
        DEVICE_EXPOSURE.SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER
        ON DEVICE_EXPOSURE.PROVIDER_ID = PROVIDER.PROVIDER_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT CONCEPT
        ON DEVICE_EXPOSURE.DEVICE_CONCEPT_ID = CONCEPT.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT CONCEPT_1
        ON DEVICE_EXPOSURE.DEVICE_TYPE_CONCEPT_ID = CONCEPT_1.CONCEPT_ID
    LEFT JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.CONCEPT CONCEPT_2
        ON DEVICE_EXPOSURE.DEVICE_SOURCE_CONCEPT_ID = CONCEPT_2.CONCEPT_ID
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE
        ON DEVICE_EXPOSURE.VISIT_OCCURRENCE_ID = VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID
)

SELECT *
FROM device_exposure_data;

/*******************************************************************************
Column Descriptions:
- DEVICE_EXPOSURE_ID: Unique identifier for device exposure
- PERSON_ID: Unique identifier for the patient
- DEVICE: Concatenated device concept ID and name
- DEVICE_EXPOSURE_START_DATETIME: Start time of device exposure
- DEVICE_EXPOSURE_END_DATETIME: End time of device exposure
- DEVICE_TYPE: Concatenated device type concept ID and name
- UNIQUE_DEVICE_ID: Unique identifier for specific device
- QUANTITY: Number of devices
- PROVIDER_NAME: Name of the healthcare provider
- VISIT_OCCURRENCE_ID: Identifier for the visit
- DEVICE_SOURCE_VALUE: Original source value for the device
- DEVICE_SOURCE_CONCEPT: Concatenated source concept ID and name
- NK: Natural key combining person ID, source value, and start datetime
- Various PHI and source fields for tracking purposes

Logic:
1. Creates CTE joining DEVICE_EXPOSURE table with related vocabulary tables
2. Uses LEFT JOINs for PROVIDER and CONCEPT tables to preserve all device records
3. Uses INNER JOIN with VISIT_OCCURRENCE to ensure valid visits only
4. Concatenates concept IDs with names for better readability
5. Truncates device name to 100 characters

Legal Warning:
This code is provided "AS IS" without warranty of any kind, either express or 
implied, including without limitation any implied warranties of condition, 
uninterrupted use, merchantability, fitness for a particular purpose, or 
non-infringement. Use at your own risk.
********************************************************************************/