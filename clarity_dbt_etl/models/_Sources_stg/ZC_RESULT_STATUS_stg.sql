
{%- set source_relation = source('CLARITY', 'ZC_RESULT_STATUS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_RESULT_STATUS_stg
SELECT
	RESULT_STATUS_C
	, UPPER("NAME") AS  ZC_RESULT_STATUS_NAME
FROM
	{{source('CLARITY', 'ZC_RESULT_STATUS')}} AS  ZC_RESULT_STATUS
--END ZC_RESULT_STATUS_stg