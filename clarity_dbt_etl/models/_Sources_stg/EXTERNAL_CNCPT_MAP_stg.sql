
{%- set source_relation = source('CLARITY', 'EXTERNAL_CNCPT_MAP') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN EXTERNAL_CNCPT_MAP_stg
--The EXTERNAL_CNCPT_MAP table stores information about mappings as well as the entities (record/category/item) they reference. 
-- The SNOMED concepts or SmartData elements referenced by mappings are stored in the CONCEPT_MAPPED table.
SELECT
	MAPPING_ID
	,ENTITY_VALUE_NUM
    ,ENTITY_INI
    ,ENTITY_ITEM
FROM
	{{source('CLARITY','EXTERNAL_CNCPT_MAP')}} AS  EXTERNAL_CNCPT_MAP
--END EXTERNAL_CNCPT_MAP_stg
--