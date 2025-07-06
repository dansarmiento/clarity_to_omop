
{%- set source_relation = source('CLARITY', 'HSC_SPEC_INFO') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN HSC_SPEC_INFO_stg
--This table holds the specimen details.
SELECT
	RECORD_ID
	, SPECIMEN_SIZE
    , SPECIMEN_TYPE_C
    , SPECIMEN_UNIT_C
FROM
	{{source('CLARITY','HSC_SPEC_INFO')}} AS  HSC_SPEC_INFO
--END HSC_SPEC_INFO_stg
--