{{ config(materialized='ephemeral') }}
--BEGIN cte__T_HOSP_TEMP_SOURCE
    SELECT DISTINCT
        PERSON_ID
        ,PULL_CSN_ID
        ,MEASUREMENT_DATETIME
        ,VALUE_SOURCE_VALUE

    FROM {{ref('PULL_MEASUREMENT_HOSP_FLOWSHEET')}} AS PULL_MEASUREMENT_HOSP_FLOWSHEET
    --7-TEMP SOURCE
    WHERE PULL_FLO_MEAS_ID IN ('7')
--END cte__T_HOSP_TEMP_SOURCE
--
