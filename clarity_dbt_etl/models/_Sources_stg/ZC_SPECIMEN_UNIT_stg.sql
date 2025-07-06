
{%- set source_relation = source('CLARITY', 'ZC_SPECIMEN_UNIT') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_SPECIMEN_UNIT_stg
--This table stores possible options for specimen weight units.
SELECT
	SPECIMEN_UNIT_C
	, UPPER("NAME") AS  ZC_SPECIMEN_UNIT_NAME
FROM
	{{source('CLARITY','ZC_SPECIMEN_UNIT')}} AS  ZC_SPECIMEN_UNIT
--END ZC_SPECIMEN_UNIT_stg
--