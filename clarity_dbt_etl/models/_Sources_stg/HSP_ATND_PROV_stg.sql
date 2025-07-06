
{%- set source_relation = source('CLARITY', 'HSP_ATND_PROV') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN HSP_ATND_PROV_stg
--The HSP_ATND_PROV table contains information on inpatient or outpatient attending providers.
SELECT
	 PAT_ID
    ,PAT_ENC_CSN_ID
    ,LINE
    ,ATTEND_FROM_DATE
    ,ATTEND_TO_DATE
    ,UPPER(PROV_ID)         AS PROV_ID
    ,UPPER(ED_ATTEND_YN)    AS ED_ATTEND_YN
FROM
	{{source('CLARITY','HSP_ATND_PROV')}} AS  HSP_ATND_PROV
--END HSP_ATND_PROV_stg
--
   