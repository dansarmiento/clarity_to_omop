 --PROVIDER
 
-- Configuration block specifying this should be materialized as a view in the OMOP schema
{{ config(materialized = 'view', schema = 'OMOP') }}

-- This query creates a filtered view of provider information from the raw provider data
SELECT
      PROVIDER.PROVIDER_ID           -- Unique identifier for the healthcare provider
    , PROVIDER.PROVIDER_NAME         -- Name of the healthcare provider
    , PROVIDER.NPI                   -- National Provider Identifier
    , PROVIDER.DEA                   -- Drug Enforcement Administration number
    , PROVIDER.SPECIALTY_CONCEPT_ID  -- Standardized specialty classification ID
    , PROVIDER.CARE_SITE_ID         -- ID of the care site where provider practices
    , PROVIDER.YEAR_OF_BIRTH        -- Provider's birth year
    , PROVIDER.GENDER_CONCEPT_ID     -- Standardized gender classification ID
    , PROVIDER.PROVIDER_SOURCE_VALUE -- Original provider identifier from source data
    , PROVIDER.SPECIALTY_SOURCE_VALUE -- Original specialty classification from source
    , PROVIDER.SPECIALTY_SOURCE_CONCEPT_ID -- Source concept ID for specialty
    , PROVIDER.GENDER_SOURCE_VALUE   -- Original gender value from source
    , PROVIDER.GENDER_SOURCE_CONCEPT_ID -- Source concept ID for gender

FROM
    -- Reference to the raw provider data table
    {{ref('PROVIDER_RAW')}} AS PROVIDER

    -- Join to ensure only active providers are included
    -- Only keeps providers who are referenced in other data tables
    INNER JOIN {{ref('PROVIDERS_REFERENCED')}} AS PROVIDERS_REFERENCED
        ON PROVIDERS_REFERENCED.PROVIDER_ID = provider.PROVIDER_ID

    -- Left join to identify records with quality issues
    -- This join is used for exclusion purposes
    LEFT JOIN (
        SELECT CDT_ID
        FROM {{ref('QA_ERR_DBT')}}
        WHERE (STANDARD_DATA_TABLE = 'PROVIDER')  -- Filter for provider-related errors
            AND (ERROR_TYPE IN ('FATAL', 'INVALID DATA'))  -- Only serious error types
        ) AS EXCLUSION_RECORDS
        ON PROVIDER.PROVIDER_ID = EXCLUSION_RECORDS.CDT_ID

-- Final filter to exclude any records with serious quality issues
WHERE (EXCLUSION_RECORDS.CDT_ID IS NULL)

