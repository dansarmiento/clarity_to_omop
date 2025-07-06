{%- set source_relation = source('CLARITY', 'V_RX_CHARGES') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN V_RX_CHARGES_stg
--This view collects and displays Universal Charge Line information for Willow charges

SELECT 	
    UCL_ID
    ,CHARGE_COUNT
    ,IMPLIED_QTY
    ,CHARGED_QTY
    ,UPPER(CHARGED_QTY_UNIT_NAME) AS CHARGED_QTY_UNIT_NAME 
    ,ORDER_ID
    ,DISP_NDC_CSN
FROM
	{{source('CLARITY','V_RX_CHARGES')}} AS  V_RX_CHARGES
--END V_RX_CHARGES_stg   
--   