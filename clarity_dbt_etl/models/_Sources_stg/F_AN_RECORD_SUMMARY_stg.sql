
{%- set source_relation = source('CLARITY', 'F_AN_RECORD_SUMMARY') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN F_AN_RECORD_SUMMARY_stg
--This derived fact table collects core information about anesthesia records into a standardized summary format. 
--Each row uniquely represents an anesthesia record.
SELECT
	 AN_EPISODE_ID
	,AN_52_ENC_CSN_ID
    ,AN_53_ENC_CSN_ID
    ,AN_START_DATETIME
	,AN_STOP_DATETIME
    ,AN_PROC_NAME
    ,AN_RESP_PROV_ID
FROM
	{{source('CLARITY','F_AN_RECORD_SUMMARY')}} AS  F_AN_RECORD_SUMMARY
        QUALIFY
        ROW_NUMBER() OVER (
        PARTITION BY AN_EPISODE_ID
        ORDER BY AN_EPISODE_ID
        )=1	
--END F_AN_RECORD_SUMMARY_stg
--    