-- =============================================================================
-- PULL_MEASUREMENT_AMB_LOINC
-- Description: Retrieves measurement data for ambulatory visits with LOINC codes
-- =============================================================================

SELECT DISTINCT
    -- Stage Attributes
    -- Fields used for the Stage
    PULL_VISIT_OCCURRENCE_AMB.PERSON_ID,
    CAST(ORDER_PROC_2.SPECIMN_TAKEN_TIME AS DATE) AS MEASUREMENT_DATE,
    ORDER_PROC_2.SPECIMN_TAKEN_TIME AS MEASUREMENT_DATETIME,
    
    -- Determine operator concept ID based on value prefix
    CASE
        WHEN ORDER_RESULTS.ORD_VALUE LIKE '>=%' THEN 4171755
        WHEN ORDER_RESULTS.ORD_VALUE LIKE '<=%' THEN 4171754
        WHEN ORDER_RESULTS.ORD_VALUE LIKE '<%'  THEN 4171756
        WHEN ORDER_RESULTS.ORD_VALUE LIKE '>%'  THEN 4172704
        ELSE 4172703
    END AS OPERATOR_CONCEPT_ID,
    
    -- Clean and format numeric values
    CASE
        WHEN TRY_TO_NUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(
            ORDER_RESULTS.ORD_VALUE, '=', ''), '<', ''), '>', ''), ',', '')) IS NULL
        THEN NULL
        ELSE REPLACE(REPLACE(REPLACE(REPLACE(
            ORDER_RESULTS.ORD_VALUE, '=', ''), '<', ''), '>', ''), ',', '')
    END AS VALUE_AS_NUMBER,
    
    -- Process range low values
    CASE
        WHEN TRY_TO_NUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(
            ORDER_RESULTS.REFERENCE_LOW, '=', ''), '<', ''), '>', ''), ',', '')) IS NULL
        THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(REPLACE(
            ORDER_RESULTS.REFERENCE_LOW, '=', ''), '<', ''), '>', ''), ',', '') AS FLOAT)
    END AS RANGE_LOW,
    
    -- Process range high values
    CASE
        WHEN TRY_TO_NUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(
            ORDER_RESULTS.REFERENCE_HIGH, '=', ''), '<', ''), '>', ''), ',', '')) IS NULL
        THEN NULL
        ELSE CAST(REPLACE(REPLACE(REPLACE(REPLACE(
            ORDER_RESULTS.REFERENCE_HIGH, '=', ''), '<', ''), '>', ''), ',', '') AS FLOAT)
    END AS RANGE_HIGH,
    
    0 AS VISIT_DETAIL_ID,
    LNC_DB_MAIN.LNC_CODE || ':' || LNC_DB_MAIN.LNC_COMPON AS MEASUREMENT_SOURCE_VALUE,
    ORDER_RESULTS.REFERENCE_UNIT AS UNIT_SOURCE_VALUE,
    ORDER_RESULTS.ORD_VALUE AS VALUE_SOURCE_VALUE,
    AUTH_PROVIDER.PROV_ID AS PROVIDER_SOURCE_VALUE,

    -- Additional Attributes
    -- Non-OMOP fields used for the Stage
    PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID AS PULL_CSN_ID,
    LNC_DB_MAIN.LNC_CODE AS PULL_LNC_CODE,
    LNC_DB_MAIN.RECORD_ID AS PULL_RECORD_ID

FROM CARE_RES_OMOP_DEV2_WKSP.OMOP_PULL.PULL_VISIT_OCCURRENCE_AMB AS PULL_VISIT_OCCURRENCE_AMB

    -- Join with ORDER_PROC table
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ORDER_PROC AS ORDER_PROC
        ON PULL_VISIT_OCCURRENCE_AMB.PULL_CSN_ID = ORDER_PROC.PAT_ENC_CSN_ID

    -- Join with ORDER_PROC_2 table
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ORDER_PROC_2 AS ORDER_PROC_2
        ON ORDER_PROC.ORDER_PROC_ID = ORDER_PROC_2.ORDER_PROC_ID

    -- Join with ORDER_RESULTS table
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.ORDER_RESULTS AS ORDER_RESULTS
        ON ORDER_PROC.ORDER_PROC_ID = ORDER_RESULTS.ORDER_PROC_ID

    -- Join with CLARITY_SER table for provider information
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_SER AS AUTH_PROVIDER
        ON ORDER_PROC.AUTHRZING_PROV_ID = AUTH_PROVIDER.PROV_ID

    -- Join with LNC_DB_MAIN table for LOINC codes
    INNER JOIN CARE_BRONZE_CLARITY_PROD.DBO.LNC_DB_MAIN AS LNC_DB_MAIN
        ON ORDER_RESULTS.COMPON_LNC_ID = LNC_DB_MAIN.RECORD_ID

    -- Join with ZC_RESULT_FLAG table
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_RESULT_FLAG AS ZC_RESULT_FLAG
        ON ORDER_RESULTS.RESULT_FLAG_C = ZC_RESULT_FLAG.RESULT_FLAG_C

    -- Join with ZC_RESULT_STATUS table
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_RESULT_STATUS AS ZC_RESULT_STATUS
        ON ORDER_RESULTS.RESULT_STATUS_C = ZC_RESULT_STATUS.RESULT_STATUS_C

    -- Join with ZC_ORDER_STATUS table
    LEFT JOIN CARE_BRONZE_CLARITY_PROD.DBO.ZC_ORDER_STATUS AS ZC_ORDER_STATUS
        ON ORDER_PROC.ORDER_STATUS_C = ZC_ORDER_STATUS.ORDER_STATUS_C

WHERE PULL_VISIT_OCCURRENCE_AMB.PULL_ENC_TYPE_C <> 3
    AND ZC_ORDER_STATUS.NAME <> 'Canceled'
    AND ORDER_PROC_2.SPECIMN_TAKEN_TIME IS NOT NULL;