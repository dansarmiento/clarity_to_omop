
{%- set source_relation = source('CLARITY', 'PROBLEM_LIST') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN PROBLEM_LIST_stg
SELECT
	PROBLEM_LIST_ID
    ,DX_ID
    ,NOTED_DATE
    ,RESOLVED_DATE
	,UPPER("PRINCIPAL_PL_YN") AS  PRINCIPAL_PL_YN -- depricated use PAT_ENC_HOSP_PROB.PRINCIPAL_PROB_YN
    ,PROBLEM_EPT_CSN  -- depricated use PROBLEM_LIST_HX.HX_PROBLEM_EPT_CSN
FROM
	{{source('CLARITY','PROBLEM_LIST')}} AS  PROBLEM_LIST
--END PROBLEM_LIST_stg
--
