
{%- set source_relation = source('CLARITY', 'PAT_ENC_2') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN PAT_ENC_2_stg
--This table supplements the PAT_ENC table. It contains additional information related to patient encounters or appointments.
SELECT
	PAT_ENC_CSN_ID
    , UPPER(PAT_ID) AS PAT_ID
	, IP_DOC_CONTACT_CSN
FROM
	{{source('CLARITY','PAT_ENC_2')}} AS  PAT_ENC_2
--END PAT_ENC_2_stg
--     