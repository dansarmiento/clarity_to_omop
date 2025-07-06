
{%- set source_relation = source('CLARITY', 'ZC_NOTE_TYPE_IP') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_NOTE_TYPE_IP_stg
SELECT
	TYPE_IP_C
	, UPPER("NAME") AS  ZC_NOTE_TYPE_IP_NAME
FROM
	{{source('CLARITY','ZC_NOTE_TYPE_IP')}} AS  ZC_NOTE_TYPE_IP
--END ZC_NOTE_TYPE_IP_stg      