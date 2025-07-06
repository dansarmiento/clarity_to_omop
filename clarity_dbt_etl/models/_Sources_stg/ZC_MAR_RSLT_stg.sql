
{%- set source_relation = source('CLARITY', 'ZC_MAR_RSLT') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_MAR_RSLT_stg
SELECT
	RESULT_C
	, UPPER("NAME") AS  ZC_MAR_RSLT_NAME
FROM
	{{ source('CLARITY','ZC_MAR_RSLT')}} AS  ZC_MAR_RSLT
--END ZC_MAR_RSLT_stg 
--  