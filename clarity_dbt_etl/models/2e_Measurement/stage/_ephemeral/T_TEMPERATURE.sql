{{ config(materialized='ephemeral') }}
--BEGIN cte__T_TEMPERATURE
    SELECT DISTINCT PERSON_ID
        ,PAT_ENC_CSN_ID
        ,RECORDED_TIME
        ,MEAS_VALUE AS MEAS_VALUE
        ,MINVALUE
        ,MAX_VAL
        ,FLO_MEAS_NAME
        ,FLO_MEAS_ID
        ,FSD_ID
        ,CALC_ATTEND_PROV_ID
        ,UNITS

    FROM {{ref('PULL_MEASUREMENT_HOSP_FLOWSHEET')}} AS PULL_MEASUREMENT_HOSP_FLOWSHEET
    --6 TEMPERATURE
    INNER JOIN {{ ref('SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_TEMP')}} AS SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS
        ON FLO_MEAS_ID = SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS.SOURCE_CODE
--END cte__T_TEMPERATURE
--
