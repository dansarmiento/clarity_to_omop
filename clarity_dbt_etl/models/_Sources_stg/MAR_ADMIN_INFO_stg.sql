{%- set source_relation = source('CLARITY', 'MAR_ADMIN_INFO') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN MAR_ADMIN_INFO_stg
-- This table contains the currently active medication administration data.
SELECT 
	ORDER_MED_ID
	,LINE     
	,TAKEN_TIME
	,UPPER(SIG)                 AS SIG
    ,MAR_ACTION_C
	,EDITED_LINE
	,REASON_C
    ,INFUSION_RATE
    ,MAR_INF_RATE_UNIT_C
	,DOSE_UNIT_C
	,ROUTE_C
	,UPPER(MAR_ENC_CSN) 		AS MAR_ENC_CSN
FROM
	{{source('CLARITY','MAR_ADMIN_INFO')}} AS  MAR_ADMIN_INFO
 --END MAR_ADMIN_INFO_stg	
--         