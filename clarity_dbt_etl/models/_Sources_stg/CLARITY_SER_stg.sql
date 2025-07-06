{%- set source_relation = source('CLARITY', 'CLARITY_SER') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_SER_stg
--The CLARITY_SER table contains high-level information about your provider records. 
-- These records may be caregivers, resources, classes, devices, and modalities.
SELECT
	PROV_ID
	,UPPER(PROV_NAME) AS PROV_NAME
	,UPPER(PROV_TYPE) AS PROV_TYPE
    ,SEX_C
    ,BIRTH_DATE
    ,DEA_NUMBER
FROM
	{{source('CLARITY','CLARITY_SER')}} AS  CLARITY_SER
--END CLARITY_SER_stg
--   