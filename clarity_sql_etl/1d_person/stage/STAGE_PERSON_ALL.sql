/*
Description: This query creates a staged person table combining demographic information
from multiple sources and mapping various codes to OMOP standard concepts.

Tables Used:
- PULL_PERSON_ALL: Main source of patient demographic data
- PROVIDER_RAW: Provider information
- LOCATION_RAW: Location details
- CARE_SITE_RAW: Care site information
- SOURCE_TO_CONCEPT_MAP_stg: Mapping table for standardized concepts
*/

-- CTE for Ethnicity Concept Mapping
WITH cte__SOURCE_TO_CONCEPT_MAP_ETHNICITY AS (
    SELECT *
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_CLARITY.SOURCE_TO_CONCEPT_MAP_stg
    WHERE SOURCE_VOCABULARY_ID = 'SH_ETHNICITY'
),

-- CTE for Race Concept Mapping
cte__SOURCE_TO_CONCEPT_MAP_RACE AS (
    SELECT *
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_CLARITY.SOURCE_TO_CONCEPT_MAP_stg
    WHERE SOURCE_VOCABULARY_ID = 'SH_RACE'
),

-- CTE for Gender Concept Mapping
cte__SOURCE_TO_CONCEPT_MAP_GENDER AS (
    SELECT *
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_CLARITY.SOURCE_TO_CONCEPT_MAP_stg
    WHERE SOURCE_VOCABULARY_ID = 'SH_GENDER'
)

-- Main Query
SELECT DISTINCT
    -- Standard OMOP Fields
    PERSON_ID                                                           AS PERSON_ID,
    COALESCE(SOURCE_TO_CONCEPT_MAP_GENDER.TARGET_CONCEPT_ID, 0)        AS GENDER_CONCEPT_ID,
    PULL_PERSON_ALL.YEAR_OF_BIRTH                                      AS YEAR_OF_BIRTH,
    PULL_PERSON_ALL.MONTH_OF_BIRTH                                     AS MONTH_OF_BIRTH,
    PULL_PERSON_ALL.DAY_OF_BIRTH                                       AS DAY_OF_BIRTH,
    PULL_PERSON_ALL.BIRTH_DATETIME                                     AS BIRTH_DATETIME,
    COALESCE(SOURCE_TO_CONCEPT_MAP_RACE.TARGET_CONCEPT_ID, 0)         AS RACE_CONCEPT_ID,
    COALESCE(SOURCE_TO_CONCEPT_MAP_ETHNICITY.TARGET_CONCEPT_ID, 0)    AS ETHNICITY_CONCEPT_ID,
    LOCATION.LOCATION_ID                                               AS LOCATION_ID,
    PROVIDER_ID                                                        AS PROVIDER_ID,
    CARE_SITE.CARE_SITE_ID                                            AS CARE_SITE_ID,
    PULL_PAT_ID                                                        AS PERSON_SOURCE_VALUE,
    CAST(SEX_C AS VARCHAR) || ':' || ZC_SEX_NAME                      AS GENDER_SOURCE_VALUE,
    NULL                                                               AS GENDER_SOURCE_CONCEPT_ID,
    CAST(PATIENT_RACE_C AS VARCHAR) || ':' || ZC_PATIENT_RACE_NAME    AS RACE_SOURCE_VALUE,
    NULL                                                               AS RACE_SOURCE_CONCEPT_ID,
    CAST(ETHNIC_GROUP_C AS VARCHAR) || ':' || ZC_ETHNIC_GROUP_NAME    AS ETHNICITY_SOURCE_VALUE,
    NULL                                                               AS ETHNICITY_SOURCE_CONCEPT_ID,
    
    -- Custom Fields for ETL tracking
    'STAGE_PERSON_ALL'                                                 AS ETL_MODULE,
    PULL_PERSON_ALL.PULL_PAT_ID                                       AS STAGE_PAT_ID,
    PULL_PERSON_ALL.PULL_MRN_CPI                                      AS STAGE_MRN_CPI

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_PERSON_ALL AS PULL_PERSON_ALL

    -- Join to get provider information
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER
        ON PULL_PERSON_ALL.CUR_PCP_PROV_ID = PROVIDER.PROVIDER_SOURCE_VALUE

    -- Join to get location information
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.LOCATION_RAW AS LOCATION
        ON PULL_PERSON_ALL.LOCATION_SOURCE_VALUE = LOCATION.LOCATION_SOURCE_VALUE

    -- Join to get care site information
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.CARE_SITE_RAW AS CARE_SITE
        ON PULL_PERSON_ALL.CUR_PRIM_LOC_ID = CARE_SITE.CARE_SITE_ID

    -- Joins for concept mapping
    LEFT JOIN cte__SOURCE_TO_CONCEPT_MAP_GENDER AS SOURCE_TO_CONCEPT_MAP_GENDER
        ON PULL_PERSON_ALL.SEX_C::VARCHAR = SOURCE_TO_CONCEPT_MAP_GENDER.SOURCE_CODE

    LEFT JOIN cte__SOURCE_TO_CONCEPT_MAP_RACE AS SOURCE_TO_CONCEPT_MAP_RACE
        ON PULL_PERSON_ALL.PATIENT_RACE_C::VARCHAR = SOURCE_TO_CONCEPT_MAP_RACE.SOURCE_CODE

    LEFT JOIN cte__SOURCE_TO_CONCEPT_MAP_ETHNICITY AS SOURCE_TO_CONCEPT_MAP_ETHNICITY
        ON PULL_PERSON_ALL.ETHNIC_GROUP_C::VARCHAR = SOURCE_TO_CONCEPT_MAP_ETHNICITY.SOURCE_CODE;