
{%- set source_relation = source('CLARITY', 'SNOMED_CONCEPT') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN SNOMED_CONCEPT_stg
--This table contains data related to SNOMED concepts. The data in this table is populated by the SNOMED import.
SELECT
	CONCEPT_ID
    ,FULLY_SPECIFIED_NM
FROM
	{{source('CLARITY','SNOMED_CONCEPT')}} AS  SNOMED_CONCEPT
--END SNOMED_CONCEPT_stg
--   