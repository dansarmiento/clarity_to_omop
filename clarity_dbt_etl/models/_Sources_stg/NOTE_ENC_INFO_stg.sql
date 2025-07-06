
{%- set source_relation = source('CLARITY', 'NOTE_ENC_INFO') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN NOTE_ENC_INFO_stg
-- This table contains information from overtime single-response items about General Use Notes (HNO) records
SELECT
    CONTACT_SERIAL_NUM
    ,NOTE_ID
	,CONTACT_DATE_REAL
    ,ENTRY_INSTANT_DTTM
FROM
	{{source('CLARITY','NOTE_ENC_INFO')}} AS  NOTE_ENC_INFO
--END NOTE_ENC_INFO_stg
--   