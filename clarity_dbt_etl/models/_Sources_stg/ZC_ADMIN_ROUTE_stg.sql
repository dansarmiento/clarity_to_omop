
{%- set source_relation = source('CLARITY', 'ZC_ADMIN_ROUTE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_ADMIN_ROUTE_stg
-- This table contains the category information for medication administration routes.
SELECT DISTINCT
	MED_ROUTE_C
	, UPPER("NAME") AS ZC_ADMIN_ROUTE_NAME
FROM
	{{ source('CLARITY','ZC_ADMIN_ROUTE')}} AS ZC_ADMIN_ROUTE
--END ZC_ADMIN_ROUTE_stg
