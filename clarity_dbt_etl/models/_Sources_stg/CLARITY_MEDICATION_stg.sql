
{%- set source_relation = source('CLARITY', 'CLARITY_MEDICATION') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN cte__CLARITY_MEDICATION_stg
-- The CLARITY_MEDICATION table contains high-level information from all the medications for use in your facility.
SELECT 
     MEDICATION_ID             AS MEDICATION_ID
	,UPPER(NAME)               AS NAME
FROM
	{{source('CLARITY','CLARITY_MEDICATION')}} AS  CLARITY_MEDICATION
--END cte__CLARITY_MEDICATION_stg  
--  