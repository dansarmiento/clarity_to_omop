
{%- set source_relation = source('CLARITY', 'ORDER_PROC') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ORDER_PROC_stg
--The ORDER_PROC table enables you to report on the procedures ordered in the clinical system. 
-- We have also included patient and contact identification information for each record.
SELECT
     ORDER_PROC_ID
    ,PAT_ENC_CSN_ID	 
	,ORDERING_DATE
	,ORDER_TIME
	,PROC_START_TIME
	,PROC_ENDING_TIME
	,INSTANTIATED_TIME	
	,AUTHRZING_PROV_ID
	,QUANTITY
	,PROC_ID
	,MODIFIER1_ID
	,ORDER_STATUS_C
	,LAB_STATUS_C
	,ORDER_CLASS_C
	,ORDER_TYPE_C
	,FUTURE_OR_STAND
FROM
	{{source('CLARITY','ORDER_PROC')}} AS  ORDER_PROC
 --END ORDER_PROC_stg
--  