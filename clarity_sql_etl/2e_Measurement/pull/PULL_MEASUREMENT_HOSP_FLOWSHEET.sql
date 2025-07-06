/*******************************************************************************
* Script Name: PULL_MEASUREMENT_HOSP_FLOWSHEET
* Description: Retrieves measurement data from hospital flowsheets with associated
*              patient, visit, and provider information.
* 
* Tables Used:
*   - PULL_VISIT_OCCURRENCE_HSP
*   - IP_DATA_STORE
*   - IP_FLWSHT_REC
*   - IP_FLWSHT_MEAS
*   - IP_FLO_GP_DATA
*   - ZC_VAL_TYPE
*   - HSP_ACCOUNT
*   - HSP_ATND_PROV
*******************************************************************************/

SELECT
    -- Stage Attributes
    PULL_VISIT_OCCURRENCE_HSP.PERSON_ID               AS PERSON_ID,
    IP_FLWSHT_MEAS.RECORDED_TIME::DATE                AS MEASUREMENT_DATE,
    IP_FLWSHT_MEAS.RECORDED_TIME                      AS MEASUREMENT_DATETIME,
    
    -- Determine operator concept based on measurement value format
    CASE
        WHEN IP_FLWSHT_MEAS.MEAS_VALUE LIKE '>=%'  THEN 4171755  -- Greater than or equal
        WHEN IP_FLWSHT_MEAS.MEAS_VALUE LIKE '<=%'  THEN 4171754  -- Less than or equal
        WHEN IP_FLWSHT_MEAS.MEAS_VALUE LIKE '<%'   THEN 4171756  -- Less than
        WHEN IP_FLWSHT_MEAS.MEAS_VALUE LIKE '>%'   THEN 4172704  -- Greater than
        ELSE 4172703                                              -- Equal
    END                                                AS OPERATOR_CONCEPT_ID,
    
    -- Clean measurement value by removing operators
    REPLACE(
        REPLACE(
            REPLACE(IP_FLWSHT_MEAS.MEAS_VALUE, '=', ''),
            '<', ''
        ),
        '>', ''
    )                                                  AS VALUE_AS_NUMBER,
    
    -- Range and unit information
    IP_FLO_GP_DATA.MINVALUE                            AS RANGE_LOW,
    IP_FLO_GP_DATA.MAX_VAL                             AS RANGE_HIGH,
    IP_FLO_GP_DATA.UNITS                               AS UNIT_SOURCE_VALUE,
    IP_FLWSHT_MEAS.MEAS_VALUE                          AS VALUE_SOURCE_VALUE,
    PULL_PROVIDER_SOURCE_VALUE                         AS PROVIDER_SOURCE_VALUE,

    -- Additional attributes (Non-OMOP fields)
    PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID               AS PULL_CSN_ID,
    IP_FLO_GP_DATA.FLO_MEAS_ID                          AS PULL_FLO_MEAS_ID,
    IP_FLO_GP_DATA.FLO_MEAS_NAME                        AS PULL_FLO_MEAS_NAME

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_HSP AS PULL_VISIT_OCCURRENCE_HSP

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_DATA_STORE AS IP_DATA_STORE
        ON PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = IP_DATA_STORE.EPT_CSN

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_FLWSHT_REC AS IP_FLWSHT_REC
        ON IP_DATA_STORE.INPATIENT_DATA_ID = IP_FLWSHT_REC.INPATIENT_DATA_ID

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_FLWSHT_MEAS AS IP_FLWSHT_MEAS
        ON IP_FLWSHT_REC.FSD_ID = IP_FLWSHT_MEAS.FSD_ID

    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_FLO_GP_DATA AS IP_FLO_GP_DATA
        ON IP_FLWSHT_MEAS.FLO_MEAS_ID = IP_FLO_GP_DATA.FLO_MEAS_ID

    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_VAL_TYPE AS ZC_VAL_TYPE
        ON IP_FLO_GP_DATA.VAL_TYPE_C = ZC_VAL_TYPE.VAL_TYPE_C

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.HSP_ACCOUNT AS HSP_ACCOUNT
        ON PULL_VISIT_OCCURRENCE_HSP.PULL_HSP_ACCOUNT_ID = HSP_ACCOUNT.HSP_ACCOUNT_ID

    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.HSP_ATND_PROV AS HSP_ATND_PROV
        ON PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = HSP_ATND_PROV.PAT_ENC_CSN_ID
        AND IP_FLWSHT_MEAS.RECORDED_TIME BETWEEN ATTEND_FROM_DATE
            AND COALESCE(ATTEND_TO_DATE, GETDATE());