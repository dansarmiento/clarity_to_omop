
{%- set source_relation = source('CLARITY', 'ZC_APPT_STATUS') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_APPT_STATUS_stg
--This table contains the category information for appointment statuses.
SELECT
	APPT_STATUS_C
	, UPPER("NAME") AS ZC_APPT_STATUS_NAME
FROM
	{{ source('CLARITY','ZC_APPT_STATUS')}} AS ZC_APPT_STATUS
--END ZC_APPT_STATUS_stg
--