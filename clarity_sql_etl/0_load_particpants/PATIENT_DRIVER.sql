/*******************************************************************************
* PATIENT_DRIVER
* 
* Description: Creates a list of patients with demographic information and assigns
*              unique person IDs for OMOP conversion
*
* Source Tables:
*   - CARE_BRONZE_CLARITY_PROD.DBO.PATIENT
*   - CARE_BRONZE_CLARITY_PROD.DBO.IDENTITY_ID
*   - CARE_BRONZE_CLARITY_PROD.DBO.ZC_SEX
*   - CARE_BRONZE_CLARITY_PROD.DBO.ZC_STATE
*   - SH_OMOP_DB_PROD.OMOP.AOU_DRIVER_PROD
*******************************************************************************/

WITH Patient_List AS (
    SELECT DISTINCT
        SH_OMOP_DB_DEV.OMOP.SEQ_PERSON.NEXTVAL::NUMBER(28,0)  AS PERSON_ID,
        'CHW'                                                  AS EHR_SOURCE,
        PATIENT.PAT_ID::VARCHAR                               AS EHR_PATIENT_ID,
        IDENTITY_ID.IDENTITY_ID::VARCHAR                      AS MRN_CPI,
        UPPER(PATIENT.PAT_FIRST_NAME)::VARCHAR                AS FIRST_NAME,
        UPPER(PATIENT.PAT_LAST_NAME)::VARCHAR                 AS LAST_NAME,
        UPPER(PATIENT.BIRTH_DATE)::DATE                       AS DATE_OF_BIRTH,
        UPPER(ZC_SEX.NAME)::VARCHAR                           AS SEX,
        PATIENT.HOME_PHONE::VARCHAR                           AS PHONE,
        UPPER(COALESCE(
            CONCAT(PATIENT.ADD_LINE_1, ' ', PATIENT.ADD_LINE_2), 
            PATIENT.ADD_LINE_1
        ))::VARCHAR                                           AS STREET_ADDRESS,
        UPPER(PATIENT.CITY)::VARCHAR                          AS CITY,
        UPPER(ZC_STATE.NAME)::VARCHAR                         AS STATE,
        PATIENT.ZIP::VARCHAR                                  AS ZIP,
        UPPER(PATIENT.EMAIL_ADDRESS)::VARCHAR                 AS EMAIL,
        CURRENT_DATE()::DATE                                  AS DATE_CREATED,
        NULL::DATE                                            AS DATE_2,
        NULL::INTEGER                                         AS FLAG_1,
        NULL::INTEGER                                         AS FLAG_2

    FROM CARE_BRONZE_CLARITY_PROD.DBO.PATIENT PATIENT
        INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.IDENTITY_ID IDENTITY_ID
            ON PATIENT.PAT_ID = IDENTITY_ID.PAT_ID 
            AND IDENTITY_ID.IDENTITY_TYPE_ID = 49
        INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_SEX ZC_SEX
            ON PATIENT.SEX_C = ZC_SEX.RCPT_MEM_SEX_C
        INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_STATE ZC_STATE
            ON PATIENT.STATE_C = ZC_STATE.STATE_C
        INNER JOIN SH_OMOP_DB_PROD.OMOP.AOU_DRIVER_PROD AOU_DRIVER_PROD
            ON PATIENT.PAT_ID = AOU_DRIVER_PROD.EPIC_PAT_ID

        /* Alternative joins (commented out):
        -- For including AoU babies:
        UNION ALL
        SELECT * from CARE_RES_OMOP_GEN_WKSP.OMOP.PATIENTS_AOU_BABY AS PATIENTS_AOU_BABY

        -- For 100K patients:
        INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.PATIENTS_100K AS PATIENTS_100K
            ON PATIENT.PAT_ID = PATIENTS_100K.EPIC_PAT_ID

        -- For 1M patients:
        INNER JOIN CARE_RES_OMOP_GEN_WKSP.OMOP.PATIENTS_1M AS PATIENTS_1M
            ON PATIENT.PAT_ID = PATIENTS_1M.EPIC_PAT_ID
        */
)

SELECT * 
FROM Patient_List AS Patient_List;