
{%- set source_relation = source('CLARITY', 'ZC_RSN_FOR_DISCON') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_RSN_FOR_DISCON_stg
SELECT
	RSN_FOR_DISCON_C
	,UPPER("NAME") AS  ZC_RSN_FOR_DISCON_NAME
FROM
	{{source('CLARITY','ZC_RSN_FOR_DISCON')}} AS  ZC_RSN_FOR_DISCON
--END ZC_RSN_FOR_DISCON_stg

   