
{%- set source_relation = source('CLARITY', 'HSP_ACCT_DX_LIST') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN HSP_ACCT_DX_LIST_stg
SELECT
      HSP_ACCOUNT_ID
      ,LINE
      ,DX_ID
      ,FINAL_DX_SOI_C

FROM
	{{source('CLARITY','HSP_ACCT_DX_LIST')}} AS  HSP_ACCT_DX_LIST
--END HSP_ACCT_DX_LIST_stg
--
