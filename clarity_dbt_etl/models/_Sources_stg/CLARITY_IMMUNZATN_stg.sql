
{%- set source_relation = source('CLARITY', 'CLARITY_IMMUNZATN') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_IMMUNZATN_stg
SELECT
	IMMUNZATN_ID
	,UPPER("NAME") AS  IMMUNZATN_ID_NAME
    ,ROUTE_C
    ,CVX_CODE

FROM
	{{source('CLARITY','CLARITY_IMMUNZATN')}} AS  CLARITY_IMMUNZATN
--END CLARITY_IMMUNZATN_stg
--
