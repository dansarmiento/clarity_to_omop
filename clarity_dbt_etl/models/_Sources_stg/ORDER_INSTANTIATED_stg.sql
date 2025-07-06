{%- set source_relation = source('CLARITY', 'ORDER_INSTANTIATED') -%}

{{ config(materialized = 'ephemeral') }}
--BEGIN ORDER_INSTANTIATED_stg
-- This table contains a list of orders that have been instantiated.
SELECT
	ORDER_ID
	,LINE
FROM
	{{source('CLARITY','ORDER_INSTANTIATED')}} AS  ORDER_INSTANTIATED
--END ORDER_INSTANTIATED_stg
--   