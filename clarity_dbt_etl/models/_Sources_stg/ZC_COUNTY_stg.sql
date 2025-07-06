
{%- set source_relation = source('CLARITY', 'ZC_COUNTY') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_COUNTY_stg
--This table contains the category information for counties.
SELECT
	COUNTY_C
	,UPPER("NAME") AS ZC_COUNTY_NAME
FROM
	{{ source('CLARITY','ZC_COUNTY')}} AS ZC_COUNTY
--END ZC_COUNTY_stg
--   