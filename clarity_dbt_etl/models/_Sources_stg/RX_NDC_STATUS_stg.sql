{%- set source_relation = source('CLARITY', 'RX_NDC_STATUS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN RX_NDC_STATUS_stg
--This table contains the medication related to NDC for each contact.

SELECT NDC_ID
    ,CONTACT_DATE_REAL
    ,UPPER(CNCT_SERIAL_NUM) AS CNCT_SERIAL_NUM
FROM
	{{source('CLARITY','RX_NDC_STATUS')}} AS  RX_NDC_STATUS
--END RX_NDC_STATUS_stg   
--   