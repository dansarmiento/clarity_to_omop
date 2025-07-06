{%- set source_relation = source('CLARITY', 'PATIENT') -%}
{{ config(materialized = 'ephemeral') }}
--BEGIN PATIENT_stg
--The PATIENT table contains one record for each patient in your system.
----The data contained in each record consists of demographics, PCP and primary location information, registration information, and other information.
SELECT
	PATIENT.PAT_ID
    ,UPPER(PAT_FIRST_NAME) AS PAT_FIRST_NAME
    ,UPPER(PAT_LAST_NAME)  AS PAT_LAST_NAME
	,BIRTH_DATE
    ,CUR_PCP_PROV_ID
    ,CUR_PRIM_LOC_ID
    ,UPPER(SEX_C) AS SEX_C
    ,UPPER(ADD_LINE_1) AS ADD_LINE_1
    ,UPPER(ADD_LINE_2) AS ADD_LINE_2
    ,UPPER(CITY) AS CITY
    ,UPPER(STATE_C) AS STATE_C
    ,UPPER(COUNTY_C) AS COUNTY_C
    ,ZIP
    ,ETHNIC_GROUP_C
    ,PAT_STATUS_C
    ,DEATH_DATE
    ,UPPER(EMAIL_ADDRESS) AS EMAIL_ADDRESS
    ,HOME_PHONE
FROM
	{{source('CLARITY','PATIENT')}} AS  PATIENT
    INNER JOIN {{source('CLARITY','PATIENT_3')}} AS  PATIENT_3
        ON PATIENT.PAT_ID = PATIENT_3.PAT_ID
    INNER JOIN {{source('CLARITY','VALID_PATIENT')}} AS  VALID_PATIENT
        ON PATIENT.PAT_ID = VALID_PATIENT.PAT_ID

WHERE PATIENT_3.IS_TEST_PAT_YN = 'N'
    AND VALID_PATIENT.IS_VALID_PAT_YN = 'Y'
    AND BIRTH_DATE IS NOT NULL
--END PATIENT_stg
--
