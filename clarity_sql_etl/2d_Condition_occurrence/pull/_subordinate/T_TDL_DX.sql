/*
Purpose: This query retrieves distinct diagnosis information from CLARITY_TDL_TRAN table
         by combining diagnoses from multiple diagnosis fields (ONE through SIX).
         It includes service dates, patient information, and provider details.

Tables: CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_TDL_TRAN

Output: Consolidated diagnosis records with date ranges and associated patient information
*/

SELECT DISTINCT
    T_UNION_CLARITY_TDL_TRAN.DX_ID,                    -- Diagnosis ID
    MAX(T_UNION_CLARITY_TDL_TRAN.P_DX) AS P_DX,       -- Primary Diagnosis indicator
    MIN(ORIG_SERVICE_DATE) AS START_DATE,              -- First service date
    MAX(ORIG_SERVICE_DATE) AS END_DATE,                -- Last service date
    MIN(TYPE) AS TYPE,                                 -- Transaction type
    INT_PAT_ID,                                        -- Internal patient ID
    PAT_ENC_CSN_ID,                                   -- Patient encounter CSN ID
    MIN(TDL_ID) AS TDL_ID,                            -- Transaction ID
    MAX(MATCH_PROV_ID) AS MATCH_PROV_ID               -- Provider ID
FROM (
    -- Combine all diagnosis fields using UNION
    SELECT 
        DX_ONE_ID AS DX_ID, 
        'Y' AS P_DX,                                   -- Mark as primary diagnosis
        ORIG_SERVICE_DATE, 
        TYPE, 
        INT_PAT_ID, 
        PAT_ENC_CSN_ID, 
        TDL_ID, 
        MATCH_PROV_ID
    FROM CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_TDL_TRAN AS cd
    
    UNION
    
    SELECT 
        DX_TWO_ID AS DX_ID, 
        'N' AS P_DX,                                   -- Mark as secondary diagnosis
        ORIG_SERVICE_DATE, 
        TYPE, 
        INT_PAT_ID, 
        PAT_ENC_CSN_ID, 
        TDL_ID, 
        MATCH_PROV_ID
    FROM CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_TDL_TRAN AS cd
    
    UNION
    
    SELECT 
        DX_THREE_ID AS DX_ID, 
        'N' AS P_DX, 
        ORIG_SERVICE_DATE, 
        TYPE, 
        INT_PAT_ID, 
        PAT_ENC_CSN_ID, 
        TDL_ID, 
        MATCH_PROV_ID
    FROM CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_TDL_TRAN AS cd
    
    UNION
    
    SELECT 
        DX_FOUR_ID AS DX_ID, 
        'N' AS P_DX, 
        ORIG_SERVICE_DATE, 
        TYPE, 
        INT_PAT_ID, 
        PAT_ENC_CSN_ID, 
        TDL_ID, 
        MATCH_PROV_ID
    FROM CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_TDL_TRAN AS cd
    
    UNION
    
    SELECT 
        DX_FIVE_ID AS DX_ID, 
        'N' AS P_DX, 
        ORIG_SERVICE_DATE, 
        TYPE, 
        INT_PAT_ID, 
        PAT_ENC_CSN_ID, 
        TDL_ID, 
        MATCH_PROV_ID
    FROM CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_TDL_TRAN AS cd
    
    UNION
    
    SELECT 
        DX_SIX_ID AS DX_ID, 
        'N' AS P_DX, 
        ORIG_SERVICE_DATE, 
        TYPE, 
        INT_PAT_ID, 
        PAT_ENC_CSN_ID, 
        TDL_ID, 
        MATCH_PROV_ID
    FROM CARE_BRONZE_CLARITY_PROD.DBO.CLARITY_TDL_TRAN AS cd
) T_UNION_CLARITY_TDL_TRAN
WHERE DX_ID IS NOT NULL                                -- Exclude records with no diagnosis
GROUP BY 
    T_UNION_CLARITY_TDL_TRAN.DX_ID, 
    INT_PAT_ID, 
    PAT_ENC_CSN_ID;