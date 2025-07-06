{%- set source_relation = source('CLARITY', 'ORDER_MED') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ORDER_MED_stg
--The ORDER_MED table enables you to report on medications ordered in EpicCare (prescriptions).
SELECT ORDER_MED_ID
    ,MEDICATION_ID
	,AUTHRZING_PROV_ID
	,ORDER_END_TIME
	,ORDER_START_TIME
	,RSN_FOR_DISCON_C
	,MED_ROUTE_C
	,ORDER_STATUS_C

--  *** Deprecated *** In table ORDER_MED, the column SIG has been deprecated. 
--  This column has been replaced by column SIG_TEXT in the table ORDER_MED_SIG. 
--  To look up the deprecated column's value after the Clarity Compass upgrade, use the column SIG_TEXT value. 
--  The SIG_TEXT column has been expanded to hold more characters in the new table ORDER_MED_SIG.
    ,SIG	
	,END_DATE
	,REFILLS
	,QUANTITY
    ,PAT_ENC_CSN_ID
    ,HV_DOSE_UNIT_C
FROM
	{{source('CLARITY','ORDER_MED')}} AS  ORDER_MED
--END ORDER_MED_stg  
--    