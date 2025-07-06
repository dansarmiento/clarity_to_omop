
{%- set source_relation = source('CLARITY', 'ZC_ADM_SOURCE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_ADM_SOURCE_stg
SELECT DISTINCT
	ADMIT_SOURCE_C
	, UPPER("NAME") AS ZC_ADM_SOURCE_NAME
FROM
	{{ source('CLARITY','ZC_ADM_SOURCE')}} AS ZC_ADM_SOURCE
--END ZC_ADM_SOURCE_stg
--
