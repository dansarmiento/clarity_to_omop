
{%- set source_relation = source('CLARITY', 'ZC_PAT_SERVICE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_PAT_SERVICE_stg
SELECT
	UPPER(HOSP_SERV_C) AS HOSP_SERV_C
	, UPPER("NAME") AS  ZC_PAT_SERVICE_NAME
FROM
	{{source('CLARITY','ZC_PAT_SERVICE')}} AS  ZC_PAT_SERVICE
--END ZC_PAT_SERVICE_stg
--  