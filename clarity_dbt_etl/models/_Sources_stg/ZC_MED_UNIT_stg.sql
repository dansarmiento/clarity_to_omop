{%- set source_relation = source('CLARITY', 'ZC_MED_UNIT') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_MED_UNIT_stg
-- dbt source_stg
SELECT
	DISP_QTYUNIT_C
	, UPPER("NAME") AS  ZC_MED_UNIT_NAME
FROM
	{{ source('CLARITY','ZC_MED_UNIT')}} AS  ZC_MED_UNIT
--END ZC_MED_UNIT_stg    
--  