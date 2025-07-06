
{%- set source_relation = source('CLARITY', 'ZC_PHARM_CLASS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_PHARM_CLASS_stg
SELECT
	PHARM_CLASS_C
	, UPPER("NAME") AS  ZC_PHARM_CLASS_NAME
FROM
	{{source('CLARITY','ZC_PHARM_CLASS')}} AS  ZC_PHARM_CLASS
--END ZC_PHARM_CLASS_stg  