{%- set source_relation = source('CLARITY', 'ORDER_MED_SIG') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN ORDER_MED_SIG_stg
--	The ORDER_MED_SIG table stores the patient instructions for a prescription as entered by the user. The table should be used in conjunction with the ORDER_MED table which contains related medication, patient, and contact identification information you can report on.
SELECT ORDER_ID, SIG_TEXT 
FROM
	{{source('CLARITY','ORDER_MED_SIG')}} AS  ORDER_MED_SIG
--END ORDER_MED_SIG_stg  
--    