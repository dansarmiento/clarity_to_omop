/*******************************************************************************
* Script Name: PULL_DRUG_EXPOSURE_AMB_RXNORM
* Description: Retrieves drug exposure data for ambulatory visits with RxNorm codes
* 
* Tables Used:
*   - PULL_VISIT_OCCURRENCE_AMB
*   - ORDER_MED
*   - CLARITY_MEDICATION
*   - RXNORM_CODES
*   - ZC_MED_UNIT
*   - ZC_RSN_FOR_DISCON
*   - ZC_ADMIN_ROUTE
*   - ZC_RXNORM_TERM_TYPE
*******************************************************************************/

SELECT DISTINCT
    -- OMOP Standard Fields
    PULL_VISIT_OCCURRENCE_AMB.PERSON_ID                          AS PERSON_ID,
    ORDER_START_TIME::DATE                                       AS DRUG_EXPOSURE_START_DATE,
    ORDER_START_TIME                                             AS DRUG_EXPOSURE_START_DATETIME,
    
    -- Calculate Drug Exposure End Date
    CAST(
        CASE
            WHEN (COALESCE(ORDER_END_TIME, ORDER_START_TIME)::DATE = ORDER_START_TIME::DATE)
                AND (COALESCE(ORDER_END_TIME, ORDER_START_TIME) < ORDER_START_TIME)
                THEN ORDER_START_TIME
            ELSE COALESCE(ORDER_END_TIME, ORDER_START_TIME)
        END AS DATE
    )                                                           AS DRUG_EXPOSURE_END_DATE,
    
    -- Calculate Drug Exposure End Datetime
    CASE
        WHEN (COALESCE(ORDER_END_TIME, ORDER_START_TIME)::DATE = ORDER_START_TIME::DATE)
            AND (COALESCE(ORDER_END_TIME, ORDER_START_TIME) < ORDER_START_TIME)
            THEN ORDER_START_TIME
        ELSE COALESCE(ORDER_END_TIME, ORDER_START_TIME)
    END                                                         AS DRUG_EXPOSURE_END_DATETIME,
    
    END_DATE                                                    AS VERBATIM_END_DATE,
    LEFT(ZC_RSN_FOR_DISCON.NAME, 20)                           AS STOP_REASON,
    
    -- Handle Refills
    CASE
        WHEN TRY_CAST(REFILLS AS NUMERIC) IS NULL THEN NULL
        ELSE REFILLS
    END                                                         AS REFILLS,
    
    -- Calculate Quantity
    CASE
        WHEN TRY_TO_NUMERIC(LEFT(QUANTITY, CHARINDEX(' ', QUANTITY))) IS NULL
            OR UPPER(ZC_MED_UNIT.NAME) = 'APPLICATION'
            THEN 1
        ELSE LEFT(QUANTITY, CHARINDEX(' ', QUANTITY))::FLOAT
    END                                                         AS QUANTITY,
    
    NULL                                                        AS DAYS_SUPPLY,
    SIG                                                         AS SIG,
    NULL                                                        AS LOT_NUMBER,
    ORDER_MED.AUTHRZING_PROV_ID                                AS PROVIDER_SOURCE_VALUE,
    ZC_MED_UNIT.NAME                                           AS DOSE_UNIT_SOURCE_VALUE,

    -- Additional Non-OMOP Fields
    PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID                      AS PULL_CSN_ID,
    CLARITY_MEDICATION.MEDICATION_ID                           AS PULL_MEDICATION_ID,
    CLARITY_MEDICATION.NAME                                    AS PULL_MEDICATION_NAME,
    ORDER_MED.MED_ROUTE_C                                     AS PULL_MED_ROUTE_C,
    ZC_ADMIN_ROUTE.NAME                                       AS PULL_ZC_ADMIN_ROUTE_NAME,
    RXNORM_CODES.RXNORM_CODE                                 AS PULL_RXNORM_CODE,
    RXNORM_CODES.LINE                                        AS PULL_RXNORM_CODES_LINE

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_AMB AS PULL_VISIT_OCCURRENCE_AMB

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ORDER_MED AS ORDER_MED
    ON ORDER_MED.PAT_ENC_CSN_ID = PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_MEDICATION AS CLARITY_MEDICATION
    ON ORDER_MED.MEDICATION_ID = CLARITY_MEDICATION.MEDICATION_ID

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.RXNORM_CODES AS RXNORM_CODES
    ON ORDER_MED.MEDICATION_ID = RXNORM_CODES.MEDICATION_ID

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_MED_UNIT AS ZC_MED_UNIT
    ON ORDER_MED.HV_DOSE_UNIT_C = ZC_MED_UNIT.DISP_QTYUNIT_C

LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_RSN_FOR_DISCON AS ZC_RSN_FOR_DISCON
    ON ORDER_MED.RSN_FOR_DISCON_C = ZC_RSN_FOR_DISCON.RSN_FOR_DISCON_C

LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_ADMIN_ROUTE AS ZC_ADMIN_ROUTE
    ON ORDER_MED.MED_ROUTE_C = ZC_ADMIN_ROUTE.MED_ROUTE_C

INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_RXNORM_TERM_TYPE AS ZC_RXNORM_TERM_TYPE
    ON RXNORM_CODES.RXNORM_TERM_TYPE_C = ZC_RXNORM_TERM_TYPE.RXNORM_TERM_TYPE_C

WHERE ORDER_MED.ORDER_START_TIME IS NOT NULL
    AND PULL_VISIT_OCCURRENCE_AMB.PULL_ENC_TYPE_C <> 3
    AND ORDER_STATUS_C NOT IN (
        4,  -- CANCELED
        6,  -- HOLDING
        7,  -- DENIED
        8,  -- SUSPEND
        9   -- DISCONTINUED
    )
    AND RXNORM_CODES.RXNORM_TERM_TYPE_C <> 2  -- Exclude PRECISE INGREDIENT
;