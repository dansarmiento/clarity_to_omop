
{%- set source_relation = source('CLARITY', 'ZC_ETHNIC_GROUP') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_ETHNIC_GROUP_stg
--This table contains the category information for ethnic groups.
SELECT
	ETHNIC_GROUP_C
	,UPPER("NAME") AS ZC_ETHNIC_GROUP_NAME
FROM
	{{ source('CLARITY','ZC_ETHNIC_GROUP')}} AS ZC_ETHNIC_GROUP
--END ZC_ETHNIC_GROUP_stg
--      