
{%- set source_relation = source('CLARITY', 'CLARITY_PRC') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_PRC_stg
--The CLARITY_PRC table contains one record for each visit type, panel, agent, and visit type modifier in your system.
SELECT
	PRC_ID
    ,UPPER(PRC_NAME) AS PRC_NAME
FROM
	{{source('CLARITY','CLARITY_PRC')}} AS  CLARITY_PRC
--END CLARITY_PRC_stg   