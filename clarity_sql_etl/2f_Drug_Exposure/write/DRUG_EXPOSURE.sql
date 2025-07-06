/*******************************************************************************
* Query: DRUG_EXPOSURE Data Extraction
* Description: Retrieves drug exposure data while excluding records with fatal 
*              or invalid data errors
* Tables: DRUG_EXPOSURE_RAW, QA_ERR_DBT
*******************************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    DRUG_EXPOSURE_ID,                  -- Unique identifier for drug exposure
    PERSON_ID,                         -- Foreign key to the PERSON table
    DRUG_CONCEPT_ID,                   -- Concept ID for the drug
    DRUG_EXPOSURE_START_DATE,          -- Start date of drug exposure
    DRUG_EXPOSURE_START_DATETIME,      -- Start datetime of drug exposure
    DRUG_EXPOSURE_END_DATE,            -- End date of drug exposure
    DRUG_EXPOSURE_END_DATETIME,        -- End datetime of drug exposure
    VERBATIM_END_DATE,                -- Verbatim end date from source
    DRUG_TYPE_CONCEPT_ID,             -- Type of drug exposure record
    STOP_REASON,                      -- Reason for stopping drug
    REFILLS,                          -- Number of refills
    QUANTITY,                         -- Quantity of drug
    DAYS_SUPPLY,                      -- Days of supply
    SIG,                             -- Prescription instructions
    ROUTE_CONCEPT_ID,                -- Route of administration concept ID
    LOT_NUMBER,                      -- Lot number of drug
    PROVIDER_ID,                     -- Foreign key to PROVIDER table
    VISIT_OCCURRENCE_ID,             -- Foreign key to VISIT_OCCURRENCE table
    VISIT_DETAIL_ID,                 -- Foreign key to VISIT_DETAIL table
    DRUG_SOURCE_VALUE,               -- Source value for drug (human readable)
    DRUG_SOURCE_CONCEPT_ID,          -- Source concept ID for drug
    ROUTE_SOURCE_VALUE,              -- Source value for route
    DOSE_UNIT_SOURCE_VALUE,          -- Source value for dose unit

    -- Non-OMOP Fields
    etl_MODULE,                      -- ETL module identifier
    phi_PAT_ID,                      -- Patient identifier (PHI)
    phi_MRN_CPI,                     -- Medical record number (PHI)
    phi_CSN_ID,                      -- Contact serial number (PHI)

    -- Source Link Fields
    src_TABLE,                       -- Source table name
    src_FIELD,                       -- Source field name
    src_VALUE_ID                     -- Source value identifier

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP.DRUG_EXPOSURE_RAW AS DRUG_EXPOSURE
    LEFT JOIN (
        SELECT CDT_ID
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT AS QA_ERR_DBT
        WHERE (STANDARD_DATA_TABLE = 'DRUG_EXPOSURE')
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))
    ) AS EXCLUSION_RECORDS
    ON DRUG_EXPOSURE.DRUG_EXPOSURE_ID = EXCLUSION_RECORDS.CDT_ID
WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL);