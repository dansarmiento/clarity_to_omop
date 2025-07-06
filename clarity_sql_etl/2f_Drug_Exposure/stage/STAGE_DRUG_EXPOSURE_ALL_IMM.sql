/*******************************************************************************
* Script: STAGE_DRUG_EXPOSURE_ALL_IMM
* Description: Transforms immunization data into the OMOP Drug_Exposure format
* 
* Tables Used:
*   - PULL_DRUG_EXPOSURE_ALL_IMM
*   - VISIT_OCCURRENCE_RAW
*   - PROVIDER_RAW
*   - T_IMM_SOURCE
*   - T_IMM_CONCEPT
*   - SOURCE_TO_CONCEPT_MAP
*******************************************************************************/

WITH __cte_SOURCE_TO_CONCEPT_MAP_IMM_ROUTE AS (
    -- Get immunization route mappings from source to concept map
    SELECT *
    FROM CARE_RES_OMOP_GEN_WKSP.OMOP.SOURCE_TO_CONCEPT_MAP
    WHERE SOURCE_VOCABULARY_ID = 'SH_IMM_ROUTE'
)

SELECT DISTINCT
    -- Standard OMOP CDM Fields
    PULL_DRUG_EXPOSURE_ALL_IMM.PERSON_ID                        AS PERSON_ID,
    T_IMM_CONCEPT.DRUG_CONCEPT_ID                              AS DRUG_CONCEPT_ID,
    DRUG_EXPOSURE_START_DATE                                    AS DRUG_EXPOSURE_START_DATE,
    DRUG_EXPOSURE_START_DATETIME                               AS DRUG_EXPOSURE_START_DATETIME,
    DRUG_EXPOSURE_START_DATE                                    AS DRUG_EXPOSURE_END_DATE,    -- End date same as start date
    DRUG_EXPOSURE_START_DATETIME                               AS DRUG_EXPOSURE_END_DATETIME,
    NULL                                                        AS VERBATIM_END_DATE,
    32817                                                       AS DRUG_TYPE_CONCEPT_ID,      -- EHR
    NULL                                                        AS STOP_REASON,
    NULL                                                        AS REFILLS,
    NULL                                                        AS QUANTITY,
    NULL                                                        AS DAYS_SUPPLY,
    NULL                                                        AS SIG,
    COALESCE(SOURCE_TO_CONCEPT_MAP_IMM_ROUTE.TARGET_CONCEPT_ID, 0) AS ROUTE_CONCEPT_ID,
    LOT_NUMBER                                                 AS LOT_NUMBER,
    PROVIDER.PROVIDER_ID                                       AS PROVIDER_ID,
    VISIT_OCCURRENCE_ID                                        AS VISIT_OCCURRENCE_ID,
    0                                                          AS VISIT_DETAIL_ID,
    PULL_DRUG_EXPOSURE_ALL_IMM.PULL_CLARITY_CVX_CODE::VARCHAR 
        || ':' || PULL_CLARITY_IMMUNZATN_NAME                  AS DRUG_SOURCE_VALUE,
    0                                                          AS DRUG_SOURCE_CONCEPT_ID,
    PULL_DRUG_EXPOSURE_ALL_IMM.PULL_ROUTE_C::VARCHAR 
        || ':' || PULL_ZC_ROUTE_NAME                           AS ROUTE_SOURCE_VALUE,
    PULL_DRUG_EXPOSURE_ALL_IMM.DOSE_UNIT_SOURCE_VALUE         AS DOSE_UNIT_SOURCE_VALUE,

    -- Custom Fields for Tracking
    'STAGE_DRUG_EXPOSURE_ALL_IMM'                             AS ETL_MODULE,
    VISIT_OCCURRENCE.phi_PAT_ID                               AS STAGE_PAT_ID,
    VISIT_OCCURRENCE.phi_MRN_CPI                              AS STAGE_MRN_CPI,
    VISIT_OCCURRENCE.phi_CSN_ID                               AS STAGE_CSN_ID,
    PULL_DRUG_EXPOSURE_ALL_IMM.PULL_IMMUNZATN_ID             AS STAGE_MEDICATION_ID

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_DRUG_EXPOSURE_ALL_IMM AS PULL_DRUG_EXPOSURE_ALL_IMM

    -- Join to get visit information
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON PULL_DRUG_EXPOSURE_ALL_IMM.PULL_CSN_ID = VISIT_OCCURRENCE.phi_CSN_ID

    -- Join to get provider information
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER
        ON PULL_DRUG_EXPOSURE_ALL_IMM.PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE

    -- Join to get immunization source concepts
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_IMM_SOURCE AS T_IMM_SOURCE
        ON PULL_DRUG_EXPOSURE_ALL_IMM.PULL_CLARITY_CVX_CODE = T_IMM_SOURCE.CONCEPT_CODE

    -- Join to get final drug concepts
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_IMM_CONCEPT AS T_IMM_CONCEPT
        ON T_IMM_SOURCE.CONCEPT_ID = T_IMM_CONCEPT.DRUG_CONCEPT_SOURCE_CONCEPT_ID

    -- Join to get route concepts
    LEFT JOIN __cte_SOURCE_TO_CONCEPT_MAP_IMM_ROUTE AS SOURCE_TO_CONCEPT_MAP_IMM_ROUTE
        ON PULL_DRUG_EXPOSURE_ALL_IMM.PULL_ROUTE_C::VARCHAR = SOURCE_TO_CONCEPT_MAP_IMM_ROUTE.SOURCE_CODE::VARCHAR

WHERE PULL_DRUG_EXPOSURE_ALL_IMM.DRUG_EXPOSURE_START_DATE IS NOT NULL;