
{%- set source_relation = source('CLARITY', 'OR_OPE_PROC_CODE') -%}

{{ config(materialized = 'ephemeral') }}
--BEGIN OR_OPE_PROC_CODE_stg
-- The OR_OPE_PROC_CODE table contains information about log procedure codes.
SELECT
	OPE_ID
	,LINE
    ,PROC_CODE_ID
FROM
	{{source('CLARITY','OR_OPE_PROC_CODE')}} AS  OR_OPE_PROC_CODE
--END OR_OPE_PROC_CODE_stg
--   