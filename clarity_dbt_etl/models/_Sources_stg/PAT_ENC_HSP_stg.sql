{%- set source_relation = source('CLARITY', 'PAT_ENC_HSP') -%}

{{ config(materialized = 'ephemeral') }}
--BEGIN PAT_ENC_HSP_stg
--This table is the primary table for hospital encounter information. 
-- A hospital encounter is a contact in the patient record created through an ADT workflow 
-- such as preadmission, admission, ED Arrival, discharge, and hospital outpatient visit (HOV) contacts.
SELECT
	PAT_ENC_CSN_ID
	,PAT_ID
    ,CONTACT_DATE
    ,HOSP_ADMSN_TYPE_C
    ,ADT_PAT_CLASS_C
    ,ADT_PATIENT_STAT_C
    ,HSP_ACCOUNT_ID
    ,ADMIT_SOURCE_C
    ,DISCH_DISP_C
    ,ED_DISPOSITION_C
    ,HOSP_ADMSN_TIME
    ,INP_ADM_DATE
    ,EXP_ADMISSION_TIME
    ,OP_ADM_DATE
    ,EMER_ADM_DATE
    ,INSTANT_OF_ENTRY_TM
    ,ED_DISP_TIME
    ,HOSP_DISCH_TIME
    ,HOSPITAL_AREA_ID
    ,DEPARTMENT_ID
    ,INPATIENT_DATA_ID
    ,IP_EPISODE_ID
    ,ED_EPISODE_ID
    ,BILL_ATTEND_PROV_ID   
FROM
	{{source('CLARITY','PAT_ENC_HSP')}} AS  PAT_ENC_HSP
--END PAT_ENC_HSP_stg
-- 