{%- set source_relation = source('CLARITY', 'CLARITY_LOC') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_LOC_stg
--This table contains information about your location records. These include revenue locations and patients' primary clinics/locations. 
-- The records included in this table are Facility Profile (EAF) records that are designated as facility, service area, and location records. 
-- That is, Type of Location (I EAF 27) has a value of 1, 2, or 4.
SELECT
	LOC_ID
	,UPPER(LOC_NAME) AS LOC_NAME
FROM
	{{source('CLARITY','CLARITY_LOC')}} AS  CLARITY_LOC
--END CLARITY_LOC_stg 
--   