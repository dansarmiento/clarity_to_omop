{%- set source_relation = source('CLARITY', 'LINKED_CHARGEABLES') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN LINKED_CHARGEABLES_stg
SELECT
	PROC_ID
	,CONTACT_DATE_REAL
    ,LINE
    ,LINKED_CHRG_ID
FROM
	{{source('CLARITY','LINKED_CHARGEABLES')}} AS  LINKED_CHARGEABLES
--END LINKED_CHARGEABLES_stg
--   