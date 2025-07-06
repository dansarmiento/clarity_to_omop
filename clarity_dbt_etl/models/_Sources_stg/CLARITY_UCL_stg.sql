{%- set source_relation = source('CLARITY', 'CLARITY_UCL') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_UCL_stg
--The CLARITY_UCL table Universal Charge Lines (UCL) information. Each row represents one UCL transaction.

SELECT
	UCL_ID
    ,SERVICE_DATE_DT
    ,PATIENT_ID
    ,EPT_CSN

FROM
	{{source('CLARITY','CLARITY_UCL')}} AS  CLARITY_UCL
--END CLARITY_UCL_stg
--   