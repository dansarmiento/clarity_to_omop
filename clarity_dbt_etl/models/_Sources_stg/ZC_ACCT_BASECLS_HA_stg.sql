
{%- set source_relation = source('CLARITY', 'ZC_ACCT_BASECLS_HA') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_ACCT_BASECLS_HA_stg
SELECT
	ACCT_BASECLS_HA_C
	, UPPER("NAME") AS ZC_ACCT_BASECLS_HA_NAME
FROM
	{{ source('CLARITY','ZC_ACCT_BASECLS_HA')}} AS ZC_ACCT_BASECLS_HA
--END ZC_ACCT_BASECLS_HA_stg     