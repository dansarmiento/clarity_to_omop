
{%- set source_relation = source('CLARITY', 'ZC_PHARM_SUBCLASS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_PHARM_SUBCLASS_stg
SELECT
	PHARM_SUBCLASS_C
	, UPPER("NAME") AS  ZC_PHARM_SUBCLASS_NAME
FROM
	{{source('CLARITY','ZC_PHARM_SUBCLASS')}} AS  ZC_PHARM_SUBCLASS
--END ZC_PHARM_SUBCLASS_stg    