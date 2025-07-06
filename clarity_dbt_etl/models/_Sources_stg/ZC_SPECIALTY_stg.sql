
--
{%- set source_relation = source('CLARITY', 'ZC_SPECIALTY') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_SPECIALTY_stg
SELECT
	SPECIALTY_C
	, UPPER("NAME") AS  ZC_SPECIALTY_NAME
FROM
	{{source('CLARITY','ZC_SPECIALTY')}} AS  ZC_SPECIALTY
--END ZC_SPECIALTY_stg
--  