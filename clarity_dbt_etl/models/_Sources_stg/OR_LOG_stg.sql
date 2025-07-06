{%- set source_relation = source('CLARITY', 'OR_LOG') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN OR_LOG_stg
-- The OR_LOG table contains information about surgical and procedural log (ORL) records.
SELECT
	LOG_ID
	,SCHED_START_TIME
	,PRIMARY_PHYS_ID
	,STATUS_C
FROM
	{{source('CLARITY','OR_LOG')}} AS  OR_LOG
	    QUALIFY
        ROW_NUMBER() OVER (
        PARTITION BY LOG_ID
        ORDER BY LOG_ID
        )=1	
--END OR_LOG_stg
--   