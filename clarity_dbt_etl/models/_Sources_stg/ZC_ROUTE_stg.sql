
{%- set source_relation = source('CLARITY', 'ZC_ROUTE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_ROUTE_stg
-- This table contains the category information for medication administration routes.
SELECT
	ROUTE_C
	, UPPER("NAME") AS ZC_ROUTE_NAME
FROM
	{{ source('CLARITY','ZC_ROUTE')}} AS ZC_ADMIN_ROUTE
--END ZC_ROUTE_stg
