
{%- set source_relation = source('CLARITY', 'ORDER_PROC_2') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ORDER_PROC_2_stg
--The ORDER_PROC_2 table enables you to report on the procedures ordered in the clinical system. 
--This procedure table has the same basic structure as ORDER_PROC, but was created as a second table 
--to prevent ORDER_PROC from getting any larger.
SELECT
	ORDER_PROC_ID
	, SPECIMN_TAKEN_TIME
FROM
	{{source('CLARITY','ORDER_PROC_2')}} AS  ORDER_PROC_2
--END ORDER_PROC_2_stg
--      