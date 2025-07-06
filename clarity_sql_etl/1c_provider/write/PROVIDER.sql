/*******************************************************************************
* View: PROVIDER
* Description: Creates a filtered view of healthcare provider information,
* including only active providers with no serious quality issues.
*
* Tables Referenced:
* - CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW
* - CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDERS_REFERENCED
* - CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
*******************************************************************************/

SELECT
    -- Provider Identification
    PROVIDER.PROVIDER_ID,                    -- Unique identifier for the healthcare provider
    PROVIDER.PROVIDER_NAME,                  -- Name of the healthcare provider
    PROVIDER.NPI,                           -- National Provider Identifier
    PROVIDER.DEA,                           -- Drug Enforcement Administration number
    
    -- Provider Classifications
    PROVIDER.SPECIALTY_CONCEPT_ID,          -- Standardized specialty classification ID
    PROVIDER.CARE_SITE_ID,                 -- ID of the care site where provider practices
    
    -- Provider Demographics
    PROVIDER.YEAR_OF_BIRTH,                -- Provider's birth year
    PROVIDER.GENDER_CONCEPT_ID,            -- Standardized gender classification ID
    
    -- Source Values
    PROVIDER.PROVIDER_SOURCE_VALUE,         -- Original provider identifier from source data
    PROVIDER.SPECIALTY_SOURCE_VALUE,        -- Original specialty classification from source
    PROVIDER.SPECIALTY_SOURCE_CONCEPT_ID,   -- Source concept ID for specialty
    PROVIDER.GENDER_SOURCE_VALUE,           -- Original gender value from source
    PROVIDER.GENDER_SOURCE_CONCEPT_ID       -- Source concept ID for gender

FROM 
    -- Main provider data
    CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER

    -- Join to ensure only active providers are included
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDERS_REFERENCED AS PROVIDERS_REFERENCED
        ON PROVIDERS_REFERENCED.PROVIDER_ID = provider.PROVIDER_ID

    -- Quality control exclusion join
    LEFT JOIN (
        SELECT CDT_ID
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_QA.QA_ERR_DBT
        WHERE (STANDARD_DATA_TABLE = 'PROVIDER')    -- Filter for provider-related errors
          AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))  -- Only serious error types
    ) AS EXCLUSION_RECORDS
        ON PROVIDER.PROVIDER_ID = EXCLUSION_RECORDS.CDT_ID

-- Exclude records with quality issues
WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL);