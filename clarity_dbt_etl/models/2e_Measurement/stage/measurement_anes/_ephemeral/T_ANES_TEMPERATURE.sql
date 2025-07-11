{{ config(materialized='ephemeral') }}
--BEGIN cte__T_ANES_TEMPERATURE
    SELECT DISTINCT PERSON_ID
           ,PULL_CSN_ID
            ,MEASUREMENT_DATE
            ,MEASUREMENT_DATETIME            
            ,VALUE_SOURCE_VALUE
            ,VALUE_AS_NUMBER
            ,RANGE_LOW
            ,RANGE_HIGH
            ,PULL_FLO_MEAS_ID
            ,PULL_FLO_MEAS_NAME
            ,PROVIDER_SOURCE_VALUE
            ,UNIT_SOURCE_VALUE
        FROM {{ref('PULL_MEASUREMENT_ANES_FLOWSHEET')}} AS PULL_MEASUREMENT_ANES_FLOWSHEET
        INNER JOIN {{ ref('SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_TEMP')}} AS SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS
            ON PULL_FLO_MEAS_ID::VARCHAR = SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS.SOURCE_CODE
--END cte__T_ANES_TEMPERATURE
--
