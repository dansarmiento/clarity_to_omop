
{%- set source_relation = source('CLARITY', 'CL_ELG') -%}

{{ config(materialized = 'ephemeral') }}
--BEGIN CL_ELG_stg
-- This table holds the information for a blood unit associated with an order. 
-- The data includes the discrete information for the blood unit (including identifiers) as well as the scanning compliance for the discrete information.
SELECT
	ALLERGEN_ID
	, UPPER("ALLERGEN_NAME") AS  ALLERGEN_NAME
FROM
	{{source('CLARITY','CL_ELG')}} AS  CL_ELG
--END CL_ELG_stg
--   