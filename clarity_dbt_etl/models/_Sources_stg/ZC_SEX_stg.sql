
{%- set source_relation = source('CLARITY', 'ZC_SEX') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_SEX_stg
--This table stores possible options for sex.
SELECT
	RCPT_MEM_SEX_C
	, UPPER("NAME") AS  ZC_SEX_NAME
FROM
	{{source('CLARITY','ZC_SEX')}} AS  ZC_SEX
--END ZC_SEX_stg
--      
