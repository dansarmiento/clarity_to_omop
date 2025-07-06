{%- set source_relation = source('CLARITY', 'IP_FLWSHT_MEAS') -%}
{{ config(materialized = 'table') }}
--BEGIN IP_FLWSHT_MEAS_stg
-- This table contains the patient-specific measurements from flowsheets.
SELECT
	 UPPER(FSD_ID) AS FSD_ID
    ,LINE
    ,UPPER(FLO_MEAS_ID) AS FLO_MEAS_ID
	,RECORDED_TIME
	,UPPER(MEAS_VALUE) AS MEAS_VALUE
FROM
	{{source('CLARITY','IP_FLWSHT_MEAS')}} AS  IP_FLWSHT_MEAS
    INNER JOIN
    {{ref('SOURCE_TO_CONCEPT_MAP_stg')}} AS SOURCE_TO_CONCEPT_MAP
        ON UPPER(IP_FLWSHT_MEAS.FLO_MEAS_ID) = SOURCE_TO_CONCEPT_MAP.SOURCE_CODE
QUALIFY
        ROW_NUMBER() OVER (
        PARTITION BY FSD_ID,  LINE
        ORDER BY FSD_ID,  LINE
        )=1	
--END IP_FLWSHT_MEAS_stg
-- 