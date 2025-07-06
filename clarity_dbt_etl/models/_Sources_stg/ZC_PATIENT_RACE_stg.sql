
--
{%- set source_relation = source('CLARITY', 'ZC_PATIENT_RACE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_PATIENT_RACE_stg
SELECT
	PATIENT_RACE_C
	, UPPER("NAME") AS  ZC_PATIENT_RACE_NAME
FROM
	{{source('CLARITY','ZC_PATIENT_RACE')}} AS  ZC_PATIENT_RACE
--END ZC_PATIENT_RACE_stg
--