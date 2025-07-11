--------------------------------
-- PULL_DRUG_EXPOSURE_ANES_RXNORM
--------------------------------
/*
Description: This query retrieves drug exposure data from anesthesia records with RxNorm codes
Author: [Author Name]
Created: [Date]
Modified: [Date]

Dependencies:
- PULL_VISIT_OCCURRENCE_HSP
- Various CLARITY tables related to medication administration and anesthesia

Notes:
- Filters for MAR_ACTION_C = 1 (administered medications)
- Excludes RXNORM_TERM_TYPE_C = 2 (precise ingredients)
*/

SELECT DISTINCT 
    -- OMOP Standard Fields
    PULL_VISIT_OCCURRENCE_HSP.PERSON_ID                         AS PERSON_ID,
    MAR_ADMIN_INFO.TAKEN_TIME::DATE                            AS DRUG_EXPOSURE_START_DATE,
    MAR_ADMIN_INFO.TAKEN_TIME                                  AS DRUG_EXPOSURE_START_DATETIME,
    CAST(
        CASE
            WHEN (COALESCE(F_AN_RECORD_SUMMARY.AN_STOP_DATETIME, TAKEN_TIME)::DATE = TAKEN_TIME::DATE)
                AND (COALESCE(F_AN_RECORD_SUMMARY.AN_STOP_DATETIME, TAKEN_TIME) < TAKEN_TIME)
                THEN TAKEN_TIME
            ELSE COALESCE(F_AN_RECORD_SUMMARY.AN_STOP_DATETIME, TAKEN_TIME)
        END AS DATE
    )                                                          AS DRUG_EXPOSURE_END_DATE,
    CASE
        WHEN (COALESCE(F_AN_RECORD_SUMMARY.AN_STOP_DATETIME, TAKEN_TIME)::DATE = TAKEN_TIME::DATE)
            AND (COALESCE(F_AN_RECORD_SUMMARY.AN_STOP_DATETIME, TAKEN_TIME) < TAKEN_TIME)
            THEN TAKEN_TIME
        ELSE COALESCE(F_AN_RECORD_SUMMARY.AN_STOP_DATETIME, TAKEN_TIME)
    END                                                        AS DRUG_EXPOSURE_END_DATETIME,
    F_AN_RECORD_SUMMARY.AN_STOP_DATETIME                       AS VERBATIM_END_DATE,
    LEFT(ZC_RSN_FOR_DISCON.NAME, 20)                          AS STOP_REASON,
    NULL                                                       AS REFILLS,
    CASE
        WHEN TRY_TO_NUMERIC(LEFT(QUANTITY, CHARINDEX(' ', QUANTITY))) IS NULL
            THEN 1
        ELSE LEFT(QUANTITY, CHARINDEX(' ', QUANTITY))::FLOAT
    END                                                        AS QUANTITY,
    NULL                                                       AS DAYS_SUPPLY,
    MAR_ADMIN_INFO.SIG                                        AS SIG,
    NULL                                                       AS LOT_NUMBER,
    COALESCE(
        F_AN_RECORD_SUMMARY.AN_RESP_PROV_ID,
        ORDER_MED.AUTHRZING_PROV_ID
    )                                                          AS PROVIDER_SOURCE_VALUE,
    0                                                          AS VISIT_DETAIL_ID,
    DOSE_UNIT.NAME                                            AS DOSE_UNIT_SOURCE_VALUE,
    'DRUG_EXPOSURE--CLARITYANES--RXNORM'                      AS ETL_MODULE,

    -- Additional Attributes
    PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID                     AS PULL_CSN_ID,
    CLARITY_MEDICATION.MEDICATION_ID                           AS PULL_MEDICATION_ID,
    CLARITY_MEDICATION.NAME                                    AS PULL_MEDICATION_NAME,
    MAR_ADMIN_INFO.ROUTE_C                                    AS PULL_MED_ROUTE_C,
    ZC_ADMIN_ROUTE.NAME                                       AS PULL_ZC_ADMIN_ROUTE_NAME,
    RXNORM_CODES.RXNORM_CODE                                  AS PULL_RXNORM_CODE,
    RXNORM_CODES.LINE                                         AS PULL_RXNORM_CODES_LINE

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_HSP AS PULL_VISIT_OCCURRENCE_HSP

-- Join to link anesthesia record to hospital encounter
INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.AN_HSB_LINK_INFO AS AN_HSB_LINK_INFO
    ON AN_HSB_LINK_INFO.AN_BILLING_CSN_ID = PULL_VISIT_OCCURRENCE_HSP.PULL_CSN_ID

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.F_AN_RECORD_SUMMARY AS F_AN_RECORD_SUMMARY
    ON F_AN_RECORD_SUMMARY.AN_EPISODE_ID = AN_HSB_LINK_INFO.SUMMARY_BLOCK_ID

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.MAR_ADMIN_INFO AS MAR_ADMIN_INFO
    ON F_AN_RECORD_SUMMARY.AN_52_ENC_CSN_ID = MAR_ADMIN_INFO.MAR_ENC_CSN

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ORDER_MED AS ORDER_MED
    ON ORDER_MED.ORDER_MED_ID = MAR_ADMIN_INFO.ORDER_MED_ID

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_MEDICATION AS CLARITY_MEDICATION
    ON ORDER_MED.MEDICATION_ID = CLARITY_MEDICATION.MEDICATION_ID

LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_RSN_FOR_DISCON AS ZC_RSN_FOR_DISCON
    ON ORDER_MED.RSN_FOR_DISCON_C = ZC_RSN_FOR_DISCON.RSN_FOR_DISCON_C

LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_ADMIN_ROUTE AS ZC_ADMIN_ROUTE
    ON MAR_ADMIN_INFO.ROUTE_C = ZC_ADMIN_ROUTE.MED_ROUTE_C

LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_MED_UNIT AS INF_RATE
    ON MAR_ADMIN_INFO.MAR_INF_RATE_UNIT_C = INF_RATE.DISP_QTYUNIT_C

LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_MED_UNIT AS DOSE_UNIT
    ON MAR_ADMIN_INFO.DOSE_UNIT_C = DOSE_UNIT.DISP_QTYUNIT_C

LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_MAR_RSLT AS ZC_MAR_RSLT
    ON MAR_ADMIN_INFO.MAR_ACTION_C = ZC_MAR_RSLT.RESULT_C

LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_MAR_RSN AS ZC_MAR_RSN
    ON MAR_ADMIN_INFO.REASON_C = ZC_MAR_RSN.REASON_C

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.RXNORM_CODES AS RXNORM_CODES
    ON ORDER_MED.MEDICATION_ID = RXNORM_CODES.MEDICATION_ID

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_RXNORM_TERM_TYPE AS ZC_RXNORM_TERM_TYPE
    ON RXNORM_CODES.RXNORM_TERM_TYPE_C = ZC_RXNORM_TERM_TYPE.RXNORM_TERM_TYPE_C

WHERE MAR_ACTION_C = 1
    AND RXNORM_CODES.RXNORM_TERM_TYPE_C <> 2  -- Exclude precise ingredients