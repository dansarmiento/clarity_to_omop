/*
Purpose: Transform and map device exposure data from anesthesia records
Source: PULL_DEVICE_EXPOSURE_ANES_LDA
Target: Device exposure table conforming to OMOP CDM
*/

-- CTE to get device mapping from source to concept
WITH __dbt__cte__SOURCE_TO_CONCEPT_MAP_DEVICE_LDA AS (
    SELECT *
    FROM CARE_RES_OMOP_GEN_WKSP.OMOP.SOURCE_TO_CONCEPT_MAP
    WHERE SOURCE_VOCABULARY_ID = 'SH_DEVICE_LDA'
)

-- Main query to transform device exposure data
SELECT DISTINCT
    -- Standard OMOP CDM Fields
    PULL_DEVICE_EXPOSURE_ANES_LDA.PERSON_ID                  AS PERSON_ID,
    T_SOURCE_TO_CONCEPT_MAP_DEVICE_LDA.TARGET_CONCEPT_ID    AS DEVICE_CONCEPT_ID,
    DEVICE_EXPOSURE_START_DATE                              AS DEVICE_EXPOSURE_START_DATE,
    DEVICE_EXPOSURE_START_DATETIME                          AS DEVICE_EXPOSURE_START_DATETIME,
    DEVICE_EXPOSURE_END_DATE                               AS DEVICE_EXPOSURE_END_DATE,
    DEVICE_EXPOSURE_END_DATETIME                           AS DEVICE_EXPOSURE_END_DATETIME,
    32817                                                  AS DEVICE_TYPE_CONCEPT_ID,  -- EHR DETAIL
    UNIQUE_DEVICE_ID                                       AS UNIQUE_DEVICE_ID,
    PRODUCTION_ID                                          AS PRODUCTION_ID,           -- NEW 5.4
    QUANTITY                                               AS QUANTITY,
    PROVIDER.PROVIDER_ID                                   AS PROVIDER_ID,
    VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID                   AS VISIT_OCCURRENCE_ID,
    0                                                      AS VISIT_DETAIL_ID,
    DEVICE_SOURCE_VALUE                                    AS DEVICE_SOURCE_VALUE,
    0                                                      AS DEVICE_SOURCE_CONCEPT_ID,
    0                                                      AS UNIT_CONCEPT_ID,         -- NEW 5.4
    UNIT_SOURCE_VALUE                                      AS UNIT_SOURCE_VALUE,       -- NEW 5.4
    0                                                      AS UNIT_SOURCE_CONCEPT_ID,  -- NEW 5.4

    -- Custom Fields for Tracking
    'DEVICE_EXPOSURE_ANES_LDA'                             AS ETL_MODULE,
    VISIT_OCCURRENCE.phi_PAT_ID                           AS STAGE_PAT_ID,
    VISIT_OCCURRENCE.phi_MRN_CPI                          AS STAGE_MRN_CPI,
    VISIT_OCCURRENCE.phi_CSN_ID                           AS STAGE_CSN_ID,
    PULL_DEVICE_EXPOSURE_ANES_LDA.PULL_FLO_MEAS_ID        AS STAGE_FLO_MEAS_ID

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_DEVICE_EXPOSURE_ANES_LDA AS PULL_DEVICE_EXPOSURE_ANES_LDA

    -- Join to get concept mappings
    INNER JOIN __dbt__cte__SOURCE_TO_CONCEPT_MAP_DEVICE_LDA AS T_SOURCE_TO_CONCEPT_MAP_DEVICE_LDA
        ON PULL_DEVICE_EXPOSURE_ANES_LDA.PULL_FLO_MEAS_ID = T_SOURCE_TO_CONCEPT_MAP_DEVICE_LDA.SOURCE_CODE

    -- Join to get visit information
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON PULL_DEVICE_EXPOSURE_ANES_LDA.PULL_CSN_ID = VISIT_OCCURRENCE.phi_CSN_ID

    -- Join to get provider information
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER
        ON PULL_DEVICE_EXPOSURE_ANES_LDA.PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE;