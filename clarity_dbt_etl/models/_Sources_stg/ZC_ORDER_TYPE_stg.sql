
{%- set source_relation = source('CLARITY', 'ZC_ORDER_TYPE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_ORDER_TYPE_stg
SELECT
	ORDER_TYPE_C
	, UPPER("NAME") AS  ZC_ORDER_TYPE_NAME
FROM
	{{source('CLARITY','ZC_ORDER_TYPE')}} AS  ZC_ORDER_TYPE
--END ZC_ORDER_TYPE_stg
--    