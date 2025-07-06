
{%- set source_relation = source('CLARITY', 'ZC_OR_STATUS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_OR_STATUS_stg
SELECT DISTINCT
	STATUS_C
	, UPPER("NAME") AS  ZC_OR_STATUS_NAME
FROM
	{{source('CLARITY','ZC_OR_STATUS')}} AS  ZC_OR_STATUS
--END ZC_OR_STATUS_stg
--
