
{%- set source_relation = source('CLARITY', 'ZC_DISCH_DISP') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_DISCH_DISP_stg
--This table contains the category information for discarge dispositions.
SELECT
	DISCH_DISP_C
	,UPPER("NAME") AS ZC_DISCH_DISP_NAME
FROM
	{{ source('CLARITY','ZC_DISCH_DISP')}} AS ZC_DISCH_DISP
--END ZC_DISCH_DISP_stg
-- 