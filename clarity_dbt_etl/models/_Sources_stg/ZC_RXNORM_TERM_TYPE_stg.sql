
{%- set source_relation = source('CLARITY', 'ZC_RXNORM_TERM_TYPE') -%}

{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_RXNORM_TERM_TYPE_stg
SELECT
	RXNORM_TERM_TYPE_C
	,UPPER("NAME") AS  ZC_RXNORM_TERM_TYPE_NAME
FROM
	{{source('CLARITY','ZC_RXNORM_TERM_TYPE')}} AS  ZC_RXNORM_TERM_TYPE
--END ZC_RXNORM_TERM_TYPE_stg