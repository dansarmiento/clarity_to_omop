/***************************************************************
 * Query: PULL_OBSERVATION_HOSP_FLOWSHEET
 * Description: Retrieves hospital flowsheet observations with 
 * associated patient and provider information
 ***************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    PATIENT_DRIVER.PERSON_ID                                 AS PERSON_ID,
    IP_FLWSHT_MEAS.RECORDED_TIME::VARCHAR                   AS OBSERVATION_DATE,
    IP_FLWSHT_MEAS.RECORDED_TIME                            AS OBSERVATION_DATETIME,
    NULL                                                     AS VALUE_AS_NUMBER,
    COALESCE(ATTENDING_PROV_ID, HSP_ATND_PROV.PROV_ID)     AS PROVIDER_SOURCE_VALUE,
    NULL                                                     AS UNIT_SOURCE_VALUE,
    NULL                                                     AS QUALIFIER_SOURCE_VALUE,
    NULL                                                     AS VALUE_SOURCE_VALUE,

    -- Additional Fields for Stage
    PAT_ENC_HSP.PAT_ENC_CSN_ID                             AS PULL_CSN_ID,
    IP_FLO_GP_DATA.FLO_MEAS_ID                             AS PULL_FLO_MEAS_ID,
    IP_FLWSHT_MEAS.MEAS_VALUE                              AS PULL_MEAS_VALUE,
    IP_FLO_GP_DATA.CAT_INI                                 AS PULL_CAT_INI,
    IP_FLO_GP_DATA.CAT_ITEM                                AS PULL_CAT_ITEM,
    IP_FLO_GP_DATA.FLO_MEAS_NAME                           AS PULL_FLO_MEAS_NAME

FROM CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC_HSP AS PAT_ENC_HSP

    -- Join to get inpatient data
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_DATA_STORE AS IP_DATA_STORE
        ON PAT_ENC_HSP.PAT_ENC_CSN_ID = IP_DATA_STORE.EPT_CSN

    -- Join to get flowsheet records
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_FLWSHT_REC AS IP_FLWSHT_REC
        ON IP_DATA_STORE.INPATIENT_DATA_ID = IP_FLWSHT_REC.INPATIENT_DATA_ID

    -- Join to get flowsheet measurements
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_FLWSHT_MEAS AS IP_FLWSHT_MEAS
        ON IP_FLWSHT_REC.FSD_ID = IP_FLWSHT_MEAS.FSD_ID

    -- Join to get flowsheet group data
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_FLO_GP_DATA AS IP_FLO_GP_DATA
        ON IP_FLWSHT_MEAS.FLO_MEAS_ID = IP_FLO_GP_DATA.FLO_MEAS_ID

    -- Join to get value type information
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_VAL_TYPE AS ZC_VAL_TYPE
        ON IP_FLO_GP_DATA.VAL_TYPE_C = ZC_VAL_TYPE.VAL_TYPE_C

    -- Join to get hospital account information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.HSP_ACCOUNT AS HSP_ACCOUNT
        ON PAT_ENC_HSP.HSP_ACCOUNT_ID = HSP_ACCOUNT.HSP_ACCOUNT_ID

    -- Join to get attending provider information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.HSP_ATND_PROV AS HSP_ATND_PROV
        ON PAT_ENC_HSP.PAT_ENC_CSN_ID = HSP_ATND_PROV.PAT_ENC_CSN_ID
        AND IP_FLWSHT_MEAS.recorded_time BETWEEN ATTEND_FROM_DATE
            AND COALESCE(ATTEND_TO_DATE, GETDATE())

    -- Join to get patient information
    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS PATIENT_DRIVER
        ON PAT_ENC_HSP.PAT_ID = PATIENT_DRIVER.EHR_PATIENT_ID

WHERE MEAS_VALUE IS NOT NULL;