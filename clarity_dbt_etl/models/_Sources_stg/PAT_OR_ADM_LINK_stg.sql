{%- set source_relation = source('CLARITY', 'PAT_OR_ADM_LINK') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN PAT_OR_ADM_LINK_stg
SELECT
	PAT_ENC_CSN_ID
	,OR_LINK_CSN 
    ,LOG_ID
FROM
	{{source('CLARITY','PAT_OR_ADM_LINK')}} AS  PAT_OR_ADM_LINK
--END PAT_OR_ADM_LINK_stg
--   