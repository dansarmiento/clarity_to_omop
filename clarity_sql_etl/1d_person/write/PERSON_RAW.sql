/*
Description: This query retrieves and formats person demographic data from the staging table
Table: CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_PERSON_ALL
Purpose: Standardize person data according to OMOP CDM format while removing duplicates
*/

SELECT
    -- OMOP Standard Fields
    PERSON_ID::NUMBER(28,0)                   AS PERSON_ID,              -- Unique identifier for each person
    GENDER_CONCEPT_ID::NUMBER(28,0)           AS GENDER_CONCEPT_ID,      -- Standardized gender concept identifier
    YEAR_OF_BIRTH::NUMBER(28,0)               AS YEAR_OF_BIRTH,         -- Birth year
    MONTH_OF_BIRTH::NUMBER(28,0)              AS MONTH_OF_BIRTH,        -- Birth month
    DAY_OF_BIRTH::NUMBER(28,0)                AS DAY_OF_BIRTH,          -- Birth day
    BIRTH_DATETIME::DATETIME                  AS BIRTH_DATETIME,        -- Complete birth date and time
    RACE_CONCEPT_ID::NUMBER(28,0)             AS RACE_CONCEPT_ID,       -- Standardized race concept identifier
    ETHNICITY_CONCEPT_ID::NUMBER(28,0)        AS ETHNICITY_CONCEPT_ID,  -- Standardized ethnicity concept identifier
    LOCATION_ID::NUMBER(28,0)                 AS LOCATION_ID,           -- Foreign key to Location table
    PROVIDER_ID::NUMBER(28,0)                 AS PROVIDER_ID,           -- Foreign key to Provider table
    CARE_SITE_ID::NUMBER(28,0)                AS CARE_SITE_ID,          -- Foreign key to Care Site table
    
    -- Source Values and Concepts
    PERSON_SOURCE_VALUE::VARCHAR              AS PERSON_SOURCE_VALUE,    -- Original person identifier
    GENDER_SOURCE_VALUE::VARCHAR              AS GENDER_SOURCE_VALUE,    -- Original gender value
    GENDER_SOURCE_CONCEPT_ID::NUMBER(28,0)    AS GENDER_SOURCE_CONCEPT_ID, -- Source concept for gender
    RACE_SOURCE_VALUE::VARCHAR                AS RACE_SOURCE_VALUE,      -- Original race value
    RACE_SOURCE_CONCEPT_ID::NUMBER(28,0)      AS RACE_SOURCE_CONCEPT_ID,  -- Source concept for race
    ETHNICITY_SOURCE_VALUE::VARCHAR           AS ETHNICITY_SOURCE_VALUE, -- Original ethnicity value
    ETHNICITY_SOURCE_CONCEPT_ID::NUMBER(28,0) AS ETHNICITY_SOURCE_CONCEPT_ID, -- Source concept for ethnicity

    -- Non-OMOP Fields
    'STAGE_PERSON_ALL'                        AS ETL_MODULE,            -- ETL module identifier
    STAGE_PAT_ID                             AS phi_PAT_ID,            -- Protected health information - Patient ID
    STAGE_MRN_CPI                            AS phi_MRN_CPI            -- Protected health information - Medical Record Number

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_PERSON_ALL AS T

-- Remove duplicates by keeping the first record for each PERSON_ID
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY PERSON_ID
    ORDER BY PERSON_ID
) = 1