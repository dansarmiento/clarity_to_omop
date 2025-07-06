
{%- set source_relation = source('CLARITY', 'AN_HSB_LINK_INFO') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN AN_HSB_LINK_INFO_stg
--This table stores Anesthesia episode-level information.
SELECT
	SUMMARY_BLOCK_ID
    ,AN_BILLING_CSN_ID
FROM
	{{source('CLARITY','AN_HSB_LINK_INFO')}} AS  AN_HSB_LINK_INFO
--END AN_HSB_LINK_INFO_stg
--
      