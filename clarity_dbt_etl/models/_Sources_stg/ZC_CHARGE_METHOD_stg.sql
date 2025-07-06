
{%- set source_relation = source('CLARITY', 'ZC_CHARGE_METHOD') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ZC_CHARGE_METHOD_stg
SELECT
	CHARGE_METHOD_C
	,UPPER("NAME") AS ZC_CHARGE_METHOD_NAME
FROM
	{{ source('CLARITY','ZC_CHARGE_METHOD')}} AS ZC_CHARGE_METHOD
--END ZC_CHARGE_METHOD_stg