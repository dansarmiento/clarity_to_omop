
{%- set source_relation = source('CLARITY', 'ZC_PACK_DESC') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_PACK_DESC_stg
SELECT
	PACK_DESC_C
	, UPPER("NAME") AS  ZC_PACK_DESC_NAME
FROM
	{{source('CLARITY','ZC_PACK_DESC')}} AS  ZC_PACK_DESC
--BEGIN ZC_PACK_DESC_stg    