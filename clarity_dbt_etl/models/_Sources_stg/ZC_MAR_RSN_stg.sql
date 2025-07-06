
{%- set source_relation = source('CLARITY', 'ZC_MAR_RSN') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_MAR_RSN_stg
SELECT
	REASON_C
	, UPPER("NAME") AS  ZC_MAR_RSN_NAME
FROM
	{{ source('CLARITY','ZC_MAR_RSN')}} AS  ZC_MAR_RSN
--END ZC_MAR_RSN_stg
--