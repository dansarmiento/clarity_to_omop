

{%- set source_relation = source('CLARITY', 'ZC_SYSTEM_FLAG') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_SYSTEM_FLAG_stg
SELECT
	SYSTEM_FLAG_C
	, UPPER("NAME") AS ZC_SYSTEM_FLAG_NAME
FROM
	{{ source('CLARITY','ZC_SYSTEM_FLAG')}} AS ZC_SYSTEM_FLAG
--END ZC_SYSTEM_FLAG_stg     