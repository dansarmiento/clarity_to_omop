
{%- set source_relation = source('CLARITY', 'CLARITY_ADT') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_ADT_stg
--The CLARITY_ADT table is the master table for ADT event history information. This table contains several foreign keys for other ADT tables
SELECT
	EVENT_ID
    ,PAT_ID
    ,PAT_ENC_CSN_ID
	,ROOM_ID
    ,BED_ID
    ,PAT_SERVICE_C
    ,PAT_LVL_OF_CARE_C
    ,SEQ_NUM_IN_ENC
    ,EFFECTIVE_TIME
    ,EVENT_TYPE_C
    ,NEXT_OUT_EVENT_ID
FROM
	{{source('CLARITY','CLARITY_ADT')}} AS  CLARITY_ADT
--END CLARITY_ADT_stg
---