
{%- set source_relation = source('CLARITY', 'EDG_CURRENT_ICD9') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN EDG_CURRENT_ICD9_stg
SELECT
	DX_ID
    ,LINE
	,UPPER(CODE) as CODE
FROM
	{{source('CLARITY','EDG_CURRENT_ICD9')}} AS  EDG_CURRENT_ICD9
	    QUALIFY
        ROW_NUMBER() OVER (
        PARTITION BY DX_ID,  LINE
        ORDER BY DX_ID,  LINE
        )=1	
--END EDG_CURRENT_ICD9_stg
--   