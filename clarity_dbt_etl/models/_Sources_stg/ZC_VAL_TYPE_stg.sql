

{%- set source_relation = source('CLARITY', 'ZC_VAL_TYPE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_VAL_TYPE_stg
--This table contains the category item for the flowsheet row value type.
SELECT
	VAL_TYPE_C
	, UPPER("NAME") AS ZC_VAL_TYPE_NAME
FROM
	{{ source('CLARITY','ZC_VAL_TYPE')}} AS ZC_VAL_TYPE
--BEGIN ZC_VAL_TYPE_stg
--   