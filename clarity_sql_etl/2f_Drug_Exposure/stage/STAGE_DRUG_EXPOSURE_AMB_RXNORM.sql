/*******************************************************************************
* Script: STAGE_DRUG_EXPOSURE_AMB_RXNORM
* Description: Transforms and stages ambulatory drug exposure data with RxNorm codes
* 
* Tables Referenced:
* - OMOP_PULL.PULL_DRUG_EXPOSURE_AMB_RXNORM
* - OMOP.VISIT_OCCURRENCE_RAW
* - OMOP.PROVIDER_RAW
* - OMOP_STAGE.TOP_AMB_RXNORM
* - OMOP_STAGE.T_DRUG_SOURCE
* - OMOP_STAGE.T_DRUG_CONCEPT
* - OMOP_CLARITY.SOURCE_TO_CONCEPT_MAP
*******************************************************************************/

-- CTE to get route concepts from source to concept mapping
WITH cte__SOURCE_TO_CONCEPT_MAP_ROUTE AS (
    SELECT *
    FROM CARE_RES_OMOP_GEN_WKSP.OMOP.SOURCE_TO_CONCEPT_MAP
    WHERE SOURCE_VOCABULARY_ID = 'SH_ROUTE'
)

-- Main query to transform drug exposure data
SELECT DISTINCT
    -- Standard OMOP CDM fields
    PULL_DRUG_EXPOSURE_AMB_RXNORM.PERSON_ID                     AS PERSON_ID,
    T_DRUG_CONCEPT.DRUG_CONCEPT_ID                             AS DRUG_CONCEPT_ID,
    DRUG_EXPOSURE_START_DATE                                   AS DRUG_EXPOSURE_START_DATE,
    DRUG_EXPOSURE_START_DATETIME                               AS DRUG_EXPOSURE_START_DATETIME,
    DRUG_EXPOSURE_END_DATE                                     AS DRUG_EXPOSURE_END_DATE,
    DRUG_EXPOSURE_END_DATETIME                                 AS DRUG_EXPOSURE_END_DATETIME,
    VERBATIM_END_DATE                                         AS VERBATIM_END_DATE,
    32817                                                     AS DRUG_TYPE_CONCEPT_ID, -- EHR
    STOP_REASON                                               AS STOP_REASON,
    REFILLS                                                   AS REFILLS,
    QUANTITY                                                  AS QUANTITY,
    DAYS_SUPPLY                                               AS DAYS_SUPPLY,
    SIG                                                       AS SIG,
    COALESCE(SOURCE_TO_CONCEPT_MAP_ROUTE.TARGET_CONCEPT_ID, 0) AS ROUTE_CONCEPT_ID,
    LOT_NUMBER                                                AS LOT_NUMBER,
    PROVIDER.PROVIDER_ID                                      AS PROVIDER_ID,
    VISIT_OCCURRENCE_ID                                       AS VISIT_OCCURRENCE_ID,
    0                                                         AS VISIT_DETAIL_ID,
    
    -- Source value fields
    PULL_DRUG_EXPOSURE_AMB_RXNORM.PULL_MEDICATION_ID::VARCHAR 
        || ':' || PULL_MEDICATION_NAME                        AS DRUG_SOURCE_VALUE,
    T_DRUG_SOURCE.CONCEPT_ID                                 AS DRUG_SOURCE_CONCEPT_ID,
    PULL_DRUG_EXPOSURE_AMB_RXNORM.PULL_MED_ROUTE_C::VARCHAR
        || ':' || PULL_ZC_ADMIN_ROUTE_NAME                   AS ROUTE_SOURCE_VALUE,
    PULL_DRUG_EXPOSURE_AMB_RXNORM.DOSE_UNIT_SOURCE_VALUE     AS DOSE_UNIT_SOURCE_VALUE,
    
    -- Custom non-OMOP fields
    'DRUG_EXPOSURE_AMB_RXNORM'                               AS ETL_MODULE,
    VISIT_OCCURRENCE.phi_PAT_ID                              AS STAGE_PAT_ID,
    VISIT_OCCURRENCE.phi_MRN_CPI                             AS STAGE_MRN_CPI,
    VISIT_OCCURRENCE.phi_CSN_ID                              AS STAGE_CSN_ID,
    PULL_DRUG_EXPOSURE_AMB_RXNORM.PULL_MEDICATION_ID         AS STAGE_MEDICATION_ID

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_DRUG_EXPOSURE_AMB_RXNORM AS PULL_DRUG_EXPOSURE_AMB_RXNORM

    -- Join to get visit information
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON PULL_DRUG_EXPOSURE_AMB_RXNORM.PULL_CSN_ID = VISIT_OCCURRENCE.phi_CSN_ID

    -- Join to get provider information
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER
        ON PULL_DRUG_EXPOSURE_AMB_RXNORM.PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE

    -- Join to get RxNorm codes
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.TOP_AMB_RXNORM AS TOP_RXNORM
        ON PULL_DRUG_EXPOSURE_AMB_RXNORM.PULL_MEDICATION_ID = TOP_RXNORM.PULL_MEDICATION_ID

    -- Join to get source drug concepts
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_DRUG_SOURCE AS T_DRUG_SOURCE
        ON TOP_RXNORM.CONCEPT_CODE = T_DRUG_SOURCE.CONCEPT_CODE

    -- Join to get standard drug concepts
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_DRUG_CONCEPT AS T_DRUG_CONCEPT
        ON T_DRUG_SOURCE.CONCEPT_ID = T_DRUG_CONCEPT.DRUG_CONCEPT_SOURCE_CONCEPT_ID

    -- Join to get route concepts
    LEFT JOIN cte__SOURCE_TO_CONCEPT_MAP_ROUTE AS SOURCE_TO_CONCEPT_MAP_ROUTE
        ON PULL_DRUG_EXPOSURE_AMB_RXNORM.PULL_MED_ROUTE_C::VARCHAR = SOURCE_TO_CONCEPT_MAP_ROUTE.SOURCE_CODE::VARCHAR

    -- Subquery to remove duplicates
    INNER JOIN (
        SELECT 
            MIN(PULL_RXNORM_CODES_LINE) AS FIRSTLINE,
            TOP_RXNORM.PULL_MEDICATION_ID,
            MIN(CONCEPT_CODE) AS CONCEPT_CODE,
            CONCEPT_CLASS_ID,
            THEORDER
        FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.TOP_AMB_RXNORM AS TOP_RXNORM
        GROUP BY 
            TOP_RXNORM.PULL_MEDICATION_ID,
            CONCEPT_CLASS_ID,
            THEORDER
        QUALIFY ROW_NUMBER() OVER (
            PARTITION BY TOP_RXNORM.PULL_MEDICATION_ID 
            ORDER BY THEORDER DESC, FIRSTLINE
        ) = 1
    ) X
        ON X.CONCEPT_CODE = TOP_RXNORM.CONCEPT_CODE
        AND X.PULL_MEDICATION_ID = TOP_RXNORM.PULL_MEDICATION_ID

WHERE PULL_DRUG_EXPOSURE_AMB_RXNORM.DRUG_EXPOSURE_START_DATE IS NOT NULL;