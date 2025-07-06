
{%- set source_relation = source('CLARITY', 'ALLERGY') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ALLERGY_stg
--The ALLERGY table contains information about the allergies noted in your patients' clinical system records
SELECT
	ALLERGY_ID
	,ALLERGEN_ID
	,ALRGY_ENTERED_DTTM
	,UPPER(DESCRIPTION) AS DESCRIPTION
	,ALLERGY_PAT_CSN
FROM
	{{source('CLARITY','ALLERGY')}} AS  ALLERGY
--END ALLERGY_stg
--   