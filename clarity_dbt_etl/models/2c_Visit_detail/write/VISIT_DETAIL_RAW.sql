--VISIT_DETAIL_RAW
{{ config(materialized = 'table', schema = 'OMOP') }}

SELECT DISTINCT
     {{ sequence_get_nextval() }}::NUMBER(28,0)     AS VISIT_DETAIL_ID
    , PERSON_ID::NUMBER(28,0)                       AS PERSON_ID
    , VISIT_DETAIL_CONCEPT_ID::NUMBER(28,0)         AS VISIT_DETAIL_CONCEPT_ID
    , VISIT_DETAIL_START_DATE::DATE                 AS VISIT_DETAIL_START_DATE
    , VISIT_DETAIL_START_DATETIME::DATETIME         AS VISIT_DETAIL_START_DATETIME
    , VISIT_DETAIL_END_DATE::DATE                   AS VISIT_DETAIL_END_DATE
    , VISIT_DETAIL_END_DATETIME::DATETIME           AS VISIT_DETAIL_END_DATETIME
    , VISIT_DETAIL_TYPE_CONCEPT_ID::NUMBER(28,0)    AS VISIT_DETAIL_TYPE_CONCEPT_ID
    , PROVIDER_ID::NUMBER(28,0)                     AS PROVIDER_ID
    , CARE_SITE_ID::NUMBER(28,0)                    AS CARE_SITE_ID
    , VISIT_DETAIL_SOURCE_VALUE::VARCHAR(250)       AS VISIT_DETAIL_SOURCE_VALUE
    , VISIT_DETAIL_SOURCE_CONCEPT_ID::NUMBER(28,0)  AS VISIT_DETAIL_SOURCE_CONCEPT_ID
    , ADMITTED_FROM_SOURCE_VALUE::VARCHAR(50)       AS ADMITTED_FROM_SOURCE_VALUE
    , ADMITTED_FROM_CONCEPT_ID::NUMBER(28,0)        AS ADMITTED_FROM_CONCEPT_ID
    , DISCHARGED_TO_SOURCE_VALUE::VARCHAR(50)       AS DISCHARGED_TO_SOURCE_VALUE
    , DISCHARGED_TO_CONCEPT_ID::NUMBER(28,0)        AS DISCHARGED_TO_CONCEPT_ID
    , PRECEDING_VISIT_DETAIL_ID::NUMBER(28,0)       AS PRECEDING_VISIT_DETAIL_ID
    , PARENT_VISIT_DETAIL_ID::NUMBER(28,0)          AS PARENT_VISIT_DETAIL_ID
    , VISIT_OCCURRENCE_ID::NUMBER(28,0)             AS VISIT_OCCURRENCE_ID
 ------Non OMOP fields -----------
    , ETL_MODULE::VARCHAR                           AS ETL_MODULE
    , STAGE_PAT_ID::VARCHAR                  	    AS phi_PAT_ID
    , STAGE_MRN_CPI::NUMBER(28,0)                   AS phi_MRN_CPI
    , STAGE_CSN_ID::NUMBER(28,0)			        AS phi_CSN_ID

FROM
     {{ref('STAGE_VISIT_DETAIL_ALL')}} AS STAGE_VISIT_DETAIL_ALL

