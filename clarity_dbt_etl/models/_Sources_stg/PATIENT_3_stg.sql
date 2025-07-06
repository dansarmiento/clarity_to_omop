
{%- set source_relation = source('CLARITY', 'PATIENT_3') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN PATIENT_3_stg
--This table supplements the information contained in the PATIENT table. 
---It contains basic information about patients, such as the patient's ID, occupation, English fluency, etc
SELECT
	PAT_ID
	,PCOD_CAUSE_DX_ID
FROM
	{{source('CLARITY','PATIENT_3')}} AS  PATIENT_3
--END PATIENT_3_stg
--