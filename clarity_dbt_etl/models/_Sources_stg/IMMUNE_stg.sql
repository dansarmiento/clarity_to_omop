
{%- set source_relation = source('CLARITY', 'IMMUNE') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN IMMUNE_stg
SELECT
	IMMUNE_ID
    ,PAT_ID
    ,IMMUNZATN_ID
	,IMMUNE_DATE::DATE 			AS IMMUNE_DATE
	,IMMUNIZATION_TIME
    ,UPPER(DOSE)                AS DOSE
    ,ROUTE_C
    ,LTRIM(RTRIM(LOT))          AS LOT
	,UPPER(MED_ADMIN_COMMENT)   AS MED_ADMIN_COMMENT
    ,IMM_CSN
    ,IMMNZTN_DOSE_UNIT_C
    ,NDC_NUM_ID
    ,ORDER_ID
    ,IMMNZTN_STATUS_C

FROM
	{{source('CLARITY','IMMUNE')}} AS  IMMUNE
--END IMMUNE_stg
--
