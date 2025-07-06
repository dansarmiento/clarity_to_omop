--PATIENT_DRIVER_wBABY
{{ config(materialized = 'table') }}

SELECT DISTINCT

       SH_OMOP_DB_DEV.OMOP.SEQ_PERSON.NEXTVAL::NUMBER(28,0)  AS PERSON_ID
      ,'CHW'                                                 AS EHR_SOURCE
      ,PATIENT_BABY.PAT_ID                                   AS EHR_PATIENT_ID
    --   , PATIENT_MOM.PAT_ID                                      as mom
    --   ,V_OB_DEL_RECORDS.momID
    --   ,V_OB_DEL_RECORDS.babyID
      ,IDENTITY_ID.IDENTITY_ID::VARCHAR                         AS MRN_CPI
      ,UPPER(PATIENT_BABY.PAT_FIRST_NAME)::VARCHAR               AS FIRST_NAME
      ,UPPER(PATIENT_BABY.PAT_LAST_NAME)::VARCHAR                AS LAST_NAME
      ,UPPER(PATIENT_BABY.BIRTH_DATE)::DATE                      AS DATE_OF_BIRTH
      ,UPPER(ZC_SEX_NAME)::VARCHAR                              AS SEX
      ,PATIENT_BABY.HOME_PHONE::VARCHAR                          AS PHONE
      ,UPPER(COALESCE(CONCAT(PATIENT_BABY.ADD_LINE_1, ' ', PATIENT_BABY.ADD_LINE_2), PATIENT_BABY.ADD_LINE_1))::VARCHAR AS STREET_ADDRESS
      ,UPPER(PATIENT_BABY.CITY)::VARCHAR                         AS CITY
      ,UPPER(ZC_STATE_NAME)::VARCHAR                            AS STATE
      ,PATIENT_BABY.ZIP::VARCHAR                                 AS ZIP
      ,UPPER(PATIENT_BABY.EMAIL_ADDRESS)::VARCHAR                AS EMAIL
      ,CURRENT_DATE()::DATE                                     AS DATE_CREATED
      ,NULL::DATE                                               AS DATE_2
      ,NULL::INTEGER                                            AS FLAG_1
      ,NULL::INTEGER                                            AS FLAG_2

FROM {{ source('CLARITY','PATIENT')}} PATIENT_MOM
      INNER JOIN {{ source('CLARITY','IDENTITY_ID')}} IDENTITY_ID  ON PATIENT_MOM.PAT_ID = IDENTITY_ID.PAT_ID AND IDENTITY_ID.IDENTITY_TYPE_ID = 49
      INNER JOIN {{ ref('ZC_SEX_stg')}} ZC_SEX                     ON PATIENT_MOM.SEX_C = ZC_SEX.RCPT_MEM_SEX_C
      INNER JOIN {{ ref('ZC_STATE_stg')}} ZC_STATE                 ON PATIENT_MOM.STATE_C = ZC_STATE.STATE_C

       INNER JOIN {{ source('OMOP_PROD','AOU_DRIVER_PROD')}} AOU_DRIVER_PROD   ON PATIENT_MOM.PAT_ID = AOU_DRIVER_PROD.EPIC_PAT_ID
       INNER JOIN {{ ref('V_OB_DEL_RECORDS_stg')}} V_OB_DEL_RECORDS             ON AOU_DRIVER_PROD.EPIC_PAT_ID = V_OB_DEL_RECORDS.MOMID
       INNER JOIN  {{ source('CLARITY','PATIENT')}} PATIENT_BABY           ON V_OB_DEL_RECORDS.BABYID = PATIENT_BABY.PAT_ID
