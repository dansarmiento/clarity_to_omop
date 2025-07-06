--ZC_NDC_UNITS_stg
{%- set source_relation = source('CLARITY', 'ZC_NDC_UNITS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_NDC_UNITS_stg
SELECT
	NDC_UNITS_C
	, UPPER("NAME") AS  ZC_NDC_UNITS_NAME
FROM
	{{source('CLARITY','ZC_NDC_UNITS')}} AS ZC_NDC_UNITS
--END ZC_NDC_UNITS_stg     