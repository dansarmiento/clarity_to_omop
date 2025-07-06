
{%- set source_relation = source('CLARITY', 'LNC_DB_MAIN') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN LNC_DB_MAIN_stg
--This is the primary table for Logical Observation Identifiers Names and Codes (LOINC?) information.
SELECT
	RECORD_ID               AS RECORD_ID
	,UPPER(LNC_CODE)        AS LNC_CODE
	,UPPER(LNC_COMPON)      AS LNC_COMPON
FROM
	{{source('CLARITY','LNC_DB_MAIN')}} AS  LNC_DB_MAIN
--END LNC_DB_MAIN_stg
--     