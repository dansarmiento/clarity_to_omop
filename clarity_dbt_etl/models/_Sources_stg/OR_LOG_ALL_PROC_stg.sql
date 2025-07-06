{%- set source_relation = source('CLARITY', 'OR_LOG_ALL_PROC') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN OR_LOG_ALL_PROC_stg
-- The OR_LOG_ALL_PROC table contains OR management system log procedures.
SELECT
	LOG_ID
	,LINE
	,ALL_PROC_CODE_ID
	,ALL_PANEL_ADDL_ID
FROM
	{{source('CLARITY','OR_LOG_ALL_PROC')}} AS  OR_LOG_ALL_PROC
--END OR_LOG_ALL_PROC_stg
--   