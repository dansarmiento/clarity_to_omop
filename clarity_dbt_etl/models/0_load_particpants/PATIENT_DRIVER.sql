--PATIENT_DRIVER
{{ config(materialized = 'table') }}

WITH Patient_List as (
SELECT DISTINCT

       SH_OMOP_DB_DEV.OMOP.SEQ_PERSON.NEXTVAL::NUMBER(28,0)  AS PERSON_ID
      ,'CHW'                                                 AS EHR_SOURCE
      ,PATIENT.PAT_ID::VARCHAR                              AS EHR_PATIENT_ID
      ,IDENTITY_ID.IDENTITY_ID::VARCHAR                     AS MRN_CPI
      ,UPPER(PATIENT.PAT_FIRST_NAME)::VARCHAR               AS FIRST_NAME
      ,UPPER(PATIENT.PAT_LAST_NAME)::VARCHAR                AS LAST_NAME
      ,UPPER(PATIENT.BIRTH_DATE)::DATE                      AS DATE_OF_BIRTH
      ,UPPER(ZC_SEX_NAME)::VARCHAR                          AS SEX
      ,PATIENT.HOME_PHONE::VARCHAR                          AS PHONE
      ,UPPER(COALESCE(CONCAT(PATIENT.ADD_LINE_1, ' ', PATIENT.ADD_LINE_2), PATIENT.ADD_LINE_1))::VARCHAR AS STREET_ADDRESS
      ,UPPER(PATIENT.CITY)::VARCHAR                         AS CITY
      ,UPPER(ZC_STATE_NAME)::VARCHAR                        AS STATE
      ,PATIENT.ZIP::VARCHAR                                 AS ZIP
      ,UPPER(PATIENT.EMAIL_ADDRESS)::VARCHAR                AS EMAIL
      ,CURRENT_DATE()::DATE                                 AS DATE_CREATED
      ,NULL::DATE                                           AS DATE_2
      ,NULL::INTEGER                                        AS FLAG_1
      ,NULL::INTEGER                                        AS FLAG_2

FROM {{ ref('PATIENT_stg')}} PATIENT
      INNER JOIN {{ source('CLARITY','IDENTITY_ID')}} IDENTITY_ID  ON PATIENT.PAT_ID = IDENTITY_ID.PAT_ID AND IDENTITY_ID.IDENTITY_TYPE_ID = 49
      INNER JOIN {{ ref('ZC_SEX_stg')}} ZC_SEX                     ON PATIENT.SEX_C = ZC_SEX.RCPT_MEM_SEX_C
      INNER JOIN {{ ref('ZC_STATE_stg')}} ZC_STATE                 ON PATIENT.STATE_C = ZC_STATE.STATE_C

-- --      uncomment one of the following
       INNER JOIN {{ source('OMOP_PROD','AOU_DRIVER_PROD')}} AOU_DRIVER_PROD   ON PATIENT.PAT_ID = AOU_DRIVER_PROD.EPIC_PAT_ID
--         ---- add babies for AoU Participants
--             UNION ALL
--             SELECT * from {{ref('PATIENTS_AOU_BABY')}} AS PATIENTS_AOU_BABY

    --    INNER JOIN {{ref('PATIENTS_100K')}} AS PATIENTS_100K    ON PATIENT.PAT_ID = PATIENTS_100K.EPIC_PAT_ID
    --   INNER JOIN {{ref('PATIENTS_1M')}} AS PATIENTS_1M    ON PATIENT.PAT_ID = PATIENTS_1M.EPIC_PAT_ID
)

SELECT * from Patient_List AS Patient_List


