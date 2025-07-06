/*******************************************************************************
* Script Name: PULL_OBSERVATION_AMB_FLOWSHEET
* Description: Retrieves ambulatory flowsheet observations with associated patient 
*              and encounter information
* 
* Tables Used:
*   - PAT_ENC (Patient Encounters)
*   - IP_DATA_STORE (Inpatient Data Store)
*   - IP_FLWSHT_REC (Flowsheet Records)
*   - IP_FLWSHT_MEAS (Flowsheet Measurements)
*   - IP_FLO_GP_DATA (Flowsheet Group Data)
*   - ZC_VAL_TYPE (Value Type Reference)
*   - PATIENT_DRIVER (Patient Information)
*******************************************************************************/

SELECT 
    -- OMOP Standard Fields
    PATIENT_DRIVER.PERSON_ID                               AS PERSON_ID,
    IP_FLWSHT_MEAS.RECORDED_TIME::VARCHAR                 AS OBSERVATION_DATE,
    IP_FLWSHT_MEAS.RECORDED_TIME                          AS OBSERVATION_DATETIME,
    NULL                                                   AS VALUE_AS_NUMBER,
    COALESCE(VISIT_PROV_ID, PCP_PROV_ID)                 AS PROVIDER_SOURCE_VALUE,
    NULL                                                   AS UNIT_SOURCE_VALUE,
    NULL                                                   AS QUALIFIER_SOURCE_VALUE,
    NULL                                                   AS VALUE_SOURCE_VALUE,

    -- Additional Attributes
    PAT_ENC.PAT_ENC_CSN_ID                               AS PULL_CSN_ID,
    IP_FLO_GP_DATA.FLO_MEAS_ID                           AS PULL_FLO_MEAS_ID,
    IP_FLWSHT_MEAS.MEAS_VALUE                            AS PULL_MEAS_VALUE,
    IP_FLO_GP_DATA.CAT_INI                               AS PULL_CAT_INI,
    IP_FLO_GP_DATA.CAT_ITEM                              AS PULL_CAT_ITEM,
    IP_FLO_GP_DATA.FLO_MEAS_NAME                         AS PULL_FLO_MEAS_NAME

FROM CARE_BRONZE_CLARITY_PROD.DBO.PAT_ENC AS PAT_ENC
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_DATA_STORE AS IP_DATA_STORE
        ON PAT_ENC.PAT_ENC_CSN_ID = IP_DATA_STORE.EPT_CSN

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_FLWSHT_REC AS IP_FLWSHT_REC
        ON IP_DATA_STORE.INPATIENT_DATA_ID = IP_FLWSHT_REC.INPATIENT_DATA_ID

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_FLWSHT_MEAS AS IP_FLWSHT_MEAS
        ON IP_FLWSHT_REC.FSD_ID = IP_FLWSHT_MEAS.FSD_ID

    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_FLO_GP_DATA AS IP_FLO_GP_DATA
        ON IP_FLWSHT_MEAS.FLO_MEAS_ID = IP_FLO_GP_DATA.FLO_MEAS_ID

    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_VAL_TYPE AS ZC_VAL_TYPE
        ON IP_FLO_GP_DATA.VAL_TYPE_C = ZC_VAL_TYPE.VAL_TYPE_C

    INNER JOIN CARE_RES_OMOP_DEV2_WKSP.OMOP.PATIENT_DRIVER AS PATIENT_DRIVER
        ON PATIENT_DRIVER.EHR_PATIENT_ID = PAT_ENC.PAT_ID

WHERE PAT_ENC.ENC_TYPE_C <> 3 
    AND IP_FLWSHT_MEAS.MEAS_VALUE IS NOT NULL;