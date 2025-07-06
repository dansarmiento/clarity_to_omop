{%- set source_relation = source('CLARITY', 'CONCEPT_MAPPED') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CONCEPT_MAPPED_stg
--The CONCEPT_MAPPED table stores the Concept Identifier of the SNOMED concept or SmartData Identifier (SDI)
--  of the SmartData element referenced by mappings as well as the type of mapping associated with 
--  each concept-to-entity link. The mapped entities are given in the EXTERNAL_CNCPT_MAP table
SELECT
	MAPPING_ID
    ,LINE
    ,CONCEPT_ID
FROM
	{{source('CLARITY','CONCEPT_MAPPED')}} AS  CONCEPT_MAPPED
--END CONCEPT_MAPPED_stg
--