
{%- set source_relation = source('CLARITY', 'HNO_NOTE_TEXT') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN HNO_NOTE_TEXT_stg
SELECT
    NOTE_ID
	,NOTE_CSN_ID
	,LINE
    ,CONTACT_DATE_REAL
    ,CONTACT_DATE
    ,NOTE_TEXT
    ,IS_ARCHIVED_YN
    ,CM_CT_OWNER_ID
    ,CHRON_ITEM_NUM
FROM
	{{source('CLARITY','HNO_NOTE_TEXT')}} AS  HNO_NOTE_TEXT
	    --QUALIFY
        --ROW_NUMBER() OVER (
        --PARTITION BY NOTE_CSN_ID,  LINE
        --ORDER BY NOTE_CSN_ID,  LINE
        --)=1	    
--END HNO_NOTE_TEXT_stg
--   