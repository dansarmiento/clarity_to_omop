
{%- set source_relation = source('CLARITY', 'PAT_ALLERGIES') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN PAT_ALLERGIES_stg
-- The allergies that are associated with a patient are stored on this table. 
-- This table also provides a link from the Patient (EPT) based tables to the Problem List (LPL) based tables.
SELECT
	PAT_ID
	,LINE
    ,ALLERGY_RECORD_ID
FROM
	{{source('CLARITY','PAT_ALLERGIES')}} AS  PAT_ALLERGIES
--END PAT_ALLERGIES_stg
--   