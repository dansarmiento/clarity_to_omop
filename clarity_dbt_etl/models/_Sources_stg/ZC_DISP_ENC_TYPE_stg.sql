
{%- set source_relation = source('CLARITY', 'ZC_DISP_ENC_TYPE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_DISP_ENC_TYPE_stg
--This table contains the category information for encounter types.
SELECT
	DISP_ENC_TYPE_C
	,UPPER("NAME") AS ZC_DISP_ENC_TYPE_NAME
FROM
	{{ source('CLARITY','ZC_DISP_ENC_TYPE')}} AS ZC_DISP_ENC_TYPE
--END ZC_DISP_ENC_TYPE_stg
--