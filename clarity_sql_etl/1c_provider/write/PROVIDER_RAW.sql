/*
Description: Retrieves distinct provider information from the staging table
Table: STAGE_PROVIDER_ALL
Schema: CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE
*/

SELECT DISTINCT
    -- Provider identification and basic information
    PROVIDER_ID::NUMBER(28,0)                 AS PROVIDER_ID,          -- Unique identifier for the provider
    PROVIDER_NAME::VARCHAR                    AS PROVIDER_NAME,        -- Name of the provider
    NPI::VARCHAR                             AS NPI,                  -- National Provider Identifier
    DEA::VARCHAR                             AS DEA,                  -- Drug Enforcement Administration number
    
    -- Provider specialty and care site information
    SPECIALTY_CONCEPT_ID::NUMBER(28,0)        AS SPECIALTY_CONCEPT_ID, -- Concept ID for provider's specialty
    CARE_SITE_ID::NUMBER(28,0)               AS CARE_SITE_ID,        -- Associated care site identifier
    
    -- Provider demographic information
    YEAR_OF_BIRTH::NUMBER(28,0)              AS YEAR_OF_BIRTH,       -- Provider's birth year
    GENDER_CONCEPT_ID::NUMBER(28,0)          AS GENDER_CONCEPT_ID,   -- Concept ID for provider's gender
    
    -- Source values and concepts
    PROVIDER_SOURCE_VALUE::VARCHAR            AS PROVIDER_SOURCE_VALUE,           -- Original source value for provider
    SPECIALTY_SOURCE_VALUE::VARCHAR           AS SPECIALTY_SOURCE_VALUE,          -- Original source value for specialty
    SPECIALTY_SOURCE_CONCEPT_ID::NUMBER(28,0) AS SPECIALTY_SOURCE_CONCEPT_ID,    -- Source concept ID for specialty
    GENDER_SOURCE_VALUE::VARCHAR              AS GENDER_SOURCE_VALUE,            -- Original source value for gender
    GENDER_SOURCE_CONCEPT_ID::NUMBER(28,0)    AS GENDER_SOURCE_CONCEPT_ID       -- Source concept ID for gender

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_PROVIDER_ALL AS T;