
{%- set source_relation = source('CLARITY', 'ZC_ORDER_CLASS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_ORDER_CLASS_stg
SELECT
	ORDER_CLASS_C
	, UPPER("NAME") AS ZC_ORDER_CLASS_NAME
FROM
	{{source('CLARITY','ZC_ORDER_CLASS')}} AS  ZC_ORDER_CLASS
--END ZC_ORDER_CLASS_stg
--       