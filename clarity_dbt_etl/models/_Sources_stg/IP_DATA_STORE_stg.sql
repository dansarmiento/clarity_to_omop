
{%- set source_relation = source('CLARITY', 'IP_DATA_STORE') -%}
{{ config(materialized = 'table') }}
--BEGIN IP_DATA_STORE_stg
--This table contains generic information related to a patient's inpatient stay, including data on patient education, notes, and other topics
SELECT
	 INPATIENT_DATA_ID
	,EPT_CSN
FROM
	{{source('CLARITY','IP_DATA_STORE')}} AS  IP_DATA_STORE
--END IP_DATA_STORE_stg
--   