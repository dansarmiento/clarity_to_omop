
{%- set source_relation = source('CLARITY', 'CLARITY_MOD') -%}

{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_MOD_stg
-- This table contains masterfile information on billing modifiers.
SELECT
	MODIFIER_ID
	, UPPER("MODIFIER_NAME") AS  MODIFIER_NAME
FROM
	{{source('CLARITY','CLARITY_MOD')}} AS  CLARITY_MOD
--END CLARITY_MOD_stg
--