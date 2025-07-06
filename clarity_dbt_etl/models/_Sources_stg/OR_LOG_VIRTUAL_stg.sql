{%- set source_relation = source('CLARITY', 'OR_LOG_VIRTUAL') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN OR_LOG_VIRTUAL_stg
-- The OR_LOG_VIRTUAL table contains virtual items for the OR management system log records.
SELECT
	LOG_ID
	,ACT_START_OTS_DTTM
FROM
	{{source('CLARITY','OR_LOG_VIRTUAL')}} AS  OR_LOG_VIRTUAL
--END OR_LOG_VIRTUAL_stg
--   