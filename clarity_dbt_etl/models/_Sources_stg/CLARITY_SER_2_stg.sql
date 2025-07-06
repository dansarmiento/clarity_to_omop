{%- set source_relation = source('CLARITY', 'CLARITY_SER_2') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_SER_2_stg
--The CLARITY_SER table contains high-level information about your provider records. 
-- These records may be caregivers, resources, classes, devices, and modalities.
SELECT
	PROV_ID
    ,NPI
    ,PRIMARY_DEPT_ID
FROM
	{{source('CLARITY','CLARITY_SER_2')}} AS  CLARITY_SER_2
--END CLARITY_SER_2_stg
--