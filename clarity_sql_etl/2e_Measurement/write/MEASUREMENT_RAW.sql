--MEASUREMENT_RAW
/*
Description: This query creates the MEASUREMENT_RAW table by combining measurement data from multiple sources
             including hospital flowsheets, ambulatory flowsheets, and anesthesia flowsheets.
Author: Unknown
Last Modified: Unknown
*/

SELECT
    CARE_RES_OMOP_DEV2_WKSP.OMOP.MEASUREMENT_RAW_SEQ.nextval::NUMBER(28,0)      AS MEASUREMENT_ID
    , PERSON_ID::NUMBER(28,0)                       AS PERSON_ID
    , MEASUREMENT_CONCEPT_ID::NUMBER(28,0)          AS MEASUREMENT_CONCEPT_ID
    , MEASUREMENT_DATE::DATE                        AS MEASUREMENT_DATE
    , MEASUREMENT_DATETIME::DATETIME                AS MEASUREMENT_DATETIME
    , NULL::VARCHAR                                 AS MEASUREMENT_TIME
    , MEASUREMENT_TYPE_CONCEPT_ID::NUMBER(28,0)     AS MEASUREMENT_TYPE_CONCEPT_ID
    , OPERATOR_CONCEPT_ID::NUMBER(28,0)             AS OPERATOR_CONCEPT_ID
    , VALUE_AS_NUMBER::FLOAT                        AS VALUE_AS_NUMBER
    , VALUE_AS_CONCEPT_ID::NUMBER(28,0)             AS VALUE_AS_CONCEPT_ID
    , UNIT_CONCEPT_ID::NUMBER(28,0)                 AS UNIT_CONCEPT_ID
    , RANGE_LOW::FLOAT                              AS RANGE_LOW
    , RANGE_HIGH::FLOAT                             AS RANGE_HIGH
    , PROVIDER_ID::NUMBER(28,0)                     AS PROVIDER_ID
    , VISIT_OCCURRENCE_ID::NUMBER(28,0)             AS VISIT_OCCURRENCE_ID
    , VISIT_DETAIL_ID::NUMBER(28,0)                 AS VISIT_DETAIL_ID
    , MEASUREMENT_SOURCE_VALUE::VARCHAR             AS MEASUREMENT_SOURCE_VALUE --Human readable Source Value use src_VALUE_ID below to link
    , MEASUREMENT_SOURCE_CONCEPT_ID::NUMBER(28,0)   AS MEASUREMENT_SOURCE_CONCEPT_ID
    , UNIT_SOURCE_VALUE::VARCHAR                    AS UNIT_SOURCE_VALUE
    , UNIT_SOURCE_CONCEPT_ID::NUMBER(28,0)          AS UNIT_SOURCE_CONCEPT_ID
    , VALUE_SOURCE_VALUE::VARCHAR                   AS VALUE_SOURCE_VALUE
    , MEASUREMENT_EVENT_ID::VARCHAR                 AS MEASUREMENT_EVENT_ID
    , MEAS_EVENT_FIELD_CONCEPT_ID::NUMBER(28,0)     AS MEAS_EVENT_FIELD_CONCEPT_ID

 ------Non OMOP fields -----------
    , ETL_MODULE::VARCHAR                           AS ETL_MODULE
    , STAGE_PAT_ID::VARCHAR                  	    AS phi_PAT_ID
    , STAGE_MRN_CPI::NUMBER(28,0)                   AS phi_MRN_CPI
    , STAGE_CSN_ID::NUMBER(28,0)			        AS phi_CSN_ID
----- Link to source
    , SRC_TABLE::VARCHAR                            AS src_TABLE
    , SRC_FIELD::VARCHAR                            AS src_FIELD
    , SRC_VALUE_ID::VARCHAR                         AS src_VALUE_ID
FROM
(   -- Hospital (HSP) Flowsheet Data
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_HOSP_FLOWSHEET_BMI
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_HOSP_FLOWSHEET_BPD
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_HOSP_FLOWSHEET_BPS
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_HOSP_FLOWSHEET_MISC
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_HOSP_FLOWSHEET_TEMPERATURE
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_HOSP_FLOWSHEET_VITALS
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'LNC_DB_MAIN' as SRC_TABLE, 'RECORD_ID' AS SRC_FIELD, STAGE_RECORD_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_HOSP_LOINC

    -- Ambulatory (AMB) Flowsheet Data
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
     FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_AMB_FLOWSHEET_BMI
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_AMB_FLOWSHEET_BPD
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_AMB_FLOWSHEET_BPS
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_AMB_FLOWSHEET_MISC
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_AMB_FLOWSHEET_TEMPERATURE
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_AMB_FLOWSHEET_VITALS
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI,STAGE_CSN_ID
        ,'LNC_DB_MAIN' as SRC_TABLE, 'RECORD_ID' AS SRC_FIELD, STAGE_RECORD_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_AMB_LOINC


    -- Anesthesia (ANES) Flowsheet Data
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_ANES_FLOWSHEET_BPD
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_ANES_FLOWSHEET_BPM
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_ANES_FLOWSHEET_BPS
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_ANES_FLOWSHEET_MISC
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_ANES_FLOWSHEET_TEMPERATURE
    UNION ALL
    SELECT PERSON_ID, MEASUREMENT_CONCEPT_ID, MEASUREMENT_DATE, MEASUREMENT_DATETIME
        , MEASUREMENT_TYPE_CONCEPT_ID, OPERATOR_CONCEPT_ID, try_to_double(VALUE_AS_NUMBER) AS VALUE_AS_NUMBER, VALUE_AS_CONCEPT_ID
        , UNIT_CONCEPT_ID, RANGE_LOW, RANGE_HIGH, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID
        , MEASUREMENT_SOURCE_VALUE, MEASUREMENT_SOURCE_CONCEPT_ID, UNIT_SOURCE_VALUE, UNIT_SOURCE_CONCEPT_ID
        , VALUE_SOURCE_VALUE, MEASUREMENT_EVENT_ID, MEAS_EVENT_FIELD_CONCEPT_ID
        , ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
        ,'IP_FLO_GP_DATA' as SRC_TABLE, 'FLO_MEAS_ID' AS SRC_FIELD, STAGE_FLO_MEAS_ID::INTEGER AS SRC_VALUE_ID
    FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_STAGE.STAGE_MEASUREMENT_ANES_FLOWSHEET_VITALS

) AS T