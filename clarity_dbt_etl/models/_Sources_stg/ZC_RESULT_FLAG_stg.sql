
{%- set source_relation = source('CLARITY', 'ZC_RESULT_FLAG') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_RESULT_FLAG_stg
SELECT
	RESULT_FLAG_C
	, UPPER("NAME") AS  ZC_RESULT_FLAG_NAME
FROM
	{{source('CLARITY','ZC_RESULT_FLAG')}} AS  ZC_RESULT_FLAG
--END ZC_RESULT_FLAG_stg      