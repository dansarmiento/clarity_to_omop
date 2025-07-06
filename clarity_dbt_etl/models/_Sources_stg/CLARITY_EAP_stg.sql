{%- set source_relation = source('CLARITY', 'CLARITY_EAP') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_EAP_stg
-- The CLARITY_EAP table contains basic information about the procedure records in your system. 
SELECT
	UPPER(PROC_ID) AS PROC_ID
	,UPPER(PROC_CODE) AS PROC_CODE
	,UPPER(PROC_NAME) AS PROC_NAME
FROM
	{{source('CLARITY','CLARITY_EAP')}} AS  CLARITY_EAP
--END CLARITY_EAP_stg
--   