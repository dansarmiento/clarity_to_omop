
{%- set source_relation = source('CLARITY', 'ZC_ORDER_STATUS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_ORDER_STATUS_stg
--
SELECT
	ORDER_STATUS_C
	, UPPER("NAME") AS  ZC_ORDER_STATUS_NAME
FROM
	{{source('CLARITY','ZC_ORDER_STATUS')}} AS  ZC_ORDER_STATUS
--END ZC_ORDER_STATUS_stg
--     