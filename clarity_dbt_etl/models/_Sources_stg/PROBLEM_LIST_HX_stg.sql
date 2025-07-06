
{%- set source_relation = source('CLARITY', 'PROBLEM_LIST_HX') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN PROBLEM_LIST_HX_stg
SELECT
	PROBLEM_LIST_ID
    ,LINE
	,HX_DATE_NOTED
    ,HX_DATE_RESOLVED
    ,HX_STATUS_C
FROM
	{{source('CLARITY','PROBLEM_LIST_HX')}} AS  PROBLEM_LIST_HX
--END PROBLEM_LIST_HX_stg
--
