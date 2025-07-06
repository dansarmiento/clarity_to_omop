
{%- set source_relation = source('CLARITY', 'CLARITY_DEP') -%}
{{ config(materialized = 'ephemeral') }}
--CLARITY_DEP_stg
--The CLARITY_DEP table contains high-level information about departments.
SELECT
	DEPARTMENT_ID
	,REV_LOC_ID
    ,UPPER(DEPARTMENT_NAME) AS DEPARTMENT_NAME
FROM
	{{source('CLARITY','CLARITY_DEP')}} AS  CLARITY_DEP
--END CLARITY_DEP_stg
--