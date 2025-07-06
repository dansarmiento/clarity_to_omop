
{%- set source_relation = source('CLARITY', 'CLARITY_TDL_TRAN') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN CLARITY_TDL_TRAN_stg
SELECT
	TDL_ID
    , DX_ONE_ID
    , DX_TWO_ID
    , DX_THREE_ID
    , DX_FOUR_ID
    , DX_FIVE_ID
    , DX_SIX_ID
    , ORIG_SERVICE_DATE
    , TYPE
    , INT_PAT_ID
    , PAT_ENC_CSN_ID
    , MATCH_PROV_ID
FROM
	{{source('CLARITY','CLARITY_TDL_TRAN')}} AS  CLARITY_TDL_TRAN
--END CLARITY_TDL_TRAN_stg
--
