/*
Purpose: Transform and map hospital flowsheet temperature measurements to OMOP CDM format
Source Tables: 
- CARE_RES_OMOP_GEN_WKSP.OMOP.SOURCE_TO_CONCEPT_MAP
- CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_HOSP_TEMPERATURE_MERGE
- CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW
- CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW
*/

-- CTE for temperature measurement source-to-concept mapping
WITH __dbt__cte__SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_TEMP AS (
    SELECT *
    FROM CARE_RES_OMOP_GEN_WKSP.OMOP.SOURCE_TO_CONCEPT_MAP
    WHERE SOURCE_VOCABULARY_ID = 'SH_FLWSHT_MEAS_TEMP'
),

-- CTE for measurement units source-to-concept mapping
__dbt__cte__SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_UNITS AS (
    SELECT *
    FROM CARE_RES_OMOP_GEN_WKSP.OMOP.SOURCE_TO_CONCEPT_MAP
    WHERE SOURCE_VOCABULARY_ID = 'SH_FLOWSHT_MEAS_UNIT'
)

-- Main query to transform temperature measurements
SELECT DISTINCT
    -- OMOP Standard Fields
    T_TEMPERATURE_MERGE.PERSON_ID                                           AS PERSON_ID,
    T_TEMPERATURE_MERGE.TARGET_CONCEPT_ID                                   AS MEASUREMENT_CONCEPT_ID,
    T_TEMPERATURE_MERGE.MEASUREMENT_DATE                                    AS MEASUREMENT_DATE,
    T_TEMPERATURE_MERGE.MEASUREMENT_DATETIME                                AS MEASUREMENT_DATETIME,
    32817                                                                   AS MEASUREMENT_TYPE_CONCEPT_ID, --EHR
    4172703                                                                 AS OPERATOR_CONCEPT_ID,
    VALUE_AS_NUMBER                                                         AS VALUE_AS_NUMBER,
    NULL                                                                    AS VALUE_AS_CONCEPT_ID,
    COALESCE(
        SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_UNITS.TARGET_CONCEPT_ID,
        9289                                                                --degF
    )                                                                       AS UNIT_CONCEPT_ID,
    RANGE_LOW                                                               AS RANGE_LOW,
    RANGE_HIGH                                                              AS RANGE_HIGH,
    PROVIDER.PROVIDER_ID                                                    AS PROVIDER_ID,
    VISIT_OCCURRENCE.VISIT_OCCURRENCE_ID                                    AS VISIT_OCCURRENCE_ID,
    NULL                                                                    AS VISIT_DETAIL_ID,
    PULL_FLO_MEAS_ID::VARCHAR || ':' || PULL_FLO_MEAS_NAME                AS MEASUREMENT_SOURCE_VALUE,
    NULL                                                                    AS MEASUREMENT_SOURCE_CONCEPT_ID,
    COALESCE(
        SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_UNITS.SOURCE_CODE_DESCRIPTION,
        'degF'
    )                                                                       AS UNIT_SOURCE_VALUE,
    VALUE_SOURCE_VALUE                                                      AS VALUE_SOURCE_VALUE,
    NULL                                                                    AS UNIT_SOURCE_CONCEPT_ID,
    NULL                                                                    AS MEASUREMENT_EVENT_ID,
    NULL                                                                    AS MEAS_EVENT_FIELD_CONCEPT_ID,

    -- Non-OMOP Fields
    'MEASUREMENT_HOSP_FLOWSHEET_TEMPERATURE'                                AS ETL_MODULE,
    VISIT_OCCURRENCE.phi_PAT_ID                                            AS STAGE_PAT_ID,
    VISIT_OCCURRENCE.phi_MRN_CPI                                           AS STAGE_MRN_CPI,
    VISIT_OCCURRENCE.phi_CSN_ID                                            AS STAGE_CSN_ID,
    PULL_FLO_MEAS_ID                                                       AS STAGE_FLO_MEAS_ID,
    PULL_FLO_MEAS_NAME                                                     AS STAGE_FLO_MEAS_NAME

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_HOSP_TEMPERATURE_MERGE AS T_TEMPERATURE_MERGE

    LEFT JOIN __dbt__cte__SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_TEMP AS SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS
        ON T_TEMPERATURE_MERGE.PULL_FLO_MEAS_ID = SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS.SOURCE_CODE

    LEFT JOIN __dbt__cte__SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_UNITS AS SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_UNITS
        ON T_TEMPERATURE_MERGE.UNIT_SOURCE_VALUE = SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_UNITS.SOURCE_CODE

    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.VISIT_OCCURRENCE_RAW AS VISIT_OCCURRENCE
        ON T_TEMPERATURE_MERGE.PULL_CSN_ID = VISIT_OCCURRENCE.phi_CSN_ID

    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PROVIDER_RAW AS PROVIDER
        ON T_TEMPERATURE_MERGE.PROVIDER_SOURCE_VALUE = PROVIDER.PROVIDER_SOURCE_VALUE;