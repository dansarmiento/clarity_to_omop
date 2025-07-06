
{%- set source_relation = source('CLARITY', 'ZC_SPEC_SOURCE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_SPEC_SOURCE_stg
--This table contains the category information for specimen sources.
SELECT
	SPEC_SOURCE_C
	, UPPER("NAME") AS  ZC_SPEC_SOURCE_NAME
FROM
	{{ source('CLARITY','ZC_SPEC_SOURCE')}} AS  ZC_SPEC_SOURCE
--END 
--