
{%- set source_relation = source('CLARITY', 'ZC_PAT_STATUS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_PAT_STATUS_stg
SELECT
	ADT_PATIENT_STAT_C
	, UPPER("NAME") AS  ZC_PAT_STATUS_NAME
FROM
	{{source('CLARITY','ZC_PAT_STATUS')}} AS  ZC_PAT_STATUS
--END ZC_PAT_STATUS_stg
--     