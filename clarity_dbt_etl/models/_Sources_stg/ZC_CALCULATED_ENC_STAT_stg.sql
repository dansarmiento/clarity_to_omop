
{%- set source_relation = source('CLARITY', 'ZC_CALCULATED_ENC_STAT') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_CALCULATED_ENC_STAT_stg
--This table contains the category information for calculated encounter statuses.
SELECT
	CALCULATED_ENC_STAT_C
	, UPPER("NAME") AS ZC_CALCULATED_ENC_STAT_NAME
FROM
	{{ source('CLARITY','ZC_CALCULATED_ENC_STAT')}} AS ZC_CALCULATED_ENC_STAT
-- END ZC_CALCULATED_ENC_STAT_stg
--
