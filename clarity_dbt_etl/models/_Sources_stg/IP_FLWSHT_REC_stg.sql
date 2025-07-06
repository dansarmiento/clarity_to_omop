
{%- set source_relation = source('CLARITY', 'IP_FLWSHT_REC') -%}
{{ config(materialized = 'view') }}
--BEGIN IP_FLWSHT_REC_stg
--This table contains linking information associated with flowsheet records.
SELECT
     FSD_ID
	,INPATIENT_DATA_ID
FROM
	{{source('CLARITY','IP_FLWSHT_REC')}} AS  IP_FLWSHT_REC
QUALIFY
        ROW_NUMBER() OVER (
        PARTITION BY FSD_ID
        ORDER BY FSD_ID
        )=1	
--END IP_FLWSHT_REC_stg
--  