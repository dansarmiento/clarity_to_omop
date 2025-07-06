
{%- set source_relation = source('CLARITY', 'ZC_ED_DISPOSITION') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_ED_DISPOSITION_stg
--This table contains the category information for ed dispositions.
SELECT
	ED_DISPOSITION_C
	,UPPER("NAME") AS ZC_ED_DISPOSITION_NAME
FROM
	{{ source('CLARITY','ZC_ED_DISPOSITION')}} AS ZC_ED_DISPOSITION
--END ZC_ED_DISPOSITION_stg
--  