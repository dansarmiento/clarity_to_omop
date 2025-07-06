
{%- set source_relation = source('CLARITY', 'BLOOD_ADMIN_INFO') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN BLOOD_ADMIN_INFO_stg
--This table holds the information for a blood unit associated with an order. 
-- The data includes the discrete information for the blood unit (including identifiers)
--  as well as the scanning compliance for the discrete information.
SELECT
	ORDER_ID
	,LINE
	,UPPER(BLOOD_ADMIN_UNIT) AS BLOOD_ADMIN_UNIT
	,UPPER(BLOOD_ADMIN_PROD) AS BLOOD_ADMIN_PROD
	,UPPER(BLOOD_ADMIN_TYPE) AS BLOOD_ADMIN_TYPE
FROM
	{{source('CLARITY','BLOOD_ADMIN_INFO')}} AS  BLOOD_ADMIN_INFO
--END BLOOD_ADMIN_INFO_stg
--   