
{%- set source_relation = source('CLARITY', 'HNO_INFO') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN HNO_INFO_stg
-- This table contains common information from General Use Notes items. 
-- This table focuses on time-insensitive, once-per-record data while other HNO tables 
-- (e.g., NOTES_ACCT, CODING_CLA_NOTES) contain the data for different note types.
SELECT
	NOTE_ID
	,PAT_ID
	,PAT_ENC_CSN_ID
	,IP_NOTE_TYPE_C
	,AMB_NOTE_YN
FROM
	{{source('CLARITY','HNO_INFO')}} AS  HNO_INFO
--END HNO_INFO_stg
--   