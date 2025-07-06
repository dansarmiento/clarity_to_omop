
{%- set source_relation = source('CLARITY', 'HSP_ACCT_ADMIT_DX') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN HSP_ACCT_ADMIT_DX_stg
SELECT
	  HSP_ACCOUNT_ID
    , LINE
    , ADMIT_DX_ID
	, UPPER("ADMIT_DX_TEXT") AS  ADMIT_DX_TEXT
FROM
	{{source('CLARITY','HSP_ACCT_ADMIT_DX')}} AS  HSP_ACCT_ADMIT_DX
--END HSP_ACCT_ADMIT_DX_stg
--
