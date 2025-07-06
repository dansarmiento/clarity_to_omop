--PAYER_PLAN_PERIOD (derived)
--https://ohdsi.github.io/CommonDataModel/cdm54.html#payer_plan_period
{{ config(materialized = 'table', schema = 'OMOP') }}

WITH MIN_AND_MAX_VISITS as (
    SELECT PERSON_ID        AS PERSON_ID
	, min(VISIT_START_DATE) AS PAYER_PLAN_PERIOD_START_DATE
	, max(VISIT_END_DATE)   AS PAYER_PLAN_PERIOD_END_DATE
    , 32817                 AS PERIOD_TYPE_CONCEPT_ID
    FROM
	    {{ref('VISIT_OCCURRENCE_RAW')}} AS VISIT_OCCURRENCE
    GROUP BY ALL)

SELECT
     {{ sequence_get_nextval() }}::NUMBER(28,0) AS PAYER_PLAN_PERIOD_ID
    , PERSON_ID::NUMBER(28,0)                   AS PERSON_ID
	, PAYER_PLAN_PERIOD_START_DATE::DATE        AS PAYER_PLAN_PERIOD_START_DATE
	, PAYER_PLAN_PERIOD_END_DATE::DATE          AS PAYER_PLAN_PERIOD_END_DATE
    , 32817::NUMBER(28,0)                       AS PERIOD_TYPE_CONCEPT_ID
    , 0::NUMBER(28,0)                           AS PAYER_CONCEPT_ID
    , NULL::VARCHAR(50)                         AS PAYER_SOURCE_VALUE
    , 0::NUMBER(28,0)                           AS PAYER_SOURCE_CONCEPT_ID
    , 0::NUMBER(28,0)                           AS PLAN_CONCEPT_ID
    , NULL::VARCHAR(50)                         AS PLAN_SOURCE_VALUE
    , 0 ::NUMBER(28,0)                          AS SPONSOR_CONCEPT_ID
    , NULL::VARCHAR(50)                         AS SPONSOR_SOURCE_VALUE
    , 0::NUMBER(28,0)                           AS SPONSOR_SOURCE_CONCEPT_ID
    , NULL::VARCHAR(50)                         AS FAMILY_SOURCE_VALUE
    , 0::NUMBER(28,0)                           AS STOP_REASON_CONCEPT_ID
    , NULL::VARCHAR(50)                         AS STOP_REASON_SOURCE_VALUE
    , 0::NUMBER(28,0)                           AS STOP_REASON_SOURCE_CONCEPT_ID

FROM MIN_AND_MAX_VISITS

