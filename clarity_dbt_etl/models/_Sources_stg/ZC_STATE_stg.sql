
{%- set source_relation = source('CLARITY', 'ZC_STATE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_STATE_stg
--This table contains the categories for state/province.
SELECT
	STATE_C
	, UPPER("NAME") AS ZC_STATE_NAME
    , UPPER("ABBR") AS ZC_STATE_ABBR
FROM
	{{ source('CLARITY','ZC_STATE')}} AS ZC_STATE
--END ZC_STATE_stg
--      