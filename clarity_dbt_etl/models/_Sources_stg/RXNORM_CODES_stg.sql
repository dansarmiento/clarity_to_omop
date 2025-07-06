{%- set source_relation = source('CLARITY', 'RXNORM_CODES') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN RXNORM_CODES_stg
--This table contains the RxNorm code for the medications.
SELECT MEDICATION_ID||LINE AS MEDICATION_ID_LINE_PK 
	,MEDICATION_ID
    ,LINE
    ,UPPER(RXNORM_CODE) AS RXNORM_CODE
	,RXNORM_TERM_TYPE_C
FROM
	{{source('CLARITY','RXNORM_CODES')}} AS  RXNORM_CODES
--END RXNORM_CODES_stg   
--   