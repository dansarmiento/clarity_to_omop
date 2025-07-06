
{%- set source_relation = source('CLARITY', 'ORDER_RESULTS') -%}
{{ config(materialized = 'ephemeral') }}
--ORDER_RESULTS_stg
--This table contains information on results from clinical system orders. 
-- This table extracts only the last Orders (ORD) contact for each ORD record.
SELECT
	ORDER_PROC_ID, ORD_DATE_REAL, LINE
	,UPPER(ORD_VALUE)       AS ORD_VALUE
	,UPPER(REFERENCE_LOW)   AS REFERENCE_LOW
	,UPPER(REFERENCE_HIGH)  AS REFERENCE_HIGH
	,COMPON_LNC_ID
	,UPPER(RESULT_FLAG_C)   AS RESULT_FLAG_C
 	,UPPER(RESULT_STATUS_C) AS RESULT_STATUS_C  
	,UPPER(REFERENCE_UNIT)  AS REFERENCE_UNIT
FROM
	{{source('CLARITY','ORDER_RESULTS')}} AS  ORDER_RESULTS
--ORDER_RESULTS_stg
--    