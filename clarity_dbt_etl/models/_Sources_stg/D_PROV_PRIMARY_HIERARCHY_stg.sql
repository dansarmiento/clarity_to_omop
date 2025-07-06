
{%- set source_relation = source('CLARITY', 'D_PROV_PRIMARY_HIERARCHY') -%}
{{ config(materialized = 'ephemeral') }}
--D_PROV_PRIMARY_HIERARCHY_stg
--This table gives provider-level information for use in reports. It includes, among other details, the provider's primary department,
--  as well as that department's location and service area. It also calculates "name with id" columns for provider, department, location, 
--  and service area. Consider using this table when reporting on provider-level information. It is intended to improve performance and maintainability
SELECT
	PROV_ID
	,UPPER(SPECIALTY_C) AS SPECIALTY_C
FROM
	{{source('CLARITY','D_PROV_PRIMARY_HIERARCHY')}} AS  D_PROV_PRIMARY_HIERARCHY
--END D_PROV_PRIMARY_HIERARCHY_stg
--