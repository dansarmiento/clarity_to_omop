
{%- set source_relation = source('CLARITY', 'CLARITY_EDG') -%}

{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_EDG_stg
--The CLARITY_EDG table contains basic information about diagnoses.
SELECT
	DX_ID
	,UPPER(DX_NAME) AS DX_NAME
    ,CURRENT_ICD9_LIST
    ,CURRENT_ICD10_LIST
FROM
	{{source('CLARITY','CLARITY_EDG')}} AS CLARITY_EDG
--END CLARITY_EDG_stg
--
