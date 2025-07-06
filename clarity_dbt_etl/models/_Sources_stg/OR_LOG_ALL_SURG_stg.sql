{%- set source_relation = source('CLARITY', 'OR_LOG_ALL_SURG') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN OR_LOG_ALL_SURG_stg
-- The OR_LOG_ALL_SURG table contains OR management system log surgeons
SELECT
	LOG_ID
	,LINE
	,SURG_ID
FROM
	{{source('CLARITY','OR_LOG_ALL_SURG')}} AS  OR_LOG_ALL_SURG
--END OR_LOG_ALL_SURG_stg
--   