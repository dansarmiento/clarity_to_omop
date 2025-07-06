/*******************************************************************************
* Query: PULL_DEVICE_EXPOSURE_HOSP_LDA
* Description: Retrieves device exposure data for hospital LDA (Line, Drain, Airway)
* measurements, including placement and removal information.
*******************************************************************************/

SELECT
    -- OMOP Standard Fields
    PULL_VISIT_OCCURRENCE_HSP.PERSON_ID                  AS PERSON_ID,
    IP_LDA_NOADDSINGLE.PLACEMENT_INSTANT::DATE          AS DEVICE_EXPOSURE_START_DATE,
    IP_LDA_NOADDSINGLE.PLACEMENT_INSTANT                AS DEVICE_EXPOSURE_START_DATETIME,
    IP_LDA_NOADDSINGLE.REMOVAL_INSTANT::DATE           AS DEVICE_EXPOSURE_END_DATE,
    IP_LDA_NOADDSINGLE.REMOVAL_INSTANT                 AS DEVICE_EXPOSURE_END_DATETIME,
    NULL                                                AS UNIQUE_DEVICE_ID,
    NULL                                                AS PRODUCTION_ID,        -- NEW 5.4
    NULL                                                AS QUANTITY,
    PULL_PROVIDER_SOURCE_VALUE                          AS PROVIDER_SOURCE_VALUE,
    0                                                   AS VISIT_DETAIL_ID,     -- Default value
    IP_LDA_NOADDSINGLE.FLO_MEAS_ID::VARCHAR 
        || ':' || IP_FLO_GP_DATA.FLO_MEAS_NAME         AS DEVICE_SOURCE_VALUE,
    NULL                                                AS UNIT_SOURCE_VALUE,   -- NEW 5.4

    -- Additional Fields for Stage
    PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID              AS PULL_CSN_ID,
    IP_LDA_NOADDSINGLE.FLO_MEAS_ID::VARCHAR           AS PULL_FLO_MEAS_ID,
    IP_FLO_GP_DATA.FLO_MEAS_NAME                      AS PULL_FLO_MEAS_NAME

FROM 
    CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_HSP AS PULL_VISIT_OCCURRENCE_HSP

    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_LDA_NOADDSINGLE AS IP_LDA_NOADDSINGLE
        ON (PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID = IP_LDA_NOADDSINGLE.PAT_ENC_CSN_ID)

    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.IP_FLO_GP_DATA AS IP_FLO_GP_DATA
        ON IP_LDA_NOADDSINGLE.FLO_MEAS_ID = IP_FLO_GP_DATA.FLO_MEAS_ID

WHERE 
    IP_LDA_NOADDSINGLE.PLACEMENT_INSTANT IS NOT NULL;