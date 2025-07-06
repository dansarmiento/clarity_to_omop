
{%- set source_relation = source('CLARITY', 'PATIENT_RACE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN PATIENT_RACE_stg
SELECT
	PAT_ID
	,LINE
    ,PATIENT_RACE_C
FROM
	{{source('CLARITY','PATIENT_RACE')}} AS  PATIENT_RACE
--BEGIN PATIENT_RACE_stg     