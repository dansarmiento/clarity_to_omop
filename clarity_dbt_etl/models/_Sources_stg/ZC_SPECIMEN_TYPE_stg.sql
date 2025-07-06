
{%- set source_relation = source('CLARITY', 'ZC_SPECIMEN_TYPE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_SPECIMEN_TYPE_stg
--This table stores possible options for specimen type.
SELECT
	SPECIMEN_TYPE_C
	, UPPER("NAME") AS ZC_SPECIMEN_TYPE_NAME
FROM
	{{source('CLARITY','ZC_SPECIMEN_TYPE')}} AS  ZC_SPECIMEN_TYPE
--END ZC_SPECIMEN_TYPE_stg
--