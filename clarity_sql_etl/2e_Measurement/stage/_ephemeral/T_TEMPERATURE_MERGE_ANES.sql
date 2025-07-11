
with __dbt__cte__SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_TEMP_SRC as (

--BEGIN cte__SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_TEMP_SRC
    SELECT *
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_CLARITY.SOURCE_TO_CONCEPT_MAP_stg
    WHERE SOURCE_VOCABULARY_ID = 'SH_TEMPERATURE_SOURC'
--END cte__SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_TEMP_SRC
--
) --BEGIN cte__T_TEMPERATURE_MERGE_ANES
    SELECT T_TEMPERATURE.PERSON_ID
        ,T_TEMPERATURE.PAT_ENC_CSN_ID
        ,SOURCE_TO_CONCEPT_MAP_FLOWSHEET_TEMP_SRC.TARGET_CONCEPT_ID AS TARGET_CONCEPT_ID --TEMPERATURE SOURCE
        ,T_TEMPERATURE.RECORDED_TIME
        ,T_TEMPERATURE.MEAS_VALUE AS MEAS_VALUE
        ,T_TEMPERATURE.MINVALUE
        ,T_TEMPERATURE.MAX_VAL
        ,T_TEMPERATURE.FLO_MEAS_NAME
        ,SOURCE_TO_CONCEPT_MAP_FLOWSHEET_TEMP_SRC.SOURCE_CODE_DESCRIPTION
        ,T_TEMPERATURE.FLO_MEAS_ID
        ,T_TEMPERATURE.FSD_ID
        ,T_TEMPERATURE.VISIT_PROV_ID
        ,T_TEMPERATURE.UNITS

    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_TEMPERATURE_ANES AS T_TEMPERATURE
    LEFT JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.T_TEMP_SOURCE_ANES AS T_TEMP_SOURCE
        ON T_TEMPERATURE.PAT_ENC_CSN_ID = T_TEMP_SOURCE.PAT_ENC_CSN_ID
            AND T_TEMPERATURE.RECORDED_TIME = T_TEMP_SOURCE.RECORDED_TIME
    LEFT JOIN __dbt__cte__SOURCE_TO_CONCEPT_MAP_FLOWSHEET_MEAS_TEMP_SRC AS SOURCE_TO_CONCEPT_MAP_FLOWSHEET_TEMP_SRC
        ON COALESCE(T_TEMP_SOURCE.MEAS_VALUE,'99999') = SOURCE_TO_CONCEPT_MAP_FLOWSHEET_TEMP_SRC.SOURCE_CODE
--END cte__T_TEMPERATURE_MERGE_ANES
--