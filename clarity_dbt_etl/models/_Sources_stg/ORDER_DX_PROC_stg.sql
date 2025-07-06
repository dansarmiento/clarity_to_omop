
{%- set source_relation = source('CLARITY', 'ORDER_DX_PROC') -%}

{{ config(materialized = 'ephemeral') }}
--BEGIN ORDER_DX_PROC_stg
-- The ORDER_DX_PROC table enables you to report on the diagnoses associated with procedures ordered in clinical system. 
-- Since one procedure order may be associated with multiple diagnoses, each row in this table is one procedure - diagnosis relation
SELECT
	ORDER_PROC_ID
    ,LINE
    ,DX_ID
FROM
	{{source('CLARITY','ORDER_DX_PROC')}} AS  ORDER_DX_PROC
--end ORDER_DX_PROC_stg  
--