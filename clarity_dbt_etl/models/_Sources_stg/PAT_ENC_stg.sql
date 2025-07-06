{%- set source_relation = source('CLARITY', 'PAT_ENC') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN PAT_ENC_stg
--The patient encounter table contains one record for each patient encounter in your system. 
-- By default, this table does not contain Registration or PCP/Clinic Change contacts (encounter types 1 and 31). 
-- It does contain all appointments, office visits, telephone encounters, and other types of encounters. 
-- The primary key for the patient encounter table is PAT_ENC_CSN_ID.
SELECT
	PAT_ENC_CSN_ID
	,UPPER(PAT_ID) AS PAT_ID
    ,DEPARTMENT_ID AS DEPARTMENT_ID
    ,PRIMARY_LOC_ID
    ,UPPER(VISIT_PROV_ID) AS VISIT_PROV_ID
    ,UPPER(PCP_PROV_ID) AS PCP_PROV_ID
    ,ENC_TYPE_C
    ,CALCULATED_ENC_STAT_C
    ,APPT_STATUS_C
    ,CHECKIN_TIME
    ,APPT_TIME
    ,ENC_INSTANT
    ,CONTACT_DATE
    ,CHECKOUT_TIME
    ,ENC_CLOSE_TIME
    ,ACCOUNT_ID
    ,HSP_ACCOUNT_ID
    ,INPATIENT_DATA_ID
    ,APPT_PRC_ID
FROM
	{{source('CLARITY','PAT_ENC')}} AS  PAT_ENC
--END PAT_ENC_stg
--      