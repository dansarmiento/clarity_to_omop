
{%- set source_relation = source('CLARITY', 'CLARITY_EMP') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_EMP_stg
-- This table contains high-level information about user records from the User master file
SELECT
	USER_ID --included because it is the primark key of CLARITY_EMP
	,PROV_ID
    ,LGIN_DEPARTMENT_ID
FROM
	{{source('CLARITY','CLARITY_EMP')}} AS  CLARITY_EMP
--END CLARITY_EMP_stg     