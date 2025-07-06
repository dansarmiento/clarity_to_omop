/*******************************************************************************
* Query: Device Exposure Data Extraction
* Description: Retrieves device exposure records excluding invalid/fatal error records
* Tables: 
*   - DEVICE_EXPOSURE_RAW
*   - QA_ERR_DBT (for exclusions)
*******************************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    DEVICE_EXPOSURE_ID,
    PERSON_ID,
    DEVICE_CONCEPT_ID,
    DEVICE_EXPOSURE_START_DATE,
    DEVICE_EXPOSURE_START_DATETIME,
    DEVICE_EXPOSURE_END_DATE,
    DEVICE_EXPOSURE_END_DATETIME,
    DEVICE_TYPE_CONCEPT_ID,
    UNIQUE_DEVICE_ID,
    PRODUCTION_ID,              -- Added in OMOP CDM v5.4
    QUANTITY,
    PROVIDER_ID,
    VISIT_OCCURRENCE_ID,
    VISIT_DETAIL_ID,
    DEVICE_SOURCE_VALUE,        -- Human readable Source Value
    DEVICE_SOURCE_CONCEPT_ID,
    UNIT_CONCEPT_ID,           -- Added in OMOP CDM v5.4
    UNIT_SOURCE_VALUE,         -- Added in OMOP CDM v5.4
    UNIT_SOURCE_CONCEPT_ID,    -- Added in OMOP CDM v5.4

    -- Custom Non-OMOP Fields
    ETL_MODULE,
    phi_PAT_ID,
    phi_MRN_CPI,
    phi_CSN_ID,

    -- Source Reference Fields
    src_TABLE,
    src_FIELD,
    src_VALUE_ID

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP.DEVICE_EXPOSURE_RAW AS DEVICE_EXPOSURE

-- Exclude records with fatal or invalid data errors
LEFT JOIN (
    SELECT 
        CDT_ID
    FROM 
        CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
    WHERE 
        (STANDARD_DATA_TABLE = 'DEVICE_EXPOSURE')
        AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
) AS EXCLUSION_RECORDS
    ON DEVICE_EXPOSURE.DEVICE_EXPOSURE_ID = EXCLUSION_RECORDS.CDT_ID

WHERE 
    EXCLUSION_RECORDS.CDT_ID IS NULL;