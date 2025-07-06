
{%- set source_relation = source('CLARITY', 'PAT_ENC_DX') -%}
{{ config(materialized = 'ephemeral') }}
-- --BEGIN PAT_ENC_DX_stg
-- The patient encounter diagnosis table contains one record for each diagnosis associated with each encounter level of service. 
-- This table will contain all diagnoses specified on the Order Summary screen.
SELECT
	PAT_ID
	,PAT_ENC_CSN_ID
    ,LINE
    ,CONTACT_DATE
    ,DX_ID
    ,PRIMARY_DX_YN
FROM
	{{source('CLARITY','PAT_ENC_DX')}} AS  PAT_ENC_DX
--END PAT_ENC_DX_stg
--   