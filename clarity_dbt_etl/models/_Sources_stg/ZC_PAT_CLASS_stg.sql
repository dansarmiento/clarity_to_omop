
{%- set source_relation = source('CLARITY', 'ZC_PAT_CLASS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_PAT_CLASS_stg
SELECT
	UPPER(ADT_PAT_CLASS_C)  AS  ADT_PAT_CLASS_C
	, UPPER("NAME")         AS  ZC_PAT_CLASS_NAME
FROM
	{{source('CLARITY','ZC_PAT_CLASS')}} AS  ZC_PAT_CLASS
--END HSP_ACCOUNT_stg
--