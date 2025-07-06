/*
* Query: CARE_SITE Data Extraction
* Description: Retrieves distinct care site information from the staging table
* Table: STAGE_CARE_SITE_ALL
* Schema: CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE
*/

SELECT DISTINCT
    CARE_SITE_ID::NUMBER(28,0)                    AS CARE_SITE_ID,            -- Unique identifier for the care site
    CARE_SITE_NAME::VARCHAR                       AS CARE_SITE_NAME,          -- Name of the care site
    PLACE_OF_SERVICE_CONCEPT_ID::NUMBER(28,0)     AS PLACE_OF_SERVICE_CONCEPT_ID,  -- Concept ID for place of service
    LOCATION_ID::NUMBER(28,0)                     AS LOCATION_ID,             -- Foreign key to the location table
    CARE_SITE_SOURCE_VALUE::VARCHAR               AS CARE_SITE_SOURCE_VALUE,  -- Source value for the care site
    PLACE_OF_SERVICE_SOURCE_VALUE::VARCHAR        AS PLACE_OF_SERVICE_SOURCE_VALUE  -- Source value for place of service
FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_CARE_SITE_ALL AS T
QUALIFY 
    ROW_NUMBER() OVER (
        PARTITION BY CARE_SITE_ID
        ORDER BY CARE_SITE_ID
    ) = 1  -- Removes duplicates by keeping only the first occurrence of each CARE_SITE_ID