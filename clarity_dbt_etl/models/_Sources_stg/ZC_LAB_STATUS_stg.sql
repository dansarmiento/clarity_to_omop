
{%- set source_relation = source('CLARITY', 'ZC_LAB_STATUS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_LAB_STATUS_stg
SELECT
	LAB_STATUS_C
	,UPPER("NAME") AS ZC_LAB_STATUS_NAME
FROM
	{{ source('CLARITY','ZC_LAB_STATUS')}} AS ZC_LAB_STATUS
--END ZC_LAB_STATUS_stg
--