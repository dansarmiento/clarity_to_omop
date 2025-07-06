
{%- set source_relation = source('CLARITY', 'HSP_ACCOUNT') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN HSP_ACCOUNT_stg
--This table contains hospital account information from the Hospital Account (HAR) and Claim (CLM) master files.
SELECT
	HSP_ACCOUNT_ID
    ,ADM_DATE_TIME
    ,DISCH_DATE_TIME
    ,ATTENDING_PROV_ID
    ,REFERRING_PROV_ID
FROM
	{{source('CLARITY','HSP_ACCOUNT')}} AS  HSP_ACCOUNT
--END HSP_ACCOUNT_stg
--