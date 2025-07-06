/***************************************************************
 * Query: STAGE_OBSERVATION_ALLERGY_ALL
 * Description: Retrieves and transforms allergy observation data
 * into OMOP CDM format
 ***************************************************************/

SELECT
    -- Core OMOP CDM Fields
    PULL_OBSERVATION_ALL_ALLERGY.PERSON_ID              AS PERSON_ID
    , 439224                                           AS OBSERVATION_CONCEPT_ID  -- Allergy to drug
    , OBSERVATION_DATE                                 AS OBSERVATION_DATE
    , OBSERVATION_DATETIME                             AS OBSERVATION_DATETIME
    , 32817                                           AS OBSERVATION_TYPE_CONCEPT_ID  -- NEW TYPE_ID
    , VALUE_AS_NUMBER                                 AS VALUE_AS_NUMBER
    , VALUE_AS_STRING                                 AS VALUE_AS_STRING
    , 0                                               AS VALUE_AS_CONCEPT_ID
    , 0                                               AS UNIT_CONCEPT_ID
    , 0                                               AS QUALIFIER_CONCEPT_ID
    , PROVIDER.PROVIDER_ID                            AS PROVIDER_ID
    , VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID            AS VISIT_OCCURRENCE_ID
    , 0                                               AS VISIT_DETAIL_ID
    , OBSERVATION_SOURCE_VALUE                        AS OBSERVATION_SOURCE_VALUE
    , 0                                               AS OBSERVATION_SOURCE_CONCEPT_ID
    , NULL                                            AS UNIT_SOURCE_VALUE
    , NULL                                            AS QUALIFIER_SOURCE_VALUE

    -- Additional OMOP Fields
    , NULL::NUMBER(28,0)                             AS OBSERVATION_EVENT_ID
    , 0::NUMBER(28,0)                                AS OBS_EVENT_FIELD_CONCEPT_ID
    , NULL::VARCHAR(50)                              AS VALUE_SOURCE_VALUE

    -- Custom Non-OMOP Fields
    , 'OBSERVATION_ALLERGY_ALL'                      AS ETL_MODULE
    , VISIT_OCCURRENCE.phi_PAT_ID                    AS STAGE_PAT_ID
    , VISIT_OCCURRENCE.phi_MRN_CPI                   AS STAGE_MRN_CPI
    , VISIT_OCCURRENCE.phi_CSN_ID                    AS STAGE_CSN_ID
    , PULL_ALLERGY_ID                               AS STAGE_ALLERGY_ID

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_OBSERVATION_ALL_ALLERGY AS PULL_OBSERVATION_ALL_ALLERGY
    -- Join to source observation mapping table
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_SOURCE_OBSERVATION AS T_SOURCE_OBSERVATION
        ON UPPER(PULL_OBSERVATION_ALL_ALLERGY.PULL_CONCEPT_NAME) = UPPER(T_SOURCE_OBSERVATION.CONCEPT_NAME)
    
    -- Join to concept observation mapping table
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_CONCEPT_OBSERVATION AS T_CONCEPT_OBSERVATION
        ON T_CONCEPT_OBSERVATION.SOURCE_CONCEPT_ID = T_SOURCE_OBSERVATION.CONCEPT_ID
    
    -- Join to visit occurrence table
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON PULL_OBSERVATION_ALL_ALLERGY.PULL_CSN_ID = VISIT_OCCURRENCE.phi_CSN_ID
    
    -- Join to provider table
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER
        ON PULL_OBSERVATION_ALL_ALLERGY.PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE

-- Filter for valid concept mappings
WHERE T_CONCEPT_OBSERVATION.CONCEPT_ID IS NOT NULL;