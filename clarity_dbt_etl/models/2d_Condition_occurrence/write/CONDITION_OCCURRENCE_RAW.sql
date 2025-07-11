--CONDITION_OCCURRENCE
{{ config(materialized = 'table', schema = 'OMOP') }}

SELECT DISTINCT
    {{ sequence_get_nextval() }}::NUMBER(28,0)    AS CONDITION_OCCURRENCE_ID
    , PERSON_ID::NUMBER(28,0)                     AS PERSON_ID
    , CONDITION_CONCEPT_ID::NUMBER(28,0)          AS CONDITION_CONCEPT_ID
    , CONDITION_START_DATE::DATE                  AS CONDITION_START_DATE
    , CONDITION_START_DATETIME::DATETIME          AS CONDITION_START_DATETIME
    , CONDITION_END_DATE::DATE                    AS CONDITION_END_DATE
    , CONDITION_END_DATETIME::DATETIME            AS CONDITION_END_DATETIME
    , CONDITION_TYPE_CONCEPT_ID::NUMBER(28,0)     AS CONDITION_TYPE_CONCEPT_ID
    , CONDITION_STATUS_CONCEPT_ID::NUMBER(28,0)   AS CONDITION_STATUS_CONCEPT_ID
    , STOP_REASON::VARCHAR(20)                    AS STOP_REASON
    , PROVIDER_ID::NUMBER(28,0)                   AS PROVIDER_ID
    , VISIT_OCCURRENCE_ID::NUMBER(28,0)           AS VISIT_OCCURRENCE_ID
    , VISIT_DETAIL_ID::NUMBER(28,0)               AS VISIT_DETAIL_ID
    , CONDITION_SOURCE_VALUE::VARCHAR(50)         AS CONDITION_SOURCE_VALUE --Human readable Source Value use src_VALUE_ID below to link
    , CONDITION_SOURCE_CONCEPT_ID::NUMBER(28,0)   AS CONDITION_SOURCE_CONCEPT_ID
    , CONDITION_STATUS_SOURCE_VALUE::VARCHAR(50)  AS CONDITION_STATUS_SOURCE_VALUE

 ------Non OMOP fields -----------
    , ETL_MODULE::VARCHAR                         AS etl_MODULE
    , STAGE_PAT_ID::VARCHAR                  	  AS phi_PAT_ID
    , STAGE_MRN_CPI::NUMBER(28,0)                 AS phi_MRN_CPI
    , STAGE_CSN_ID::NUMBER(28,0)			      AS phi_CSN_ID
----- Link to source
    , SRC_TABLE::VARCHAR                          AS src_TABLE
    , SRC_FIELD::VARCHAR                          AS src_FIELD
    , SRC_VALUE_ID::VARCHAR                       AS src_VALUE_ID
FROM
(
--Ambulatory
     SELECT PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE, CONDITION_START_DATETIME
     ,CONDITION_END_DATE, CONDITION_END_DATETIME, CONDITION_TYPE_CONCEPT_ID, CONDITION_STATUS_CONCEPT_ID
     ,STOP_REASON, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID, CONDITION_SOURCE_VALUE
     ,CONDITION_SOURCE_CONCEPT_ID, CONDITION_STATUS_SOURCE_VALUE
     ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
     ,'CLARITY_EDG' as SRC_TABLE, 'DX_ID' AS SRC_FIELD, STAGE_DX_ID::INTEGER AS SRC_VALUE_ID
FROM
     {{ref('STAGE_CONDITION_OCCURRENCE_AMB_SNO')}} AS STAGE_CONDITION_OCCURRENCE_AMB_SNO
UNION ALL
     SELECT PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE, CONDITION_START_DATETIME
     ,CONDITION_END_DATE, CONDITION_END_DATETIME, CONDITION_TYPE_CONCEPT_ID, CONDITION_STATUS_CONCEPT_ID
     ,STOP_REASON, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID, CONDITION_SOURCE_VALUE
     ,CONDITION_SOURCE_CONCEPT_ID, CONDITION_STATUS_SOURCE_VALUE
     ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
     ,'CLARITY_EDG' as SRC_TABLE, 'DX_ID' AS SRC_FIELD, STAGE_DX_ID::INTEGER AS SRC_VALUE_ID
FROM
     {{ref('STAGE_CONDITION_OCCURRENCE_AMB_TDL_SNO')}} AS STAGE_CONDITION_OCCURRENCE_AMB_TDL_SNO
UNION ALL
SELECT PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE, CONDITION_START_DATETIME
     ,CONDITION_END_DATE, CONDITION_END_DATETIME, CONDITION_TYPE_CONCEPT_ID, CONDITION_STATUS_CONCEPT_ID
     ,STOP_REASON, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID, CONDITION_SOURCE_VALUE
     ,CONDITION_SOURCE_CONCEPT_ID, CONDITION_STATUS_SOURCE_VALUE
     ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
     ,'CLARITY_EDG' as SRC_TABLE, 'DX_ID' AS SRC_FIELD, STAGE_DX_ID::INTEGER AS SRC_VALUE_ID
FROM
     {{ref('STAGE_CONDITION_OCCURRENCE_AMB_PROB_SNO')}} AS STAGE_CONDITION_OCCURRENCE_AMB_PROB_SNO

-- Hospital
UNION ALL
SELECT PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE, CONDITION_START_DATETIME
     ,CONDITION_END_DATE, CONDITION_END_DATETIME, CONDITION_TYPE_CONCEPT_ID, CONDITION_STATUS_CONCEPT_ID
     ,STOP_REASON, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID, CONDITION_SOURCE_VALUE
     ,CONDITION_SOURCE_CONCEPT_ID, CONDITION_STATUS_SOURCE_VALUE
     ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
     ,'CLARITY_EDG' as SRC_TABLE, 'DX_ID' AS SRC_FIELD, STAGE_DX_ID::INTEGER AS SRC_VALUE_ID
FROM
     {{ref('STAGE_CONDITION_OCCURRENCE_HSP_FIN_SNO')}} AS STAGE_CONDITION_OCCURRENCE_HSP_FIN_SNO
UNION ALL
SELECT PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE, CONDITION_START_DATETIME
     ,CONDITION_END_DATE, CONDITION_END_DATETIME, CONDITION_TYPE_CONCEPT_ID, CONDITION_STATUS_CONCEPT_ID
     ,STOP_REASON, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID, CONDITION_SOURCE_VALUE
     ,CONDITION_SOURCE_CONCEPT_ID, CONDITION_STATUS_SOURCE_VALUE
     ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
     ,'CLARITY_EDG' as SRC_TABLE, 'DX_ID' AS SRC_FIELD, STAGE_DX_ID::INTEGER AS SRC_VALUE_ID
FROM
     {{ref('STAGE_CONDITION_OCCURRENCE_HSP_ADM_SNO')}} AS STAGE_CONDITION_OCCURRENCE_HSP_ADM_SNO
UNION ALL
SELECT PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE, CONDITION_START_DATETIME
     ,CONDITION_END_DATE, CONDITION_END_DATETIME, CONDITION_TYPE_CONCEPT_ID, CONDITION_STATUS_CONCEPT_ID
     ,STOP_REASON, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID, CONDITION_SOURCE_VALUE
     ,CONDITION_SOURCE_CONCEPT_ID, CONDITION_STATUS_SOURCE_VALUE
     ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
     ,'CLARITY_EDG' as SRC_TABLE, 'DX_ID' AS SRC_FIELD, STAGE_DX_ID::INTEGER AS SRC_VALUE_ID
FROM
     {{ref('STAGE_CONDITION_OCCURRENCE_HSP_DISCH_SNO')}} AS STAGE_CONDITION_OCCURRENCE_HSP_DISCH_SNO
UNION ALL
SELECT PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE, CONDITION_START_DATETIME
     ,CONDITION_END_DATE, CONDITION_END_DATETIME, CONDITION_TYPE_CONCEPT_ID, CONDITION_STATUS_CONCEPT_ID
     ,STOP_REASON, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID, CONDITION_SOURCE_VALUE
     ,CONDITION_SOURCE_CONCEPT_ID, CONDITION_STATUS_SOURCE_VALUE
     ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
     ,'CLARITY_EDG' as SRC_TABLE, 'DX_ID' AS SRC_FIELD, STAGE_DX_ID::INTEGER AS SRC_VALUE_ID
FROM
     {{ref('STAGE_CONDITION_OCCURRENCE_HSP_PROB_SNO')}} AS STAGE_CONDITION_OCCURRENCE_HSP_PROB_SNO
UNION ALL
SELECT PERSON_ID, CONDITION_CONCEPT_ID, CONDITION_START_DATE, CONDITION_START_DATETIME
     ,CONDITION_END_DATE, CONDITION_END_DATETIME, CONDITION_TYPE_CONCEPT_ID, CONDITION_STATUS_CONCEPT_ID
     ,STOP_REASON, PROVIDER_ID, VISIT_OCCURRENCE_ID, VISIT_DETAIL_ID, CONDITION_SOURCE_VALUE
     ,CONDITION_SOURCE_CONCEPT_ID, CONDITION_STATUS_SOURCE_VALUE
     ,ETL_MODULE, STAGE_PAT_ID, STAGE_MRN_CPI, STAGE_CSN_ID
     ,'CLARITY_EDG' as SRC_TABLE, 'DX_ID' AS SRC_FIELD, STAGE_DX_ID::INTEGER AS SRC_VALUE_ID
FROM
     {{ref('STAGE_CONDITION_OCCURRENCE_HSP_TDL_SNO')}} AS STAGE_CONDITION_OCCURRENCE_HSP_TDL_SNO
) T

