{%- set source_relation = source('CLARITY', 'RX_NDC') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN RX_NDC_stg
--This table contains the medication related to NDC for each contact.

SELECT NDC_ID
    ,NDC_CODE
    ,UPPER(RAW_11_DIGIT_NDC) AS RAW_11_DIGIT_NDC
FROM
	{{source('CLARITY','RX_NDC')}} AS  RX_NDC
--END RX_NDC_stg   
--   